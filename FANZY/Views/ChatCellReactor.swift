//
//  ChatCellReactor.swift
//  FANZY
//
//  Created by 김연준 on 01/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class ChatCellReactor: Reactor {
  typealias Action = NoAction
  
  let initialState: Chat
  
  init(chat: Chat) {
    self.initialState = chat
  }
}
