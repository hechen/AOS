//
//  PublisherObservableObject.swift
//  AOS
//
//  Created by chen he on 5/12/22.
//

import Foundation
import Combine

final class PublisherObservableObject: ObservableObject {
    var subscriber: AnyCancellable?
    
    init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        })
    }
}
