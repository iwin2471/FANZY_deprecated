//
//  Wallet.swift
//  FANZY
//
//  Created by 김연준 on 14/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import ObjectMapper

protocol Wallet: ImmutableMappable {
  
}

struct Transfer: Wallet {
  let from: String
  let to: String
  let amount: String
  
  init(map: Map) throws {
    from   = try map.value("title")
    to = try map.value("thumbnail")
    amount = try map.value("url")
  }
  
  
  func mapping(map: Map) {
    from               >>> map["title"]
    to                 >>> map["thumbnail"]
    amount             >>> map["url"]
  }
}

struct WatchHistory: Wallet {
  let videoId: Int
  let amount: Double
  
  init(map: Map) throws {
    videoId   = try map.value("video_id")
    amount    = try map.value("amount")
  }
  
  func mapping(map: Map) {
    videoId               >>> map["video_id"]
    amount                >>> map["amount"]
  }
}

