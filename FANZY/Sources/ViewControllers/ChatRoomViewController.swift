//
//  ChatViewController.swift
//  FANZY
//
//  Created by 김연준 on 07/06/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import UIKit
import ManualLayout
import RxCocoa
import RxSwift
import MaterialComponents
import YoutubeKit
import RxKeyboard

class ChatRoomViewController: BaseViewController {
  let chatView = ChatView()
  let backButton = UIButton(type: .custom)
  let playerView = PlayerView()
  var recommandButton = MDCButton()
  var playlistButton = MDCButton()
  var historyButton = MDCButton()
  var inviteButton = MDCButton()
  
  let intToVideoStatus: [YTSwiftyPlayerState] = [.ended, .playing, .paused, .buffering, .cued]
  let videoStateObserve = PublishSubject<YTSwiftyPlayerState>()
  
  init(reactor: ChatViewReactor) {
    super.init()
    socket.connect()

    chatView.reactor = reactor
    backButton.setImage(UIImage(named: "back")?.resized(newSize: CGSize(width: 28, height: 28)), for: .normal)
    
    let backButtonItem  = UIBarButtonItem(customView: backButton)
    
    self.navigationItem.leftBarButtonItem = backButtonItem
    
    playerView.reactor = PlayerReactor(video: Video(JSON:
      [
        "title"   : "개발자일한다",
        "thumbnail" : "none",
        "url" : "nil",
        "org_video_id" : "mvSItvjFE1c",
        "creator" : ["id" : 1, "name": "김연준"],
        "duration" : "30",
        "playtime" : "3:30",
        "view_count" : 0,
        "published_at" : "",
      ]
    ), playerState: .chatRoom)
    
    chatRoomSocket()
    setEvent()
    setPlayerDelegate()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()    
//
//    playerView.player.rx.panGesture() { [unowned self] gestureRecognizer, delegate in
//      gestureRecognizer.delegate = nil
//    }
    
    playerView.YTPlayer.removeFromSuperview()
    view.addSubview(playerView.player)
    view.addSubview(playerView.summary)
    view.addSubview(playerView.relateVideoList)
    view.addSubview(playerView.channelWrapper)
    view.addSubview(chatView.messageInputBar)
    view.addSubview(chatView.collectionView)
    
    
    playerView.player.subviews.map { $0.removeFromSuperview() }
    playerView.player.addSubview(playerView.YTPlayer)
    checkVideo()
  }
  
  override func customise() {
    view.backgroundColor = UIColor(named: "modalColor")
    chatView.videoInfo.removeFromSuperview()
    chatView.frame = view.frame
    chatView.collectionView.frame = playerView.player.frame
    print("player: \(playerView.player.frame)")
    playerView.setupPv()
    
    playerView.videoTitle.alpha = 0
    playerView.viewCount.alpha = 0
    playerView.YTPlayer.alpha = 0
    keyboardBind()
  }
  
  override func setupConstraints() {
    chatView.setupMessageInputBar()
    playerView.setupSummary()
    playerView.clearCoinLabel()
    playerView.setupRelateList()
    playerView.setupChannelWrapper()
    summaryRemake()
    setupCollectionView()
  }
}

extension ChatRoomViewController {
  
  func buttonCustomize() {
    playlistButton = CustomButton(ImageName: "playlist", title: "재생목록")
    
    historyButton = CustomButton(ImageName: "history", title: "히스토리")
    
    inviteButton = CustomButton(ImageName: "addfriend", title: "친구초대")
    
  }
  
  func summaryRemake() {
    playerView.summary.height = playerView.chatButton.height + 50
    
    playerView.reportButton.removeFromSuperview()
    playerView.addToChatButton.removeFromSuperview()
    
    recommandButton = CustomButton(ImageName: "recomended", title: "추천")
    playerView.chatBtnLabel.text = "채팅"
    playerView.summary.addSubview(recommandButton)
    playerView.chatButton.backgroundColor = .clear
    
    buttonCustomize()
    
    playerView.summary.addSubview(playlistButton)
    playerView.summary.addSubview(historyButton)
    playerView.summary.addSubview(inviteButton)
    playerView.summary.addSubview(playlistButton)
    
    
    playerView.chatButton.snp.remakeConstraints { (make) in
      make.top.equalTo(playerView.coinLabel.snp.bottom).offset(8)
      make.trailing.equalTo(playerView.coinLabel.snp.trailing).offset(-5)
      make.size.equalTo(CGSize(width:UIScreen.main.bounds.width/6, height: 60))
    }
    
    recommandButton.snp.remakeConstraints { (make) in
      make.top.equalTo(playerView.chatButton)
      make.leading.equalTo(10)
      make.size.equalTo(playerView.chatButton.snp.size)
    }
    
    playlistButton.snp.makeConstraints { (make) in
      make.top.equalTo(recommandButton)
      make.leading.equalTo(recommandButton.snp.trailing)
      make.size.equalTo(playerView.chatButton.snp.size)
    }
    
    inviteButton.snp.makeConstraints { (make) in
      make.top.equalTo(recommandButton.snp.top)
      make.leading.equalTo(playlistButton.snp.trailing)
      make.size.equalTo(playerView.chatButton.snp.size)
    }
    
    historyButton.snp.makeConstraints { (make) in
      make.top.equalTo(recommandButton)
      make.leading.equalTo(inviteButton.snp.trailing)
      make.size.equalTo(playerView.chatButton.snp.size)
    }
    
  }
  
  func setupCollectionView(){
    chatView.collectionView.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(playerView.player.snp.bottom)
    }
  }
}

extension ChatRoomViewController {
  func setEvent(){
    
    backButton.rx.tap.subscribe(onNext: {
      self.navigationController?.popViewController(animated: true)
      self.playerView.YTPlayer.clearVideo()
      self.playerView.YTPlayer.pauseVideo()
      self.playerView.player.removeFromSuperview()
      self.playerView.YTPlayer.removeFromSuperview()
      socket.disconnect()
      self.view.subviews.map({ $0.removeFromSuperview() })
      
    }).disposed(by: disposeBag)
    
    playerView.chatButton.rx.tap.subscribe(onNext: {
      self.chatView.collectionView.backgroundColor = UIColor(named: "modalColor")
      self.view.addSubview(self.chatView.collectionView)
      
      self.chatView.collectionView.snp.remakeConstraints({ (make) in
        make.top.equalTo(self.playerView.pv.snp.bottom).offset(6)
        make.bottom.equalTo(self.chatView.messageInputBar.snp.top)
        make.leading.trailing.equalToSuperview()
      })
      
      self.playerView.player.bringSubviewToFront(self.chatView.collectionView)
      
    }).disposed(by: disposeBag)
    
    
    playerView.relateVideoList.rx.itemSelected
      .map { indexPath in
        self.playerView.dataSource[indexPath]
      }
      .subscribe(onNext: {
        socket.emit("video_load_in_chat", $0.currentState.toJSON(), self.chatView.reactor!.currentState.roomId, "0", "0")
        
//        self.reactor = PlayerReactor(video:  $0.currentState, playerState: .fullScreen)
      })
      .disposed(by: disposeBag)
  }
}

extension ChatRoomViewController {
  func checkVideo() {
    socket.emit("player status check", chatView.reactor!.currentState.roomId)
  }
  
  func chatRoomSocket(){
    let player = self.playerView.YTPlayer
    player.isUserInteractionEnabled = true
    playerView.player.isUserInteractionEnabled = true
    
    socket.on("player status check") { data, ack in
      if  player.playerState != .unstarted {
        socket.emit("response:player status check",
                    player.currentTime * 100,
                    player.playerState.rawValue,
                    player.currentVideoURL!,
                    data[0] as! String,
                    "relate",
                    1)
      }
    }

    socket.rx.on("seek")
      .asObservable()
      .map { $0[0] as! NSNumber }
      .subscribe(onNext: {
        let time = $0
        player.seek(to: time.intValue, allowSeekAhead: true)
    }).disposed(by: disposeBag)

    
    socket.rx.on("video_load_in_chat")
      .asObservable()
      .map { $0 as Array }
      .subscribe(onNext: {
        let video = $0[0] as! [String: Any]
        let whichVideo = $0[1] as! String
        let playlistIndex = $0[2] as! String
        let videoID = video["org_video_id"] as! String
        
        Observable.just(videoID).bind(to: self.playerView.YTPlayer.rx.origin).dispose()
        
      }).disposed(by: self.disposeBag)
    
    
    
    socket.on("play") { _,_ in
      player.playVideo()
    }
    
    socket.on("pause") { _,_ in
      player.pauseVideo();
    }
    
    //    socket.on('seek', function(time){
    //      player.playVideo();
    //
    //      if (parseInt(time) > 0 && Math.abs(parseInt(time) - parseInt(player.getCurrentTime())) > 4) {
    //        try {
    //        player.seekTo(time);
    //        } catch (e) {
    //        setTimeout(function(){
    //        player.seekTo(time);
    //        },300);
    //        }
    //
    //        is_request = true;
    //        setTimeout(function(){
    //          is_request = false;
    //        }, 500);
    //      }
    //    });
    //
    // Sync Chat room play list
    //    socket.on('playlist:sync', function(html){
    //      if (html != '') {
    //        $('.ul-play-list').html('').append(html);
    //      } else {
    //        $('.ul-play-list').html('');
    //      }
    //    });
    
    
    //    socket.on('change:room_title', function(title, room){
    //      $('h1 span').text(title);
    //      $('#chat_room_'+room.replace('chat_', '')).find('.box-thumb span').text(title.substring(0,1));
    //      $('#chat_room_'+room.replace('chat_', '')).find('.ex span').text(title);
    //      $('.box-chat-menu h1').text(title);
    //    });
    
    //    socket.on("leave_room") { data, ack  in
    //
    //    }
    //
    //    // room deleted
    //    socket.on("delete_room") { data, ack in
    //
    //    };
    
  }
}


extension ChatRoomViewController {
  func setPlayerDelegate() {
    self.playerView.YTPlayer.delegate = self
  }
}


extension ChatRoomViewController {
  func keyboardBind(){
    let room = chatView.reactor!.currentState.roomId
    
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] keyboardVisibleHeight in
        guard let `self` = self, self.didSetupConstraints else { return }
        
        self.chatView.messageInputBar.snp.remakeConstraints { make in
          make.height.equalTo(50)
          make.width.equalToSuperview()
          make.leading.equalToSuperview()
          make.trailing.equalToSuperview()
          make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardVisibleHeight)
        }
        
        
        if(self.chatView.reactor!.currentState.chatMode == .normal) {
          UIView.animate(withDuration: 0) {
            self.chatView.collectionView.contentInset.bottom = keyboardVisibleHeight + self.chatView.messageInputBar.height
            self.chatView.collectionView.scrollIndicatorInsets.bottom = self.chatView.collectionView.contentInset.bottom
          }
        }
      })
      .disposed(by: self.disposeBag)
    
    RxKeyboard.instance.willShowVisibleHeight
      .drive(onNext: { keyboardVisibleHeight in
        self.chatView.collectionView.contentOffset.y += keyboardVisibleHeight
      })
      .disposed(by: self.disposeBag)
  }
}
