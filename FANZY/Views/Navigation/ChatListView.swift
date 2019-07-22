//
//  chatView.swift
//  FANZY
//
//  Created by 김연준 on 01/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import UIKit
import ReactorKit
import ReusableKit
import RxSwift
import RxDataSources
import RxCocoa
import ManualLayout

final class ChatListView: BaseCell, View {
  
  struct Reusable {
    static let chatCell = ReusableCell<ChatCell>()
  }
  
  let dataSource = RxTableViewSectionedReloadDataSource<ChatListSection>(
    configureCell: { _, tableView, indexPath, reactor in
      let cell = tableView.dequeue(Reusable.chatCell, for: indexPath)
      cell.reactor = reactor
      
      return cell
  })
  
  let player = UIView()
  
  let chatList = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-140)).then {
    $0.backgroundColor = .init(rgb: 0x212121)
    $0.register(Reusable.chatCell)
  }
  
  
  override func initialize() {
    super.initialize()
    addSubview(chatList)
    chatList.isHidden = true
    test()
  }
  
  func test() {
    self.chatList.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalToSuperview()
    }
    
    self.chatList.snp.makeConstraints { make in
      make.edges.equalTo(0)
    }
  }
  
  override func customise() {
    self.chatList.separatorStyle = .none
  }
  
  override func setupConstraints() {
    
  }
  
  func bind(reactor: ChatListViewReactor) {
    self.chatList.rx.setDelegate(self).disposed(by: self.disposeBag)
    
    
    Observable.just(Reactor.Action.refresh)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    
    reactor.state
      .asObservable()
      .map { $0.sections }
      .bind(to: chatList.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }
}

extension ChatListView: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let reactor = self.dataSource[indexPath]
    
    return ChatCell.height(fits: tableView.width, reactor: reactor)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

extension ChatListView {
  func dequeue(indexPath: IndexPath) -> ChatCell{
    return self.chatList.dequeue(Reusable.chatCell, for: indexPath)
  }
}


extension ChatListView {
  func createRoom(title: String) {
    Observable.just(Reactor.Action.creatChat(title)).bind(to: self.reactor!.action).disposed(by: disposeBag)
  }
}
