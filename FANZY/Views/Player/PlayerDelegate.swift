//
//  PlayerDelegate.swift
//  FANZY
//
//  Created by 김연준 on 10/06/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import YoutubeKit
import RxSwift

extension ChatRoomViewController: YTSwiftyPlayerDelegate {
  public func playerReady(_ player: YTSwiftyPlayer) {
    print("readys")
    socketBind(player: player)
  }
  
  public func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double) {
    
  }
  
  public func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {
    print("\(#function):\(state)")
    
    videoStateObserve.on(.next(state))
    
    switch state {
    case .unstarted:
      
      break
    case .ended:
      self.playerView.stopTokenReward()
      break
    case .playing:
      self.playerView.startTokenReward()
      break
    case .paused:
      self.playerView.stopTokenReward()
      break
    case .buffering:
      self.playerView.stopTokenReward()
      break
    case .cued:
      break
    @unknown default:
      break
    }
  }
  
  public func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double) {
  }
  
  public func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {
    print("에러임 \(error)")
  }
  
  public func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality) {
    
  }
  
  public func apiDidChange(_ player: YTSwiftyPlayer) {
    
  }
  
  public func youtubeIframeAPIReady(_ player: YTSwiftyPlayer) {
    
  }
  
  public func youtubeIframeAPIFailedToLoad(_ player: YTSwiftyPlayer) {
    print(#function)
  }
  
  private func socketBind(player: YTSwiftyPlayer){
    socket.emit("player status check", chatView.reactor!.currentState.roomId)
    
    socket.rx.on("response:player status check")
      .asObservable()
      .distinctUntilChanged({
        let videoUrlFirst = $0[2] as! String
        guard let videoUrlSecond = $1[2] as? String else { return false }
        
        if videoUrlFirst == videoUrlSecond {
          return true
        }
        return false
      })
      .subscribe(onNext: {
        let videoUrl = $0[2] as! String
        
        if videoUrl != "https://www.youtube.com/watch" {
          let videoID = videoUrl.components(separatedBy: "v=")[1]
          let curretTime = $0[0] as! NSNumber
          let curretStatus = $0[1] as! NSNumber
          let info = player.currentVideoURL
          player.alpha = 1
          
          
          
          guard let exist = info?.contains(videoID) else { return }
          
          if exist {
            player.cueVideo(videoID: videoID)
            player.pauseVideo()
            player.loadVideo(videoID: videoID)
          } else {
            _ = Observable.just(videoID).bind(to: player.rx.origin)
            
          }
          
          let chatCollectionExist = self.chatView.collectionView.isDescendant(of: self.view)
          
          if chatCollectionExist {
            self.chatView.collectionView.removeFromSuperview()
          }
          
          
          self.videoStateObserve
            .distinctUntilChanged()
            .subscribe(onNext: {
              if $0 == .playing && player.currentTime != Double(curretTime.intValue) {
                player.seek(to: curretTime.intValue, allowSeekAhead: true)
                
                if  curretStatus.intValue != -1 {
                  self.checkStatus(player: player, status: self.intToVideoStatus[curretStatus.intValue])
                }
                
                self.videoStateObserve.dispose()
              }
            }).disposed(by: self.disposeBag)
        }
        
      }).disposed(by: self.disposeBag)
    
  }

  func  checkStatus(player: YTSwiftyPlayer, status: YTSwiftyPlayerState) {
    switch status{
    case .unstarted:
      break
    case .ended:
      
      
      break
    case .playing:
      
      
      break
    case .paused:
      player.pauseVideo()
      break
    case .buffering:
      
      
      break
    case .cued:
      break
    default:
      break
      
    }
  }
  
}


extension PlayerView: YTSwiftyPlayerDelegate {
  func startTokenReward() {
    print("startTokenReward")
    coinCounterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.cuntCoin), userInfo: nil, repeats: true)
  }
  
  func stopTokenReward() {
    coinCounterTimer.invalidate()
  }
  
  public func playerReady(_ player: YTSwiftyPlayer) {
  }
  
  public func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double) {
    
  }
  
  public func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {
    print("\(#function):\(state)")
    
    switch state {
    case .unstarted:
      break
    case .ended:
      print("end")
      print("endduration: \(player.currentTime)")
      stopTokenReward()
      break
    case .playing:
      print("play",self.reactor!.currentState.video)
      startTokenReward()
      break
    case .paused:
      print("paused")
      stopTokenReward()
      break
    case .buffering:
      print("buffering")
      stopTokenReward()
      break
    case .cued:
      break
    @unknown default:
      break
    }
  }
  
  public func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double) {
  }
  
  public func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {
    print("player Error: \(error)")
  }
  
  public func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality) {
    
  }
  
  public func apiDidChange(_ player: YTSwiftyPlayer) {
    
  }
  
  public func youtubeIframeAPIReady(_ player: YTSwiftyPlayer) {
  }
  
  public func youtubeIframeAPIFailedToLoad(_ player: YTSwiftyPlayer) {
    print(#function)
  }
}
