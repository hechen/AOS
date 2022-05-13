//
//  TimeSlot.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

import Foundation

struct TimeSlot: Codable {
    let formattedDate: String
    let formattedTimes: [String]
    
    enum CodingKeys: String, CodingKey {
        case formattedDate = "date"
        case formattedTimes = "times"
    }
}

extension TimeSlot {
    // date: 2022-06-07
    // time: 13:00
    var dates: [Date] {
        formattedTimes.compactMap { DataStore.dateFormatter.date(from: formattedDate + " " + $0) }
    }
}

