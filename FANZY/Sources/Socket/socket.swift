//
//  socket.swift
//  FANZY
//
//  Created by 김연준 on 14/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//
import Foundation
import SocketIO
import RxSwift

let socketURL = ""
let socketTestURL = ""
let FanzyURL = ""
let ApiFanzyURL = ""
let TestFanzyURL = ""

let manager = SocketManager(socketURL: URL(string: socketTestURL)!, config: [.log(false), .compress])
let socket = manager.defaultSocket

extension Reactive where Base: SocketIOClient {
  public func on(_ event: String) -> Observable<[Any]> {
    return Observable.create { observer in
      let id = self.base.on(event) { items, _ in
        observer.onNext(items)
      }
      
      return Disposables.create {
        self.base.off(id: id)
      }
    }
  }
}
