//
//  Appointment.swift
//  CheckStatus
//
//  Created by chen he on 5/11/22.
//

import Cocoa

enum Status: String, Codable {
    case ACTIVE
}

class ASC: NSObject, Codable {
    let assignedServiceCenter: String
    let centerDescription: String
    let status: Status
    let address: Address
    let timeSlots: [TimeSlot]
    
    enum CodingKeys: String, CodingKey {
        case assignedServiceCenter
        case centerDescription = "description"
        case status
        case address
        case timeSlots
    }
}
extension ASC {
    var statusText: String {
        switch status {
        case .ACTIVE:
            return "Active Now"
        }
    }
    
    var textColor: NSColor {
        return timeSlots.isEmpty ? .placeholderTextColor : .controlAccentColor
    }
    
    var iconName: String {
        switch status {
        case .ACTIVE:
            return "timer"
        }
    }
}
