//
//  ChatView.swift
//  FANZY
//
//  Created by 김연준 on 28/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import UIKit
import Then
import MaterialComponents
import ReusableKit
import ReactorKit
import RxKeyboard

class ChatView: BaseView, ReactorKit.View {
  
  let videoInfo = MDCButton()
  let addToChatButton = MDCButton()
  let videoInfoBtnImg = UIImageView(image: UIImage(named: "playlist")?.resized(newSize: CGSize(width: 25, height: 25)))
  let videoInfoLabel = UILabel()
  var addToChatBtnImg = UIImageView(image: UIImage(named: "add_to_chat")?.resized(newSize: CGSize(width: 25, height: 25)))
  var addToChatBtnLabel = UILabel()
  let messageInputBar = MessageInputBar()
  
  
  var messages: [Message] = []
  
  
  struct Reusable {
    static let messageCell = ReusableCell<MessageCell>()
  }
  
  
  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    $0.alwaysBounceVertical = true
    $0.keyboardDismissMode = .interactive
    $0.backgroundColor = .clear
    $0.register(Reusable.messageCell)
    ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
      $0.minimumLineSpacing = 6
      $0.sectionInset.top = 10
      $0.sectionInset.bottom = 10
    }
  }
  
  override func initialize() {
    super.initialize()
    addSubview(videoInfo)
    addSubview(addToChatButton)
    addSubview(collectionView)
    addSubview(messageInputBar)
    videoInfo.addSubview(videoInfoBtnImg)
    videoInfo.addSubview(videoInfoLabel)
    addToChatButton.addSubview(addToChatBtnImg)
    addToChatButton.addSubview(addToChatBtnLabel)
  }
  
  override func customise() {
    backgroundColor = UIColor(named: "mainColor")
    
    self.isUserInteractionEnabled = true
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    
    DispatchQueue.main.async {
      let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
      self.collectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    self.videoInfo.backgroundColor = .init(rgb: 0x212121)
    self.videoInfoBtnImg.alpha = 0.7
    self.videoInfoLabel.text = "동영상정보"
    self.videoInfoLabel.font = UIFont.systemFont(ofSize: 14)
    self.videoInfoLabel.textColor = .white
    self.videoInfoLabel.alpha = 0.7
    
    self.addToChatButton.frame = self.videoInfo.frame
    self.addToChatButton.backgroundColor = .init(rgb: 0x212121)
    self.addToChatBtnImg.alpha = 0.7
    self.addToChatBtnLabel.text = "채팅방에 추가"
    self.addToChatBtnLabel.font = UIFont.systemFont(ofSize: 14)
    self.addToChatBtnLabel.textColor = .white
    self.addToChatBtnLabel.alpha = 0.7
    
    self.messageInputBar.then {
      $0.backgroundColor = UIColor(named: "modalColor")
      //      $0.keyboardType = .alphabet
      $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 50)
      //      $0.attributedPlaceholder = NSAttributedString(string: "텍스트를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
  }
  
  //   MARK: Constants
  override func setupConstraints() {
    super.setupConstraints()
    let videoInfoExist = videoInfo.isDescendant(of: self)
    
    if let superview = self.superview as? PlayerView {
      print(superview)
      self.frame = CGRect(
        x: 0,
        y: superview.player.frame.height + 30,
        width: UIScreen.main.bounds.width,
        height: UIScreen.main.bounds.height - superview.player.frame.height - 30
      )
    } else {
      self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 40)
    }
    
    
    if videoInfoExist {
      self.videoInfo.snp.makeConstraints { (make) in
        //      make.top.equalTo(viewCount.snp.bottom).offset(15)
        make.top.equalTo(self.snp.top).offset(15)
        make.leading.equalToSuperview()
        make.size.equalTo(CGSize(width:UIScreen.main.bounds.width/4, height: 60))
      }
      
      videoInfoBtnImg.snp.makeConstraints { (make) in
        make.top.equalTo(videoInfo.snp.top)
        make.centerX.equalToSuperview()
      }
      
      videoInfoLabel.snp.makeConstraints { (make) in
        make.top.equalTo(videoInfoBtnImg.snp.bottom).offset(5)
        make.centerX.equalToSuperview()
      }
      
      addToChatButton.snp.makeConstraints { (make) in
        make.top.equalTo(videoInfo.snp.top)
        make.leading.equalTo(videoInfo.snp.trailing)
        make.size.equalTo(videoInfo)
      }
      
      addToChatBtnImg.snp.makeConstraints { (make) in
        make.top.equalTo(videoInfo.snp.top)
        make.centerX.equalToSuperview()
      }
      
      addToChatBtnLabel.snp.makeConstraints { (make) in
        make.top.equalTo(addToChatBtnImg.snp.bottom).offset(5)
        make.centerX.equalToSuperview()
      }
    }
    
    
    setupMessageInputBar()
    collectionViewMakeSnp()
  }
  
  func bind(reactor: ChatViewReactor) {
    videoInfo.rx.tap.subscribe(onNext: {
      self.animateOut()
    }).disposed(by: disposeBag)
    
    self.rx.tapGesture()
      .asObservable().subscribe({_ in
        self.messageInputBar.textView.endEditing(true)
      }).disposed(by: disposeBag)
    
    socketBind()
    keyboardBind()
    
    
  }
}

extension ChatView {
  func animateIn() {
    self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
    self.alpha = 1
    self.isUserInteractionEnabled = false
    
    UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear , animations: {
      self.transform = .identity
      self.alpha = 1
    }) { (complate) in
      if complate {
        self.isUserInteractionEnabled = true
      }
    }
  }
  
  @objc fileprivate func animateOut() {
    UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
      self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
      self.alpha = 0
    }) { (complete) in
      if complete {
        self.removeFromSuperview()
      }
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChatView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
    let message = self.messages[indexPath.item]
    return MessageCell.size(thatFitsWidth: collectionView.width, forMessage: message)
  }
  
}

extension ChatView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(Reusable.messageCell, for: indexPath)
    cell.configure(message: self.messages[indexPath.item])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.messages.count
  }
}

extension ChatView {
  func socketBind(){
    socket.emit("join:room", name, avator, id, self.reactor!.currentState.roomId, "false", "false")
    
    socket.rx.on("chat message")
      .map { $0 as! Array }
      .map { $0[0] as Array }
      .map { Message(map: $0) }
      .subscribe(onNext: {
        let message = $0
        if $0.user == .other {
          self.messages.append(message)
          
          let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
          
          self.collectionView.insertItems(at: [indexPath])
          self.collectionView.scrollToItem(at: indexPath, at: [], animated: true)
        }
      }).disposed(by: disposeBag)
  }
}

extension ChatView {
  func keyboardBind(){
    let room = "video_"+self.reactor!.currentState.roomId
    
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] keyboardVisibleHeight in
        guard let `self` = self, self.didSetupConstraints else { return }
        
        self.messageInputBar.snp.remakeConstraints { make in
          make.height.equalTo(50)
          make.width.equalTo(self.frame.width)
          make.leading.equalToSuperview()
          make.trailing.equalToSuperview()
          make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-keyboardVisibleHeight)
        }
        
        self.setNeedsLayout()
        
        if(self.reactor!.currentState.chatMode == .normal) {
          UIView.animate(withDuration: 0) {
            self.collectionView.contentInset.bottom = keyboardVisibleHeight + self.messageInputBar.height
            self.collectionView.scrollIndicatorInsets.bottom = self.collectionView.contentInset.bottom
            self.layoutIfNeeded()
          }
        }
      })
      .disposed(by: self.disposeBag)
    
    RxKeyboard.instance.willShowVisibleHeight
      .drive(onNext: { keyboardVisibleHeight in
        self.collectionView.contentOffset.y += keyboardVisibleHeight
      })
      .disposed(by: self.disposeBag)
    
    self.messageInputBar.rx.sendButtonTap
      .subscribe(onNext: { text in
        let message = text
        let messageModel = [message, "", name,  avator]
        
        socket.emit("chat message", message, name, avator, id, room);
        
        self.messages.append(Message(map: messageModel))
        
        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
        
        self.collectionView.insertItems(at: [indexPath])
        self.collectionView.scrollToItem(at: indexPath, at: [], animated: true)
      }).disposed(by: disposeBag)
  }
}

extension ChatView {
  public func collectionViewMakeSnp(){
    let videoInfoExist = videoInfo.isDescendant(of: self)
    
    self.collectionView.snp.makeConstraints { (make) in
      if videoInfoExist {
        make.top.equalTo(videoInfo.snp.bottom)
      } else {
        make.top.equalToSuperview()
      }
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(messageInputBar.snp.top)
    }
  }
  
  public func setupMessageInputBar() {
    self.messageInputBar.snp.makeConstraints { (make) in
      make.height.equalTo(50)
      make.width.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  func removeAllCell() {
    messages.removeAll()
    collectionView.reloadData()
  }
}
