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
    @Published var loading: Bool = false
    
    var timerCancellable: AnyCancellable?
    var autoRefresh: AnyCancellable?
    var subscriptions = Set<AnyCancellable>()
    
    var nearestTimeslot: Date? {
        offices.flatMap(\.timeSlots).map(\.dates).reduce([], +).first
    }
    
    let reminder = Reminder()
    
    override init() {
        super.init()
        
        Preferences.standard
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == \Preferences.autoRefreshEnabled
                || changedKeyPath == \Preferences.refreshInterval
            }.sink { _ in
                if Preferences.standard.autoRefreshEnabled {
                    self.startTimer()
                } else {
                    self.stopTimer()
                }
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Timer
    func startTimer() {
        stopTimer()
        
        print("Start Timer...")
        let interval = max(Preferences.standard.refreshInterval.timeInterval, 10 * 60)
        timerCancellable = Timer.publish(every: interval, tolerance: 0.5, on: .current, in: .common)
            .autoconnect()
            .sink { _ in
                self.refreshOffices()
            }
    }
    func stopTimer() {
        print("Stop Timer...")
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    func refreshOffices() {
        guard !Preferences.standard.selectedState.isEmpty else {
            return
        }
        
        let state = Preferences.standard.selectedState
        let urlString = "https://my.uscis.gov/appointmentscheduler-appointment/field-offices/state/" + state
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [ASC].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    print("Fetch Centers Failed. Error: \(err)")
                }
            }, receiveValue: { [weak self] centers in
                self?.offices = centers
            })
            .store(in: &subscriptions)
    }
    
    private func notifyIfNeeded(previous: [ASC], latest: [ASC]) {
        // the simplest way is to check equality...
        // we only notify when there are new slots
        guard !latest.isEmpty else {
            return
        }
        
#if DEBUG
        // check if user has some specific observation
        if reminder.newTimeSlotFound() == .alertFirstButtonReturn {
            NSWorkspace.shared.open(URL(string: "https://my.uscis.gov/appointmentscheduler-appointment/ca/en/office-search")!)
        }
#endif
    }
}
