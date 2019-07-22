//
//  ServiceProvider.swift
//  FANZY
//
//  Created by 김연준 on 14/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation

protocol ServiceProviderType: class {
  var userDefaultsService: UserDefaultsServiceType { get }
  var fanzyCoinServcie: FanzyCoinServiceType { get }
  var videoService: VideoServiceType { get }
  var chatService: ChatServiceType { get }
  var walletService: WalletServiceType { get }
  var storeService: StoreServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
  lazy var userDefaultsService: UserDefaultsServiceType = UserDefaultsService(provider: self)
  lazy var fanzyCoinServcie: FanzyCoinServiceType = FanzyCoinService(provider: self)
  lazy var videoService: VideoServiceType = VideoService(provider: self)
  lazy var chatService: ChatServiceType = ChatService(provider: self)
  lazy var walletService: WalletServiceType = WalletService(provider: self)
  lazy var storeService: StoreServiceType = StoreService(provider: self)
}
