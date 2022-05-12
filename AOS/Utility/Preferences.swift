//
//  Preferences.swift
//  AOS
//
//  Created by chen he on 5/11/22.
//

/*
 Copyright:
 References: https://www.avanderlee.com/swift/appstorage-explained/
 */

import SwiftUI
import Combine

@propertyWrapper
struct Preference<Value>: DynamicProperty {
    @ObservedObject private var preferencesObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<Preferences, Value>
    private let preferences: Preferences
    
    init(_ keyPath: ReferenceWritableKeyPath<Preferences, Value>, preferences: Preferences = .standard) {
        self.keyPath = keyPath
        self.preferences = preferences
        let publisher = preferences.preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }
            .map { _ in () }
            .eraseToAnyPublisher()
        
        self.preferencesObserver = .init(publisher: publisher)
    }

    var wrappedValue: Value {
        get { preferences[keyPath: keyPath] }
        nonmutating set { preferences[keyPath: keyPath] = newValue }
    }

    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

final class Preferences {
    static let standard = Preferences(userDefaults: .standard)
    let userDefaults: UserDefaults
    
    /// Sends through the changed key path whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    @UserDefault(PreferencesKeys.selectedState)
    var selectedState: String = ""
    
    @UserDefault(PreferencesKeys.autoRefreshEnabled)
    var autoRefreshEnabled: Bool = false
    
    @UserDefault(PreferencesKeys.refreshInterval)
    var refreshInterval: Frequency = .halfHour
        
    private enum PreferencesKeys {
        static let selectedState = "SelectedState"
        static let autoRefreshEnabled = "AutoRefreshEnabled"
        static let refreshInterval = "RefreshInterval"
    }
}


