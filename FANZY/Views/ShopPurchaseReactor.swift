//
//  ShopPurchaseReactor.swift
//  FANZY
//
//  Created by 김연준 on 16/06/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class ShopPurchaseReactor: Reactor {
  typealias Action = NoAction
  
  let initialState: Goods
  
  init(goods: Goods) {
    self.initialState = goods
  }
}
