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
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        return df
    }()
}

extension TimeSlot {
    // date: 2022-06-07
    // time: 13:00
    var dates: [Date] {
        formattedTimes.compactMap { TimeSlot.dateFormatter.date(from: formattedDate + " " + $0) }
    }
}

