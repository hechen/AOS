//
//  Utility.swift
//  AOS
//
//  Created by chen he on 5/13/22.
//

import Foundation

struct Utility {
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        return df
    }()
}
