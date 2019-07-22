//
//  ChatServiceNetwork.swift
//  FANZY
//
//  Created by 김연준 on 02/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import Moya

enum ChatNetworkModel {
  case chatRoomList(id: Int)
  case chatRoomJoin(chatId: String)
  case creatRoom(title: String)
}

extension ChatNetworkModel: TargetType {
  var baseURL: URL { return URL(string: TestFanzyURL)! }
  
  var path: String {
    switch self {
    case .chatRoomList(let id):
      return "/user/\(id)/chat/api"
    case .chatRoomJoin(_):
      return "/chatroom/join"
    case .creatRoom(let title):
      return "/chatroom/make"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .chatRoomList:
      return .get
    case .chatRoomJoin, .creatRoom:
      return .post
    }
  }
  
  var task: Task {
    switch self {
    case .chatRoomList: // Send no parameters
      var params: [String: Any] = [:]
      params["lang"] = "kr"
      return .requestParameters(parameters: params, encoding: URLEncoding.default)
    case .chatRoomJoin(let chatId):
      var params: [String: Any] = [:]
      params["user_id"] = id
      params["wallet_address"] = UserDefaults.standard.string(forKey: "hash")!
      params["room_id"] = chatId
      return .requestParameters(parameters: params, encoding: URLEncoding.default)
    case .creatRoom(let title):
      let address = UserDefaults.standard.string(forKey: "hash")!
      let params: [String: Any] = ["title": title, "wallet_address": address, "user_id": id ]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
  }
  
  var sampleData: Data {
    switch self {
    case .chatRoomList, .chatRoomJoin, .creatRoom:
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
