//
//  MenuManager.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

import AppKit


/*
 Menu Layout
 ┌────────────────────────┐
 │ ┌────────────────────┐ │
 │ │     About AOS      │ │
 │ └────────────────────┘ │
 │ ────────────────────── │
 │                        │
 │                        │
 │                        │
 │                        │
 │                        │
 │                        │
 │ ────────────────────── │
 │┌─────────────────────┐ │
 ││       Refresh       │ │
 │└─────────────────────┘ │
 │┌─────────────────────┐ │
 ││     Preferences     │ │
 │└─────────────────────┘ │
 │┌─────────────────────┐ │
 ││       Quit          │ │
 │└─────────────────────┘ │
 └────────────────────────┘
 
 */
class MenuManager: NSObject, NSMenuDelegate {
    let statusMenu: NSMenu
    var menuIsOpen = false
    
    // hard code
    let itemsBeforeOffices = 2          // About, Seperator
    let itemsAfterOffices = 4           // Seperator, Refresh, Preferences, Quit
    
    let ascManager = ASCManager()
    
    init(statusMenu: NSMenu) {
        self.statusMenu = statusMenu
        super.init()
    }
    
    // MARK: - NSMenuDelegate
    
    func menuWillOpen(_ menu: NSMenu) {
        menuIsOpen = true
        showOfficesInMenu()
    }
    func menuDidClose(_ menu: NSMenu) {
        menuIsOpen = false
        clearOfficesFromMenu()
    }
    
    
    // MARK: - Public
    func updateMenuItems() {
        clearOfficesFromMenu()
        showOfficesInMenu()
    }
    
    // MARK: - Menu Items
    func clearOfficesFromMenu() {
        let stopAtIndex = statusMenu.items.count - itemsAfterOffices
        for _ in itemsBeforeOffices ..< stopAtIndex {
            statusMenu.removeItem(at: itemsBeforeOffices)
        }
    }
    func showOfficesInMenu() {
        var index = itemsBeforeOffices
        
        if ascManager.loading {
            let item = NSMenuItem()
            let itemFrame = NSRect(x: 0, y: 0, width: 240, height: 40)
            let view = RefreshingView(frame: itemFrame)
            item.view = view
            statusMenu.insertItem(item, at: index)
            return
        }
        
        // not loading, there must be no state has been set up.
        guard !ascManager.offices.isEmpty else {
            let item = NSMenuItem()
            item.title = "Input ZIP or state."
            statusMenu.insertItem(item, at: index)
            return
        }
        
        let itemFrame = NSRect(x: 0, y: 0, width: 240, height: 40)
        for office in ascManager.offices {
            let item = NSMenuItem()
            let view = OfficeView(frame: itemFrame)
            view.office = office
            item.view = view
            
            statusMenu.insertItem(item, at: index)
            index += 1

            if !office.timeSlots.isEmpty {
                item.submenu = NSMenu()
                for timeslot in office.timeSlots {
                    item.submenu?.addItem(NSMenuItem.separator())
                    timeslot.formattedTimes.map { time in
                        timeslot.formattedDate + " - " + time
                    }.forEach {
                        let sumMenuItem = NSMenuItem()
                        sumMenuItem.title = $0
                        item.submenu?.addItem(sumMenuItem)
                    }
                }
            }
        }
    }
}
