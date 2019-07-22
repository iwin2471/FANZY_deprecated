//
//  ChatViewReactor.swift
//  FANZY
//
//  Created by 김연준 on 01/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//


import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift

typealias ChatListSection = SectionModel<Void, ChatCellReactor>

final class ChatListViewReactor: Reactor {
  
  enum Action {
    case refresh
    case deleteChat(IndexPath)
    case moveChat(IndexPath, IndexPath)
    case creatChat(String)
  }
  
  enum Mutation {
    case setSections([ChatListSection])
    case create([ChatListSection])
    case insertSectionItem(IndexPath, ChatListSection.Item)
    case updateSectionItem(IndexPath, ChatListSection.Item)
    case deleteSectionItem(IndexPath)
    case moveSectionItem(IndexPath, IndexPath)
  }
  
  struct State {
    var sections: [ChatListSection]
  }
  
  let provider: ServiceProviderType
  let initialState: State
  
  init(provider: ServiceProviderType) {
    self.provider = provider
    self.initialState = State(
      sections: [ChatListSection(model: Void(), items: [])]
    )
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      return self.provider.chatService.fetchChatRooms()
        .map { chats in
          let sectionItems = chats.map(ChatCellReactor.init)
          let section = ChatListSection(model: Void(), items: sectionItems)
          return .setSections([section])
      }
      
    case let .deleteChat(indexPath):
      let chat = self.currentState.sections[indexPath.item].items[0].currentState
      return self.provider.chatService.delete(roomID: chat.id).flatMap { _ in Observable.empty() }
      
    case let .moveChat(sourceIndexPath, destinationIndexPath):
      let chat = self.currentState.sections[sourceIndexPath.item].items[0].currentState
      return self.provider.chatService.move(roomID: chat.id, to: destinationIndexPath.item)
        .flatMap { _ in Observable.empty() }
    case let .creatChat(title):
      return self.provider.chatService.create(title: title).asObservable().map {
        var chat: Chat? = nil
        
        do {
          if let playing = $0["playing"] {
            chat = try Chat(JSON: $0)
          } else {
            var nilToValue = $0
            nilToValue["playing"] = 0
            nilToValue["opened"] = 0
            nilToValue["deleted"] = 0
            nilToValue["bgUsers"] = [["avatar":avator]]
            nilToValue["participantCount"] = 0
            nilToValue["unReadMessages"] = 0
            nilToValue["latestMessage"] = ""
            nilToValue["latestMessageDate"] = ""
            chat = try Chat(JSON: nilToValue)
          }
          
        } catch {
          
        }
        
        let reactor = ChatCellReactor.init(chat: chat!)
        let section = ChatListSection(model: Void(), items: [reactor])
        return .create([section])
      }
    }
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let taskEventMutation = self.provider.chatService.event
      .flatMap { [weak self] chatEvent -> Observable<Mutation> in
        self?.mutate(chatEvent: chatEvent) ?? .empty()
    }
    return Observable.of(mutation, taskEventMutation).merge()
  }
  
  private func mutate(chatEvent: ChatEvent) -> Observable<Mutation> {
    let state = self.currentState
    switch chatEvent {
      case let .create(chat):
        let indexPath = IndexPath(item: 0, section: 0)
        let reactor = ChatCellReactor(chat: chat)
        return .just(.insertSectionItem(indexPath, reactor))
      
      case let .update(chat):
        guard let indexPath = self.indexPath(forTaskID: chat.id, from: state) else { return .empty() }
        let reactor = ChatCellReactor(chat: chat)
        return .just(.updateSectionItem(indexPath, reactor))
      
      case let .delete(id):
        guard let indexPath = self.indexPath(forTaskID: id, from: state) else { return .empty() }
        return .just(.deleteSectionItem(indexPath))
      
      case let .move(id, index):
        guard let sourceIndexPath = self.indexPath(forTaskID: id, from: state) else { return .empty() }
        let destinationIndexPath = IndexPath(item: index, section: 0)
        return .just(.moveSectionItem(sourceIndexPath, destinationIndexPath))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setSections(sections):
      state.sections = sections
      
    case let .insertSectionItem(indexPath, sectionItem):
      state.sections.insert(ChatListSection(model: Void(), items: [sectionItem]), at: indexPath.item)
      
    case let .updateSectionItem(indexPath, sectionItem):
      state.sections[indexPath.item] = ChatListSection(model: Void(), items: [sectionItem])
      
    case let .deleteSectionItem(indexPath):
      state.sections.remove(at: indexPath.item)
      
      
    case let .moveSectionItem(sourceIndexPath, destinationIndexPath):
      let sectionItem = state.sections.remove(at: sourceIndexPath.item)
      state.sections.insert(sectionItem, at: destinationIndexPath.item)
    case let .create(sections):
      state.sections.append(contentsOf: sections)
    }
    return state
  }
  
  private func indexPath(forTaskID roomID: Int, from state: State) -> IndexPath? {
    let section = 0
    let item = state.sections[section].items.firstIndex { reactor in reactor.currentState.id == roomID }
    if let item = item {
      return IndexPath(item: item, section: section)
    } else {
      return nil
    }
  }
}
