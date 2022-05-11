//
//  Network.swift
//  CheckStatus
//
//  Created by chen he on 2021/5/28.
//

import Foundation

struct Network {
    static func searchASC(state: String = "WA", completion: @escaping ([ASC]) -> Void) -> URLSessionTask {
        let urlString = "https://my.uscis.gov/appointmentscheduler-appointment/field-offices/state/" + state
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession(configuration: .ephemeral).dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion([])
                return
            }
            do {
                let centers = try JSONDecoder().decode([ASC].self, from: data)
                completion(centers)
            } catch {
                print(error)
                completion([])
            }
        }
        return task
    }
}
