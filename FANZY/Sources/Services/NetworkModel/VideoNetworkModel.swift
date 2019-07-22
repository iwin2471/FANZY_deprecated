//
//  VideoNetworkModel.swift
//  FANZY
//
//  Created by 김연준 on 16/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import Moya

enum VideoNetworkModel {
  case randomVideo
  case relate(videoID: String)
  case report(id : Int, wallet_address : String, org_video_id : String, reason : String)
  case search(query: String)
}

extension VideoNetworkModel: TargetType {
  var baseURL: URL { return URL(string: "\(TestFanzyURL)/video")! }
  
  var path: String {
    switch self {
    case let .relate(videoID):
      return "/related/api/\(videoID)"
    case .randomVideo:
      return "/random/api"
    case .report:
      return "/report"
    case .search:
      return "/search/api"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .relate, .randomVideo, .search:
      return .get
    case .report:
      return .post
    }
  }
  
  var task: Task {
    switch self {
    case .search(let query):
      return .requestParameters(parameters: ["search_query": query, "page": "index", "lang": "kr"], encoding: URLEncoding(destination: .queryString))
    case .relate, .randomVideo: // Send no parameters
      return .requestParameters(parameters: ["lang" : "kr"], encoding: URLEncoding.default)
    case let .report(id, wallet_address, org_video_id, reason):
      return .requestParameters(parameters: [
        "id": id,
        "wallet_address": wallet_address,
        "org_video_id": org_video_id,
        "reason": reason
        ], encoding: URLEncoding.default)
    }
  }
  
  var sampleData: Data {
    switch self {
    case .relate, .randomVideo, .report, .search:
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

