//
//  WalletViewReactor.swift
//  FANZY
//
//  Created by 김연준 on 10/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift

enum RevenueSection {
  case revenue
  case transfer
  case watch
}

typealias RevenueCellSelection = SectionModel<RevenueSection, Wallet>

final class WalletViewReactor: Reactor {
  enum Action {
    case getRevenues
    case getTransfers
    case getWatchRevenues
  }
  
  enum Mutation {
    case setRevenues([RevenueCellSelection])
    case setTransfers([RevenueCellSelection])
    case setWatchRevenues([RevenueCellSelection])
  }
  
  struct State {
    var revenue: [RevenueCellSelection]
    var transfer: [RevenueCellSelection]
    var watchRevenue: [RevenueCellSelection]
  }
  
  let provider: ServiceProviderType
  let initialState: State
  
  init(provider: ServiceProviderType) {
    self.provider = provider
    self.initialState = State(
      revenue:[RevenueCellSelection(model: .revenue, items: [])],
      transfer: [RevenueCellSelection(model: .transfer, items: [])],
      watchRevenue: [RevenueCellSelection(model: .watch, items: [])]
    )
  }
  
  func mutate(action: WalletViewReactor.Action) -> Observable<WalletViewReactor.Mutation> {
    switch action {
      case .getRevenues:
        return self.provider.walletService.getRevenue()
          .map {
            print($0)
            
  //          var newValue = [Wallet.watchHistory]()
  //          newValue = $0.map {
  //            var watchHistory: Wallet.watchHistory? = nil
  //            watchHistory = Wallet.watchHistory(JSON: $0)
  //            return watchHistory!
  //          }
  //
            //          let sectionItems = newValue.map(VideoCellReactor.init)
            let revenues = RevenueCellSelection(model: .revenue, items: $0)
            return .setRevenues([revenues])
        }
      case .getTransfers:
        return self.provider.walletService.getTranferData()
          .map {
            print($0)
            //          var newValue = [Wallet.watchHistory]()
            //          newValue = $0.map {
            //            var watchHistory: Wallet.watchHistory? = nil
            //            watchHistory = Wallet.watchHistory(JSON: $0)
            //            return watchHistory!
            //          }
            //
            //          let sectionItems = newValue.map(VideoCellReactor.init)
            let revenues = RevenueCellSelection(model: .transfer, items: $0)
            return .setTransfers([revenues])
          }
      case .getWatchRevenues:
        return self.provider.walletService.getWatchRevenue()
          .map {
            let revenues = RevenueCellSelection(model: .watch, items: $0)
            return .setWatchRevenues([revenues])
      }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
      case let .setTransfers(transfer):
        state.transfer = transfer
      
      case let .setRevenues(revenue):
        print(revenue)
        state.revenue = revenue
      
      case let .setWatchRevenues(watchRevenue):
        state.watchRevenue = watchRevenue
      }
    
      return state
    }
}
