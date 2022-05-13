//
//  AppDelegate.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

import Cocoa
import SwiftUI
import Combine
import LaunchAtLogin

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var preferencesMenuItem: NSMenuItem!
    @IBOutlet weak var refreshMenuItem: NSMenuItem!
    
    
    var menuManager: MenuManager?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(   withLength: NSStatusItem.variableLength)
        statusItem?.menu = statusMenu
        statusItem?.button?.title = "AOS"
        statusItem?.button?.imagePosition = .imageLeading
        statusItem?.button?.image = NSImage(systemSymbolName: "location.viewfinder", accessibilityDescription: "Appointment Office Search")
        statusItem?.button?.font = .monospacedDigitSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
        
        menuManager = MenuManager(statusMenu: statusMenu)
        statusMenu.delegate = menuManager
        
        menuManager?.ascManager.publisher(for: \.offices)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateMenuItems()
            }
            .store(in: &subscriptions)

        Preferences.standard
            .preferencesChangedSubject
            .filter { changedKeyPath in changedKeyPath == \Preferences.lastRefreshDate }
            .sink { [weak self] _ in
                self?.refreshMenuItem.title = "Refresh (\(DataStore.dateFormatter.string(from: Preferences.standard.lastRefreshDate)))"
            }
            .store(in: &subscriptions)
        
        // first time, load data
        menuManager?.ascManager.refreshOffices()
    }
    var subscriptions = Set<AnyCancellable>()
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    
    // MARK: - Actions
    
    @IBAction func didClickRefresh(_ sender: Any) {
        menuManager?.ascManager.refreshOffices()
    }
    
    @IBAction func didClickPreferences(_ sender: Any) {
        let hostingController = NSHostingController(rootView: PreferenceView())
        let window = NSWindow(contentViewController: hostingController)
        window.title = "Preferences"
        
        let controller = NSWindowController(window: window)
        
        NSApp.activate(ignoringOtherApps: true)
        controller.showWindow(nil)
    }
    
    private func updateMenuItems() {
        guard let menuManager = menuManager else {
            return
        }
        
        // update menu bar button
        var title = "AOS - "
        if menuManager.ascManager.offices.isEmpty {
            title += "No Available Offices"
        } else {
            title += "\(menuManager.ascManager.offices.count) Offices, "
            if let date = menuManager.ascManager.nearestTimeslot {
                title += "Nearest time is \(DataStore.dateFormatter.string(from: date))"
            } else {
                title += "No Available Slots"
            }
        }
        
        statusItem?.button?.title = title
        guard menuManager.menuIsOpen else {
            return
        }
        menuManager.updateMenuItems()
    }
}
