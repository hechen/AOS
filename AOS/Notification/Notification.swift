//
//  Notification.swift
//  AOS
//
//  Created by chen he on 5/12/22.
//

import Foundation

extension NSNotification.Name {
    static let notifyWhenSlotsAvailable = NSNotification.Name("aos.notifications.notifyWhenSlotsAvailable")
}


class OfficeObserver {
    static let shared = OfficeObserver()
    private init() {
        NotificationCenter.default.addObserver(forName: .notifyWhenSlotsAvailable, object: nil, queue: .main) { notification in
            guard let office = notification.object as? ASC else {
                return
            }
            self.officesToObserve.append(office)
        }
    }
    
    private(set) var officesToObserve = [ASC]()
    func addToObservation(office: ASC) {
        officesToObserve.append(office)
    }
}
