//
//  Frequency.swift
//  AOS
//
//  Created by chen he on 5/12/22.
//

import Foundation

enum Frequency: String, Codable, CaseIterable, Identifiable {
    case tenMinutes
    case halfHour
    case hour
    case threeHours
    case day
    
    var timeInterval: TimeInterval {
        switch self {
        case .tenMinutes: return 10*60
        case .halfHour: return 30*60
        case .hour: return 60*60
        case .threeHours: return 3*60*60
        case .day: return 12*60*60
        }
    }
    var id: Self { self }
}
extension Frequency {
    var timeDesc: String {
        switch self {
        case .tenMinutes: return "10 Minutes"
        case .halfHour: return "30 Minutes"
        case .hour: return "Every Hour"
        case .threeHours: return "Three Hours"
        case .day: return "Every Day"
        }
    }
}
