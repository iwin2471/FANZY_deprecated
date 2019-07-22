//
//  HomeVCReactor.swift
//  FANZY
//
//  Created by 김연준 on 14/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//


import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift

final class ViewControllerReactor: Reactor {
  enum Action {
    case minimized
    case fullScreen
    case hidden
  }
  
  enum Mutation {
    case setMinimize
    case setFullScreen
    case setHidden
  }
  
  struct State {
    var isMinimized: Bool
    var isHidden: Bool
  }
  
  let provider: ServiceProviderType
  let initialState: State
  
  init(provider: ServiceProviderType) {
    self.provider = provider
    self.initialState = State(isMinimized: false, isHidden: true)
  }
  
  
//  func mutate(action: ViewControllerReactor.Action) -> Observable<ViewControllerReactor.Mutation> {
//    switch action {
//    case .minimized:
//      return self.provider.taskService
//        .create(title: self.currentState.taskTitle, memo: nil)
//        .map { _ in .dismiss }
//      break
//      
//    case .fullScreen:
//      break
//      
//    case .hidden:
//      break
//    default:
//      break
//    }
//  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .setMinimize:
      state.isMinimized = true
      return state
      break
    case .setFullScreen:
      state.isMinimized = false
      state.isHidden = false
      return state
      break
    case .setHidden:
      state.isHidden = true
      return state
      break
    }
  }
  
}

