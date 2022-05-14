//
//  ASCManager.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

import AppKit
import Combine

/*
 You can treat ASCManager as a ViewModel
 */
class ASCManager: NSObject {
    @objc dynamic var offices = [ASC]()
    
    // for lazy read
    private(set) var loading: Bool = false
    
    var timerCancellable: AnyCancellable?
    var autoRefresh: AnyCancellable?
    var subscriptions = Set<AnyCancellable>()
    
    var nearestTimeslot: Date? {
        offices.flatMap(\.timeSlots).map(\.dates).reduce([], +).sorted(by: <).first
    }
    
    let reminder = Reminder()
    override init() {
        super.init()
        
        Preferences.standard
            .preferencesChangedSubject
            .filter { changedKeyPath in changedKeyPath == \Preferences.autoRefreshEnabled }
            .sink { [weak self] _ in
                if Preferences.standard.autoRefreshEnabled {
                    self?.startTimer()
                } else {
                    self?.stopTimer()
                }
            }
            .store(in: &subscriptions)
        
        Preferences.standard.preferencesChangedSubject
            .filter { changedKeyPath in changedKeyPath == \Preferences.refreshInterval }
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] _ in
                self?.startTimer()
            }
            .store(in: &subscriptions)
        
        Preferences.standard
            .preferencesChangedSubject
            .filter { changedKeyPath in changedKeyPath == \Preferences.selectedState }
            .sink { [weak self] _ in
                self?.refreshOffices()
            }
            .store(in: &subscriptions)
    }

    // MARK: - Timer
    func startTimer() {
        // in case timer is running.
        stopTimer()
        
        let interval = TimeInterval(Preferences.standard.refreshInterval) * 60
        timerCancellable = Timer.publish(every: interval, tolerance: 0.5, on: .current, in: .common).autoconnect().sink { _ in
            self.refreshOffices()
        }
    }
    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    func refreshOffices() {
        if Preferences.standard.selectedState.isEmpty, Preferences.standard.searchZipCode.isEmpty {
            offices = []
            return
        }
        
        var urlString = ""
        if !Preferences.standard.searchZipCode.isEmpty {
            let zipCode = Preferences.standard.searchZipCode
            urlString = "https://my.uscis.gov/appointmentscheduler-appointment/field-offices/zipcode/\(zipCode)"
        } else {
            let state = Preferences.standard.selectedState
            urlString = "https://my.uscis.gov/appointmentscheduler-appointment/field-offices/state/" + state
        }
                
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        
    
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.loading = true
            }, receiveCompletion: { [weak self] _ in
                self?.loading = false
            }, receiveCancel: { [weak self] in
                self?.loading = false
            })
            .map(\.data)
            .decode(type: [ASC].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    print("Fetch Centers Failed. Error: \(err)")
                }
            }, receiveValue: { [weak self] centers in                
                Preferences.standard.lastRefreshDate = Date()
                
                self?.offices = centers
                
                self?.notifyIfNeeded()
            })
            .store(in: &subscriptions)
    }
    
    // TODO: add observation
    // MainActor
    private func notifyIfNeeded() {
        // the simplest way is to check equality...
        guard !OfficeObserver.shared.officesToObserve.isEmpty else { return }
        
        let needAlert = !offices.filter { office in
            OfficeObserver.shared.officesToObserve.contains { observedOffice in
                office.assignedServiceCenter == observedOffice.assignedServiceCenter
            }
        }.filter {
            !$0.timeSlots.isEmpty
        }.isEmpty
        
        guard needAlert else {
            return
        }
        
        // check if user has some specific observation
        if reminder.newTimeSlotFound() == .alertFirstButtonReturn {
            NSWorkspace.shared.open(URL(string: "https://my.uscis.gov/appointmentscheduler-appointment/ca/en/office-search")!)
        }
    }
}
