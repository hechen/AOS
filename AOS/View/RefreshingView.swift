//
//  RefreshingView.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

import Cocoa

// 200*40
class RefreshingView: NSView {
    var titleLabel: NSTextField
    var loadingIndicator: NSProgressIndicator
    
    override init(frame frameRect: NSRect) {
        let loadingIndicatorFrame = NSRect(x: 20, y: 10, width: 20, height: 20)
        loadingIndicator = NSProgressIndicator(frame: loadingIndicatorFrame)
        loadingIndicator.style = .spinning
        loadingIndicator.isIndeterminate = true
        
        // 20 + 20 - 10 - 
        let titleFrame = NSRect(x: 50, y: 10, width: 100, height: 20)
        titleLabel = NSTextField(frame: titleFrame)
        titleLabel.backgroundColor = .clear
        titleLabel.isBezeled = false
        titleLabel.isEditable = false
        titleLabel.font = NSFont.systemFont(ofSize: 14)
        titleLabel.lineBreakMode = .byTruncatingTail
        
        super.init(frame: frameRect)
        
        addSubview(loadingIndicator)
        addSubview(titleLabel)
        
        titleLabel.stringValue = "Refreshing..."
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
