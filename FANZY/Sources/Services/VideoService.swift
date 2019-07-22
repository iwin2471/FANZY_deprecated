//
//  VideoService.swift
//  FANZY
//
//  Created by 김연준 on 14/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Alamofire
import Moya
import RxAlamofire
import RxSwift
import RxCocoa

enum VideoEvent {
  case create(Video)
  case update(Video)
  case delete(id: String)
}

protocol VideoServiceType {
  var event: PublishSubject<VideoEvent> { get }
  func fetchVideos() -> Observable<[[String: Any]]>
  func searchVideo(query: String) -> Observable<[Video]>
  
  func getRelateVideo(videoID: String) -> Observable<[[String: Any]]>
}

final class VideoService: BaseService, VideoServiceType {
  let event = PublishSubject<VideoEvent>()
  let disposeBag = DisposeBag()
  
  let videoProvider = MoyaProvider<VideoNetworkModel>()
  
  func fetchVideos() -> Observable<[[String: Any]]> {
    return videoProvider.rx
      .request(.randomVideo)
      .mapJSON(failsOnEmptyData: true)
      .asObservable()
      .map {
        return $0 as! [[String: Any]]
      }
  }
  
  func searchVideo(query: String) -> Observable<[Video]> {
    return videoProvider.rx.request(.search(query: query))
      .mapJSON(failsOnEmptyData: true)
      .asObservable()
      .map {
        $0 as! [[String: Any]]
      }
      .map {
        let videos = $0
        
        let finalValue:[Video] = videos.map {
          var videoItem: Video? = nil
          videoItem = Video(JSON: $0)
          return videoItem!
        }
        
        print(finalValue)
        
        return finalValue
      }
  }
  
  func getRelateVideo(videoID: String) -> Observable<[[String : Any]]> {
    print("getRelate")
    return videoProvider.rx
      .request(.relate(videoID: videoID))
      .mapJSON(failsOnEmptyData: true)
      .asObservable()
      .map{
        let videoListObject = $0 as! [String: Any]
        
        return videoListObject["videosList"] as! [[String: Any]]
      }
  }
  
}

