//
//  ChatService.swift
//  FANZY
//
//  Created by 김연준 on 01/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Alamofire
import Moya
import RxAlamofire
import RxSwift
import RxCocoa

enum ChatEvent {
  case create(Chat)
  case update(Chat)
  case move(id: Int, to: Int)
  case delete(id: Int)
}

protocol ChatServiceType {
  var event: PublishSubject<ChatEvent> { get }
  func fetchChatRooms() -> Observable<[Chat]>
  func move(roomID: Int, to: Int) -> Observable<Chat>
  
  @discardableResult
  func saveChats(_ chats: [Chat]) -> Observable<Void>
  
  func create(title: String) -> Observable<[String: Any]>
  //  func update(taskID: String, title: String, memo: String?) -> Observable<Video>
  func delete(roomID: Int) -> Observable<Chat>
}

final class ChatService: BaseService, ChatServiceType {
  let event = PublishSubject<ChatEvent>()
  let disposeBag = DisposeBag()
  
  let chatProvider = MoyaProvider<ChatNetworkModel>()
  
  func create(title: String) -> Observable<[String: Any]> {
    return chatProvider.rx.request(.creatRoom(title: title))
      .mapJSON(failsOnEmptyData: true)
      .asObservable()
      .map {
        $0 as! [String: Any]
      }
  }
  
  
  func fetchChatRooms() -> Observable<[Chat]> {
    
    
    //    if let savedTaskDictionaries = self.provider.userDefaultsService.value(forKey: .chats) {
    //      print("saved")
    //      let chats = savedTaskDictionaries.compactMap { Chat(JSON: $0)}
    //      return .just(chats)
    //    }
    
    return chatProvider.rx
      .request(.chatRoomList(id: id))
      .mapJSON(failsOnEmptyData: false)
      .asObservable()
      .map {
        $0 as! [[String: Any]]
      }
      .map {
        $0.compactMap { Chat(JSON: $0) }
    }
    
    //    let defaultChats: [Chat] = [
    //
    //    ]
    //
    //    let defaultTaskDictionaries = defaultChats.map { $0.asDictionary() }
    //    self.provider.userDefaultsService.set(value: defaultTaskDictionaries, forKey: .chats)
    //
    //    return .just(defaultChats)
  }
  
  @discardableResult
  func saveChats(_ chats: [Chat]) -> Observable<Void> {
    let dicts = chats.map { $0.asDictionary() }
    self.provider.userDefaultsService.set(value: dicts, forKey: .chats)
    return .just(Void())
  }
  
  func delete(roomID: Int) -> Observable<Chat> {
    return self.fetchChatRooms()
      .flatMap { [weak self] rooms -> Observable<Chat> in
        guard let `self` = self else { return .empty() }
        guard let index = rooms.index(where: { $0.id == roomID }) else { return .empty() }
        var rooms = rooms
        let deletedTask = rooms.remove(at: index)
        return self.saveChats(rooms).map { deletedTask }
      }
      .do(onNext: { task in
        self.event.onNext(.delete(id: task.id))
      })
  }
  
  func move(roomID: Int, to destinationIndex: Int) -> Observable<Chat> {
    return self.fetchChatRooms()
      .flatMap { [weak self] chats -> Observable<Chat> in
        guard let `self` = self else { return .empty() }
        guard let sourceIndex = chats.firstIndex(where: { $0.id == roomID }) else { return .empty() }
        var chats = chats
        let chat = chats.remove(at: sourceIndex)
        chats.insert(chat, at: destinationIndex)
        return self.saveChats(chats).map { chat }
      }
      .do(onNext: { task in
        self.event.onNext(.move(id: task.id, to: destinationIndex))
      })
  }
}

