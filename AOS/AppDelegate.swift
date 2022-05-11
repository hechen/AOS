//
//  AppDelegate.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

import Cocoa
import SwiftUI
import LaunchAtLogin

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var preferencesMenuItem: NSMenuItem!
    
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
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func didClickRefresh(_ sender: Any) {
        menuManager?.ascManager.refresh()
    }
    
    @IBAction func didClickPreferences(_ sender: Any) {
        let hostingController = NSHostingController(rootView: PreferenceView())
        let window = NSWindow(contentViewController: hostingController)
        window.title = "Preferences"
        
        let controller = NSWindowController(window: window)
        
        NSApp.activate(ignoringOtherApps: true)
        controller.showWindow(nil)
    }
    
    func updateMenuItems() {
        guard menuManager?.menuIsOpen == true else {
            return
        }        
        menuManager?.updateMenuItems()
    }
}

