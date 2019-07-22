//
//  FeedViewReactor.swift
//  FANZY
//
//  Created by 김연준 on 16/04/2019.
//  Copyright © 2019 underpin. All rights reserved.

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift

typealias VideoCellSelection = SectionModel<Void, Video>


final class FeedViewReactor: Reactor {
  enum Action {
    case refresh
    case loadMore
    case search(query: String)
  }
  
  enum Mutation {
    case setVideos([VideoCellSelection])
    case moreVideos([VideoCellSelection])
    case insertSectionItem(IndexPath, VideoCellSelection)
  }
  
  struct State {
    var newVideo: [VideoCellSelection] = []
    var videos: [VideoCellSelection]
  }
  
  let provider: ServiceProviderType
  let initialState: State
  
  init(provider: ServiceProviderType) {
    self.provider = provider
    self.initialState = State(
      newVideo: [VideoCellSelection(model: Void(), items: [])],
      videos: [VideoCellSelection(model: Void(), items: [])]
    )
  }
  
  func mutate(action: FeedViewReactor.Action) -> Observable<FeedViewReactor.Mutation> {
    switch action {
    case .refresh:
      return self.provider.videoService.fetchVideos()
        .map {
          var newValue = [Video]()
          newValue = $0.map {
            var video: Video? = nil
            video = Video(JSON: $0)
            return video!
          }
//          let sectionItems = newValue.map(VideoCellReactor.init)
          let video = VideoCellSelection(model: Void(), items: newValue)
          return .setVideos([video])
        }
    case .loadMore:
      return self.provider.videoService.fetchVideos()
        .map {
          var newValue = [Video]()
          newValue = $0.map {
            var video: Video? = nil
            video = Video(JSON: $0)
            return video!
          }
          let video = VideoCellSelection(model: Void(), items: newValue)
          let indexPath = IndexPath(item: self.currentState.videos.count - 1, section: 0)
          
          return .insertSectionItem(indexPath, video)
      }
    case .search(let query):
      return self.provider.videoService.searchVideo(query: query).map {
        print($0)
        let video = VideoCellSelection(model: Void(), items: $0)
        return .setVideos([video])}
    }
    
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setVideos(videos):
      state.videos = videos
    case let .moreVideos(videos):
      state.newVideo = videos
      
    case let .insertSectionItem(indexPath, sectionItem):
      state.videos.insert(sectionItem, at: indexPath.item)
    }
    return state
  }
}
