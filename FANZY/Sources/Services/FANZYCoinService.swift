
//
//  FANZYCoinService.swift
//  FANZY
//
//  Created by 김연준 on 14/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Alamofire
import RxSwift

enum CoinEvent {
  case create(Video)
  case update(Video)
  case delete(id: String)
}

protocol FanzyCoinServiceType {
  var event: PublishSubject<CoinEvent> { get }
  func getCoin() -> Observable<String>
  
//  @discardableResult
//  func savePlan(_ tasks: [Video]) -> Observable<Void>
  
//  func create(title: String, memo: String?) -> Observable<Video>
//  func update(taskID: String, title: String, memo: String?) -> Observable<Video>
//  func delete(taskID: String) -> Observable<Video>
}

final class FanzyCoinService: BaseService, FanzyCoinServiceType {
  let event = PublishSubject<CoinEvent>()
  
  func getCoin() -> Observable<String> {
    
    let url = "https://iwin247.kr/user/balance?email=\(email)"
    let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    Alamofire.request(encodedUrl!).responseJSON(completionHandler: { (response) in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any] {
          let token = json["balance"] as! NSNumber
          let tokenAmount = "\(floor(token as! Double * 100000000) / 100000000)"
          
        }
      case .failure(let error):
        print(error)
      }
    })
    
    return .just("0")
  }
}

