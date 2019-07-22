//
//  BaseService.swift
//  FANZY
//
//  Created by 김연준 on 14/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation

class BaseService {
  unowned let provider: ServiceProviderType
  
  init(provider: ServiceProviderType) {
    self.provider = provider
  }
}
