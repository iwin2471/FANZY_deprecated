//
//  UserDefaultsKey.swift
//  FANZY
//
//  Created by 김연준 on 06/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation

struct UserDefaultsKey<T> {
  typealias Key<T> = UserDefaultsKey<T>
  let key: String
}

extension UserDefaultsKey: ExpressibleByStringLiteral {
  public init(unicodeScalarLiteral value: StringLiteralType) {
    self.init(key: value)
  }
  
  public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
    self.init(key: value)
  }
  
  public init(stringLiteral value: StringLiteralType) {
    self.init(key: value)
  }
}
