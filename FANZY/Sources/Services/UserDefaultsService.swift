//
//  UserDefaultsKey.swift
//  FANZY
//
//  Created by 김연준 on 06/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation

extension UserDefaultsKey {
  static var chats: Key<[[String: Any]]> { return "Chats" }
  static var goods: Key<[[String: Any]]> { return "Goods" }
}

protocol UserDefaultsServiceType {
  func value<T>(forKey key: UserDefaultsKey<T>) -> T?
  func set<T>(value: T?, forKey key: UserDefaultsKey<T>)
}

final class UserDefaultsService: BaseService, UserDefaultsServiceType {
  
  private var defaults: UserDefaults {
    return UserDefaults.standard
  }
  
  func value<T>(forKey key: UserDefaultsKey<T>) -> T? {
    return self.defaults.value(forKey: key.key) as? T
  }
  
  func set<T>(value: T?, forKey key: UserDefaultsKey<T>) {
    self.defaults.set(value, forKey: key.key)
    self.defaults.synchronize()
  }
  
}
