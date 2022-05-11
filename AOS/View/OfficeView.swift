//
//  OfficeView.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

import Cocoa

class OfficeView: NSView {
    var office: ASC?
    
    var imageView: NSImageView
    var titleLabel: NSTextField
    var infoLabel: NSTextField
    
    override init(frame frameRect: NSRect) {
        // set up subviews
        let imageFrame = NSRect(x: 10, y: 10, width: 20, height: 20)
        imageView = NSImageView(frame: imageFrame)
        imageView.imageScaling = .scaleProportionallyUpOrDown
        
        let titleFrame = NSRect(x: 40, y: 20, width: 220, height: 16)
        titleLabel = NSTextField(frame: titleFrame)
        
        let infoProgressFrame = NSRect(x: 40, y: 4, width: 220, height: 14)
        infoLabel = NSTextField(frame: infoProgressFrame)
        
        titleLabel = NSTextField(frame: titleFrame)
        titleLabel.backgroundColor = .clear
        titleLabel.isBezeled = false
        titleLabel.isEditable = false
        titleLabel.font = NSFont.systemFont(ofSize: 14)
        titleLabel.lineBreakMode = .byTruncatingTail
        
        infoLabel = NSTextField(frame: infoProgressFrame)
        infoLabel.backgroundColor = .clear
        infoLabel.isBezeled = false
        infoLabel.isEditable = false
        infoLabel.font = NSFont.systemFont(ofSize: 11)
        
        super.init(frame: frameRect)
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(infoLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if let office = office {
            let color = office.textColor
            
            imageView.image = NSImage(systemSymbolName: office.iconName, accessibilityDescription: office.statusText)
            imageView.contentTintColor = color
            
            titleLabel.stringValue = office.centerDescription
            titleLabel.textColor = color
            
            infoLabel.stringValue = office.timeSlots.isEmpty ? "No available timeslot" : "\(office.timeSlots.count) timeslots"
            infoLabel.textColor = color
        }
    }
}
