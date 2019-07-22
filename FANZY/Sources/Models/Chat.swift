//
//  Chat.swift
//  FANZY
//
//  Created by 김연준 on 01/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import ObjectMapper

struct Chat: ImmutableMappable {
  let id: Int
  let title: String
  let playList: String
  let roomId: String
  let bgColor: String
  let bgUsers: Array<AnyObject>
  let participantCount: Int
  let unReadMessages: Int
  let latestMessage: String
  let latestMessageDate: String
  
  
  init(map: Map) throws {
    id = try map.value("id")
    title = try map.value("title")
    playList = try map.value("play_list")
    roomId = try map.value("room_id")
    bgColor = try map.value("bg_color")
    bgUsers = try map.value("bgUsers")
    participantCount = try map.value("participantCount")
    unReadMessages = try map.value("unReadMessages")
    latestMessage = try map.value("latestMessage")
    latestMessageDate = try map.value("latestMessageDate")
  }
  
  
  func mapping(map: Map) {
    id                  >>> map["id"]
    title               >>> map["title"]
    playList            >>> map["play_list"]
    roomId              >>> map["room_id"]
    bgColor             >>> map["bg_color"]
    bgUsers             >>> map["bgUsers"]
    participantCount    >>> map["participantCount"]
    unReadMessages      >>> map["unReadMessages"]
    latestMessage       >>> map["latestMessage"]
    latestMessageDate       >>> map["latestMessageDate"]
    
  }
  
  func asDictionary() -> [String: Any] {
    return [
      "id": self.id,
      "title": self.title,
      "playList": self.playList,
      "roomId": self.roomId,
      "bgColor": self.bgColor,
      "bgUsers": self.bgUsers,
      "participantCount": self.participantCount,
      "unReadMessages": self.unReadMessages,
      "latestMessage": self.latestMessage,
      "latestMessageDate": self.latestMessageDate
    ]
  }
}
