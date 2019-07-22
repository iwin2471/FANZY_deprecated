//
//  WalletNetworkModel.swift
//  FANZY
//
//  Created by 김연준 on 12/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import Moya

enum WalletNetworkModel{
  case getTransfer
  case getRevenue(offset: String)
  case getWatchingRevenue(offset: String)
}

extension WalletNetworkModel: TargetType {
  var baseURL: URL { return URL(string: "\(TestFanzyURL)/user")! }
  
  var path: String {
    switch self {
      case .getTransfer:
        return "/\(email)/reward/transferhistory"
      
      case let .getRevenue(offset):
        return "/\(id)/reward/content/\(offset)"
      
      case let .getWatchingRevenue(offset):
        return "/\(id)/reward/history/\(offset)"
    }
  }
  
  var method: Moya.Method {
    switch self {
      case .getRevenue, .getTransfer, .getWatchingRevenue:
        return .get
    }
  }
  
  var task: Task {
    switch self {
    case .getRevenue, .getTransfer, .getWatchingRevenue: // Send no parameters
      return .requestPlain
    }
  }
  
  var sampleData: Data {
    switch self {
    case .getRevenue, .getTransfer, .getWatchingRevenue:
      return "[{\"id\": 222,\"title\": \"개발자죽는다\", \"invitor_id\": 11634, \"play_list\": \"\", \"playing\": 0,\"opened\": 0,\"delete\": 0,\"created_at\": \"2019-02-24T00:16:21.000Z\",\"updated_at\": \"2019-02-24T11:01:04.000Z\",\"room_id\": \"38d80a241cbd9bcf\",\"bg_color\": \"#0dd77c\",\"current\": \"\",\"participants\": [{ \"count(*)\": 5}],\"unReadMessages\": 3,\"latestMessage\": \"asdf\",\"latestMessageDate\": \"2019-04-30T13:27:19.000Z\"}]".utf8Encoded
    }
  }
  
  var headers: [String: String]? {
    return ["Content-type": "application/json"]
  }
}

private extension String {
  var urlEscaped: String {
    return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
  
  var utf8Encoded: Data {
    return data(using: .utf8)!
  }
}


