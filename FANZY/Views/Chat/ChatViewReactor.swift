//
//  ChatViewReactor.swift
//  FANZY
//
//  Created by 김연준 on 31/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift

typealias MessageCellSelection = SectionModel<Void, Message>

enum ChatMode {
  case normal
  case small
}

final class ChatViewReactor: Reactor {
  enum Action {
    case changeChatMode
  }
  
  enum Mutation {
    case setMessages([MessageCellSelection])
    case changeChatMode(ChatMode)
  }
  
  struct State {
    var roomId: String
    var chatMode: ChatMode
    var messages: [MessageCellSelection]
  }
  
  let provider: ServiceProviderType
  let initialState: State
  
  init(provider: ServiceProviderType, roomId: String, chatMode: ChatMode = .normal) {
    self.provider = provider
    self.initialState = State(
      roomId: roomId, chatMode: chatMode,
      messages: [MessageCellSelection(model: Void(), items: [])]
    )
  }
  
  func mutate(action: ChatViewReactor.Action) -> Observable<ChatViewReactor.Mutation> {
    switch action {
    case .changeChatMode:
      let chatMode:ChatMode = currentState.chatMode == .small ? .normal : .small
      return .just(.changeChatMode(chatMode))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
      case let .setMessages(messages):
        state.messages = messages
    case let .changeChatMode(chatMode):
      state.chatMode = chatMode
    }
    return state
  }
}
