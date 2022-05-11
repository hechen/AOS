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
        let message = "Your break time has finished.\n\n" +
        "Start your next task now or use the menu to start it when you're ready."
        
        let buttonTitles = ["Start Next Task", "OK"]
        
        let response = openAlert(title: "Break Over", message: message, buttonTitles: buttonTitles)
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

extension Reminder {
    func sendNotification(title: String, message: String, category: String? = nil) {
        checkNotificationPermissions()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        content.interruptionLevel = .active
        
        if let category = category {
            content.categoryIdentifier = category
        }
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil)
        
        UNUserNotificationCenter.current().add(request)
    }
}

extension Reminder: UNUserNotificationCenterDelegate {
    /// Check notification permissions and request if not already granted.
    func checkNotificationPermissions() {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound]
            ) { _, error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
    }
    
    /// Set up an action and action category so the notification can show an action button.
    func defineActionCategory() {
        let startNextAction = UNNotificationAction(
            identifier: "START_NEXT_ACTION",
            title: "Start Next Task")
        
        let category = UNNotificationCategory(
            identifier: "ACTIONS_CATEGORY",
            actions: [startNextAction],
            intentIdentifiers: [])
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.setNotificationCategories([category])
    }
    
    /// Wait for the user to interact with the notification.
    /// Check if they have clicked an action button.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler:
        @escaping () -> Void
    ) {
//        switch response.actionIdentifier {
//        case "START_NEXT_ACTION":
//            startNextTaskFunc?()
//        default:
//            break
//        }
        completionHandler()
    }
    
    /// Present notification as a banner even if the menu is open.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler(.banner)
    }
}
