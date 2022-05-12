//
//  Reminder.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

import AppKit
import UserNotifications

class Reminder: NSObject {
    func newTimeSlotFound() -> NSApplication.ModalResponse {
        let message = "Found new timeslots on Application Center"
        let buttonTitles = ["Go to the website", "OK"]
        let response = openAlert(title: "TimeSlot Notification", message: message, buttonTitles: buttonTitles)
        return response
    }
    
    @discardableResult
    func openAlert(title: String, message: String, buttonTitles: [String] = []) -> NSApplication.ModalResponse {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        
        for buttonTitle in buttonTitles {
            alert.addButton(withTitle: buttonTitle)
        }
        
        NSApp.activate(ignoringOtherApps: true)
        
        let response = alert.runModal()
        return response
    }
}

