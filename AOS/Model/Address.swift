//
//  Address.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

import Foundation

struct Address: Codable {
    let street1: String
    let street2: String?
    let city: String
    let state: String
    let zipcode: String
    let zipcodeplus4: String?
}
