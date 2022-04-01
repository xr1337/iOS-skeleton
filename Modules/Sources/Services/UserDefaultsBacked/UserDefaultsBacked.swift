//
//  UserDefaultsBacked.swift
//
//  Created by Sufiyan Yasa on 23/06/2021.
//

import Foundation
import Constants

// Since our property wrapper's Value type isn't optional, but
// can still contain nil values, we'll have to introduce this
// protocol to enable us to cast any assigned value into a type
// that we can compare against nil:
private protocol AnyOptional {
  var isNil: Bool { get }
}

extension Optional: AnyOptional {
  var isNil: Bool { self == nil }
}

@propertyWrapper public struct UserDefaultsBacked<Value> {
  public var wrappedValue: Value {
    get {
      let value = storage.value(forKey: key) as? Value
      return value ?? defaultValue
    }
    set {
      if let optional = newValue as? AnyOptional, optional.isNil {
        storage.removeObject(forKey: key)
        NSUbiquitousKeyValueStore.default.removeObject(forKey: key)
      } else {
        storage.setValue(newValue, forKey: key)
        NSUbiquitousKeyValueStore.default.set(newValue, forKey: key)
      }
    }
  }

  private let key: String
  private let defaultValue: Value
  private let storage: UserDefaults

  public init(wrappedValue defaultValue: Value,
       key: String,
       storage: UserDefaults = .init(suiteName: Constants.Persistence.AppGroupID) ?? .standard) {
    self.defaultValue = defaultValue
    self.key = key
    self.storage = storage
  }
}

extension UserDefaultsBacked where Value: ExpressibleByNilLiteral {
  init(key: String, storage: UserDefaults = .init(suiteName: Constants.Persistence.AppGroupID) ?? .standard) {
    self.init(wrappedValue: nil, key: key, storage: storage)
  }
}
