//
//  User.swift
//  FANZY
//
//  Created by 김연준 on 27/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//
import Foundation
import ObjectMapper

struct Video: ImmutableMappable, Equatable {
  
  static func == (lhs: Video, rhs: Video) -> Bool {
    return lhs.title == rhs.title && lhs.url == rhs.url
  }
  
  let title: String
  let thumbnail: String
  let url: String
  let org_video_id: String
  let creator: Dictionary<String, Any>
  let duration: Any
  
  
  init(map: Map) throws {
    title   = try map.value("title")
    thumbnail = try map.value("thumbnail")
    url = try map.value("url")
    org_video_id = try map.value("org_video_id")
    creator = try map.value("creator")
    duration = try map.value("duration")
  }
  
  
  func mapping(map: Map) {
    title               >>> map["title"]
    thumbnail           >>> map["thumbnail"]
    url                 >>> map["url"]
    org_video_id        >>> map["org_video_id"]
    creator             >>> map["creator"]
    duration            >>> map["duration"]
  }
}
