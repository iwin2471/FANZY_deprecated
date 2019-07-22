//
//  WalletService.swift
//  FANZY
//
//  Created by 김연준 on 14/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//


import Foundation

import Alamofire
import RxSwift
import Moya

enum WalletEvent {
  case create(Chat)
  case update(Chat)
  case move(id: Int, to: Int)
  case delete(id: Int)
}

protocol WalletServiceType {
  var event: PublishSubject<WalletEvent> { get }
  
  func getRevenue() -> Observable<[WatchHistory]>
  func getTranferData() -> Observable<[Transfer]>
  func getWatchRevenue() -> Observable<[WatchHistory]>
}

final class WalletService: BaseService, WalletServiceType {
  let event = PublishSubject<WalletEvent>()
  let disposeBag = DisposeBag()
  
  let walletProvider = MoyaProvider<WalletNetworkModel>()
  
  func getRevenue() -> Observable<[WatchHistory]> {

    return walletProvider.rx
      .request(.getRevenue(offset: "1"))
      .mapJSON(failsOnEmptyData: true)
      .asObservable()
      .map {
        $0 as! [[String: Any]]
      }
      .map {
        $0.compactMap { WatchHistory(JSON: $0) }
      }
  }
  
  
  func getTranferData() -> Observable<[Transfer]> {
    return walletProvider.rx
      .request(.getRevenue(offset: "1"))
      .mapJSON(failsOnEmptyData: false)
      .asObservable()
      .map {
        $0 as! [[String: Any]]
      }
      .map {
        $0.compactMap { Transfer(JSON: $0) }
      }
  }
  
  func getWatchRevenue() -> Observable<[WatchHistory]> {
    return walletProvider.rx
      .request(.getWatchingRevenue(offset: "1"))
      .mapJSON(failsOnEmptyData: false)
      .asObservable()
      .map {
        $0 as! [[String: Any]]
      }
      .map {
        $0.compactMap { WatchHistory(JSON: $0) }
    }
  }
}

