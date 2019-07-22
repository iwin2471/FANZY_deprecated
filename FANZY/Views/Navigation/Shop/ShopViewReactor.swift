//
//  ShopViewReactor.swift
//  FANZY
//
//  Created by 김연준 on 16/04/2019.
//  Copyright © 2019 underpin. All rights reserved.

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift

typealias ShopSectionModel = SectionModel<ShopSection, ShopItem>

enum ShopSection {
  case option
  case shop
}

class ShopItem {
  let goodsItem:ShopPurchaseReactor
  
  enum ItemCase {
    case Item(name: String)
    case Goods(goods: ShopPurchaseReactor)
  }
  
  
  init(goods: ShopPurchaseReactor) {
    goodsItem = goods
  }
  
  func returnItem() -> Goods {
    return goodsItem.currentState
  }
  
  func returnItemReactor() -> ShopPurchaseReactor{
    return goodsItem
  }
}

final class ShopViewReactor: Reactor {
  enum Action {
    case refresh
    case filter(catagory: String)
  }
  
  enum Mutation {
    case setItems([ShopSectionModel])
    case filtering([ShopSectionModel])
  }
  
  struct State {
    var goodsItems: [ShopSectionModel]
  }
  
  let provider: ServiceProviderType
  let initialState: State
  
  init(provider: ServiceProviderType) {
    self.provider = provider
    self.initialState = State(
      goodsItems: [ShopSectionModel(model: ShopSection.shop, items: [])]
    )
  }
  
  func mutate(action: ShopViewReactor.Action) -> Observable<ShopViewReactor.Mutation> {
    switch action {
    case .refresh:
      return self.provider.storeService.fetchItems()
        .map {
          var newValue = [ShopItem]()
          newValue = $0.map {
            let reactor = ShopPurchaseReactor(goods: $0)
            return ShopItem(goods: reactor)
          }
          let goodsItem = ShopSectionModel(model: ShopSection.shop, items: newValue)
          return .setItems([goodsItem])
        }
    case let .filter(catagory):
      return self.provider.storeService.filterItems(catagory: catagory).map {
        var newValue = [ShopItem]()
        
        newValue = $0!.map {
          let reactor = ShopPurchaseReactor(goods: $0)
          return ShopItem(goods: reactor)
        }
        
        let goodsItem = ShopSectionModel(model: ShopSection.shop, items: newValue)
        
        return .filtering([goodsItem])
      }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
    case let .setItems(goodsItems):
      state.goodsItems = goodsItems
      
    case let .filtering(ShopSectionModel):
      state.goodsItems = ShopSectionModel
    }
    
    return state
  }
}
