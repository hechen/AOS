//
//  Notification.swift
//  AOS
//
//  Created by chen he on 5/12/22.
//

import Foundation

extension NSNotification.Name {
    static let notifyWhenSlotsAvailable = NSNotification.Name("aos.notifications.notifyWhenSlotsAvailable")
    static let unnotifyWhenSlotsAvailable = NSNotification.Name("aos.notifications.unnotifyWhenSlotsAvailable")
}

class OfficeObserver {
    static let shared = OfficeObserver()
    private init() {
        NotificationCenter.default.addObserver(forName: .notifyWhenSlotsAvailable, object: nil, queue: .main) { notification in
            guard let office = notification.object as? ASC else {
                return
            }
            self.addToObservation(office: office)
        }
        NotificationCenter.default.addObserver(forName: .unnotifyWhenSlotsAvailable, object: nil, queue: .main) {
            notification in
            guard let office = notification.object as? ASC else {
                return
            }
            self.removeObservaton(office: office)
        }
    }
    
    private(set) var officesToObserve = [ASC]()
    func addToObservation(office: ASC) {
        officesToObserve.append(office)
    }
    func removeObservaton(office: ASC) {
        officesToObserve.removeAll {
            $0.assignedServiceCenter == office.assignedServiceCenter
        }
    }
}
