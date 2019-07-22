//
//  Message.swift
//  FANZY
//
//  Created by 김연준 on 30/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation

enum User {
  case other
  case me
}

struct Message {
  var user: User = .me
  var text: String
  var userProfile: String
  
  init(map: Array<Any>) {
    let message = map[0] as! String
    let userName = map[2] as! String
    let userAvatar = map[3] as! String
    
    self.text = message
    if userAvatar != avator {
      self.user = .other
    }
    self.userProfile = userAvatar
  }
}
