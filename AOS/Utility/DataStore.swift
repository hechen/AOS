//
//  DataStore.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

import Foundation

struct DataStore {
    static let statesDictionary = ["Alabama": "AL",
            "Alaska": "AK",
            "Arizona": "AZ",
            "Arkansas": "AR",
            "California": "CA",
            "Colorado": "CO",
            "Connecticut": "CT",
            "Delaware": "DE",
            "Florida": "FL",
            "Georgia": "GA",
            "Hawaii": "HI",
            "Idaho": "ID",
            "Illinois": "IL",
            "Indiana": "IN",
            "Iowa": "IA",
            "Kansas": "KS",
            "Kentucky": "KY",
            "Louisiana": "LA",
            "Maine": "ME",
            "Maryland": "MD",
            "Massachusetts": "MA",
            "Michigan": "MI",
            "Minnesota": "MN",
            "Mississippi": "MS",
            "Missouri": "MO",
            "Montana": "MT",
            "Nebraska": "NE",
            "Nevada": "NV",
            "New Hampshire": "NH",
            "New Jersey": "NJ",
            "New Mexico": "NM",
            "New York": "NY",
            "North Carolina": "NC",
            "North Dakota": "ND",
            "Ohio": "OH",
            "Oklahoma": "OK",
            "Oregon": "OR",
            "Pennsylvania": "PA",
            "Rhode Island": "RI",
            "South Carolina": "SC",
            "South Dakota": "SD",
            "Tennessee": "TN",
            "Texas": "TX",
            "Utah": "UT",
            "Vermont": "VT",
            "Virginia": "VA",
            "Washington": "WA",
            "West Virginia": "WV",
            "Wisconsin": "WI",
            "Wyoming": "WY"]

    
    
    static func stateByCode(_ code: String) -> String? {
        return statesDictionary[code]
    }
    
    static func codeByName(_ name: String) -> String? {
        return statesDictionary[name]
    }
}

enum Frequency: String, CaseIterable, Identifiable {
    case halfHour
    case hour
    case day
    
    var itemDesc: String {
        switch self {
        case .halfHour: return "30 Minutes"
        case .hour: return "Every Hour"
        case .day: return "Every Day"
        }
    }
    var timeInterval: TimeInterval {
        switch self {
        case .halfHour: return 30*60
        case .hour: return 60*60
        case .day: return 12*60*60
        }
    }
    
    var id: Self { self }
}
