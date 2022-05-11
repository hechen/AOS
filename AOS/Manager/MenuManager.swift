//
//  MenuManager.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

import AppKit

class MenuManager: NSObject, NSMenuDelegate {
    let statusMenu: NSMenu
    var menuIsOpen = false
    
    // hard code
    let itemsBeforeOffices = 2
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
            let itemFrame = NSRect(x: 0, y: 0, width: 200, height: 40)
            let view = RefreshingView(frame: itemFrame)
            item.view = view
            statusMenu.insertItem(item, at: index)
            return
        }
        
        guard !ascManager.offices.isEmpty else {
            let item = NSMenuItem()
            item.title = "Select state first"
            statusMenu.insertItem(item, at: index)
            return
        }
                
        let itemFrame = NSRect(x: 0, y: 0, width: 200, height: 40)
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
                    timeslot.times.map { time in
                        return timeslot.date + " - " + time
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
