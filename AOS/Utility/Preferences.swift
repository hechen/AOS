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

final class PublisherObservableObject: ObservableObject {
    var subscriber: AnyCancellable?
    
    init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        })
    }
}

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


@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    
    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    var wrappedValue: Value {
        get { fatalError()}
        set { fatalError()}
    }
    
    init(wrappedValue: Value, _ key: String) {
        self.defaultValue = wrappedValue
        self.key = key
    }
    
    public static subscript(_enclosingInstance instance: Preferences,
                            wrapped wrappedKeyPath: ReferenceWritableKeyPath<Preferences, Value>,
                            storage storageKeyPath: ReferenceWritableKeyPath<Preferences, Self>) -> Value {
        
        get {
            let container = instance.userDefaults
            let key = instance[keyPath: storageKeyPath].key
            let defaultValue = instance[keyPath: storageKeyPath].defaultValue
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        
        set {
            let container = instance.userDefaults
            let key = instance[keyPath: storageKeyPath].key
            container.set(newValue, forKey: key)
            instance.preferencesChangedSubject.send(wrappedKeyPath)
        }
        
    }
}

final class Preferences {
    static let standard = Preferences(userDefaults: .standard)
    fileprivate let userDefaults: UserDefaults
    
    /// Sends through the changed key path whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    @UserDefault(PreferencesKeys.selectedState)
    var selectedState: String = ""
    
    @UserDefault(PreferencesKeys.searchZipCode)
    var searchZipCode: String = ""
    
    @UserDefault(PreferencesKeys.autoRefreshEnabled)
    var autoRefreshEnabled: Bool = false
    
    @UserDefault(PreferencesKeys.refreshInterval)
    var refreshInterval: Int = 30        // 30 Min by default
    
    @UserDefault(PreferencesKeys.lastRefreshDate)
    var lastRefreshDate: Date = Date()
    
    private enum PreferencesKeys {
        static let searchZipCode = "SearchZipCode"
        static let selectedState = "SelectedState"
        static let autoRefreshEnabled = "AutoRefreshEnabled"
        static let refreshInterval = "RefreshInterval"
        static let lastRefreshDate = "LastRefreshDate"
    }
}
