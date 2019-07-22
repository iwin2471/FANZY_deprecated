//
//  StoreService.swift
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

enum StoreEvent {

}

protocol StoreServiceType {
  var event: PublishSubject<StoreEvent> { get }
  func fetchItems() -> Observable<[Goods]>
  func filterItems(catagory: String) -> Observable<[Goods]?>
  func getSpecificItem(goodsID: String) -> Observable<[[String: Any]]>
}

final class StoreService: BaseService, StoreServiceType {
  
  func filterItems(catagory: String) -> Observable<[Goods]?> {
    if let savedGoods = self.provider.userDefaultsService.value(forKey: .goods) {
      let goods = savedGoods.compactMap{ Goods(JSON: $0) }
      return .just(goods.filter { $0.category2 == catagory })
    }
    return .just(nil)
  }
  
  let event = PublishSubject<StoreEvent>()
  let disposeBag = DisposeBag()
  
  let storeProvider = MoyaProvider<StoreNetworkModel>()
  
  func fetchItems() -> Observable<[Goods]> {
    
    if let savedGoods = self.provider.userDefaultsService.value(forKey: .goods) {
      let goods = savedGoods.compactMap{ Goods(JSON: $0) }
      return .just(goods)
    }
    
    
    return storeProvider.rx
      .request(.getItems)
      .mapJSON(failsOnEmptyData: true)
      .asObservable()
      .map {
        let goods = $0 as! [[String: Any]]
        self.provider.userDefaultsService.set(value: goods, forKey: .goods)
        
        let final:[Goods] = goods.map {
          var goodsItem: Goods? = nil
          goodsItem = Goods(JSON: $0)
          return goodsItem!
        }
       
        return final
      }
  }
  
  
  
  func getSpecificItem(goodsID: String) -> Observable<[[String : Any]]> {
    return storeProvider.rx
      .request(.getSpecificItem(goodsID: goodsID))
      .mapJSON(failsOnEmptyData: true)
      .asObservable()
      .map{
        return $0 as! [[String: Any]]
    }
  }
  
}
