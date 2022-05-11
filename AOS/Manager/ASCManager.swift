//
//  ASCManager.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

import AppKit
import Combine

class ASCManager {
    var offices = [ASC]()
    var timerCancellable: AnyCancellable?
    
    public private(set) var loading: Bool = false
    
    init() {
        if UserDefaults.standard.bool(forKey: "AutoRefresh") == true {
            startTimer()
        }
        refresh()
    }
    
    func startTimer() {
        let interval = max(UserDefaults.standard.double(forKey: "RefreshInterval"), 30*60)
        timerCancellable = Timer.publish(every: interval, tolerance: 0.5, on: .current, in: .common)
            .autoconnect()
            .sink { _ in
                self.refresh()
            }
    }
    
    func refresh() {
        refreshOffices()
    }
    
    private func refreshOffices() {
        guard let selectedState = UserDefaults.standard.string(forKey: "SelectedState") else {
            return
        }
        loading = true
        Network.searchASC(state: selectedState) { offices in
            self.offices = offices
            self.loading = false
            
            DispatchQueue.main.async {
                self.updateMenuItems()
            }
        }.resume()
    }
    
    // Main Actor
    private func updateMenuItems() {
        if let appDelegate = NSApp.delegate as? AppDelegate {
            appDelegate.updateMenuItems()
        }
    }
}
