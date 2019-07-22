//
//  File.swift
//  FANZY
//
//  Created by 김연준 on 16/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources



typealias RelateVideoSection = SectionModel<RelateVideoSelecion, RelateVideoCellReactor>

enum RelateVideoSelecion {
  case history
  case playlist
  case recommand
}


class PlayerReactor: Reactor {
  enum PlayerState {
    case fullScreen
    case minimized
    case hidden
    case start
    case chatRoom
  }
  
  enum Direction {
    case up
    case left
    case none
  }
  
  enum Action {
    case hidden
    case doGesture(UIPanGestureRecognizer)
    case relate(videoID: String)
    case loadMore
  }
  
  enum Mutation {
    case setHidden
    case moving(UIPanGestureRecognizer)
    case setRelate([RelateVideoSection])
    case insertSectionItem(IndexPath, RelateVideoSection)
  }
  
  struct State {
    var video: Video?
    var videoID: String
    var playerState: PlayerState
    var gestureState: UIPanGestureRecognizer?
    var relateVideo: [RelateVideoSection]
  }
  
  let provider: ServiceProviderType
  let initialState: State
  var direction = Direction.up
  
  init(video: Video?, playerState: PlayerState) {
    self.provider = ServiceProvider()
    
    self.initialState = State(video: video, videoID: video!.org_video_id ,playerState: playerState, gestureState: nil, relateVideo: [RelateVideoSection(model: .recommand, items: [video!].map(RelateVideoCellReactor.init)) ])
  }
  
  func mutate(action: PlayerReactor.Action) -> Observable<Mutation> {
    switch action {
      //    case .minimized:
      //      return .just(.setMinimize)
      //    case .fullScreen:
    //      return .just(.setFullScreen)
    case .hidden:
      return .just(.setHidden)
    case .doGesture(let gesture):
      return .just(.moving(gesture))
      
    case let .relate(videoID):
      return provider.videoService.getRelateVideo(videoID: videoID)
        .asObservable()
        .map {
          let videos = $0.compactMap { Video(JSON: $0) }
          
          let videoReators = videos.map(RelateVideoCellReactor.init)
          
          let video = RelateVideoSection(model: .recommand, items: videoReators)
          
          return .setRelate([video])
      }
      
    case .loadMore:
      return self.provider.videoService.fetchVideos()
        .map {
          let videos = $0.compactMap { Video(JSON: $0) }
          
          let videoReators = videos.map(RelateVideoCellReactor.init)
          
          let video = RelateVideoSection(model: .recommand, items: videoReators)
          
          let indexPath = IndexPath(item: 0, section: 0)
          
          return .insertSectionItem(indexPath, video)
      }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .moving(gesture):
      if gesture.state == .began {
        let velocity = gesture.velocity(in: nil)
        if abs(velocity.x) < abs(velocity.y) {
          direction = .up
        } else {
          direction = .left
        }
      }
      
      
      if(gesture.state == .ended){
        switch newState.playerState {
        case .fullScreen:
          let factor = (abs(gesture.translation(in: nil).y) / UIScreen.main.bounds.height)
//          self.changeValues(scaleFactor: factor)
//          self.delegate?.swipeToMinimize(translation: factor, toState: .minimized)
          if direction != .left {
            newState.playerState = .minimized
            newState.gestureState = gesture
          }
        case .minimized:
          if self.direction == .left {
          //          finalState = .hidden
          //          let factor: CGFloat = sender.translation(in: nil).x
          //          self.delegate?.swipeToMinimize(translation: factor, toState: .hidden)
          //          stopTokenReward()
          //          socket.emit("request reward", id!,  video.org_video_id, YTPlayer.currentTime, rewardCount, self.coinLabel.text!)
            
            newState.playerState = .hidden
          } else {
            newState.playerState = .fullScreen
            newState.gestureState = gesture
            //        let factor = 1 - (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
            //        self.changeValues(scaleFactor: factor)
            //        self.delegate?.swipeToMinimize(translation: factor, toState: .fullScreen)
          }
          
        case .hidden:
          newState.playerState = .hidden
          newState.gestureState = gesture
        case .start:
          newState.playerState = .start
        case .chatRoom:
          newState.playerState = .fullScreen
        }
      }
    case .setHidden:
      newState.playerState = .hidden
      
    case let .setRelate(relate):
      newState.relateVideo = relate
    
    case let .insertSectionItem(indexPath, sectionItem):
      newState.relateVideo.insert(sectionItem, at: indexPath.item)
    }
    return newState
  }
}



