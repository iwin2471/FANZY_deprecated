//
//  ShopView.swift
//  FANZY
//
//  Created by 김연준 on 16/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift
import RxDataSources
import ReactorKit
import UIKit
import SnapKit
import MaterialComponents
import Then
import ReusableKit
import Kingfisher

class ShopView: BaseCell, ReactorKit.View {
  var goodsItems = [Goods]()
  let cache = ImageCache.default
  let options = ["전체", "문화상품권", "커피/음료", "올레", "3사 통합데이터 상품", "편의점금액권", "버거", "베이커리/도넛"]
  let itemImageDictionary = ["전체": "all", "문화상품권":"giftcard", "커피/음료": "coffee", "올레": "olleh", "3사 통합데이터 상품": "phonedata", "편의점금액권": "mart", "버거": "burger", "베이커리/도넛": "bakery"]
  
  enum Reusable {
    static let goodsCell = ReusableCell<GoodsCell>()
    static let optionCell = ReusableCell<ShopOptionCell>()
  }
  
  let layout = UICollectionViewFlowLayout().then {
    $0.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 50)
  }
  
  lazy var optionLayout = UICollectionViewFlowLayout().then {
    $0.itemSize = CGSize(width:100, height: 100)
    $0.scrollDirection = .horizontal
  }
  
  lazy var optionCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100), collectionViewLayout: self.optionLayout).then {
    $0.backgroundColor = .init(rgb:0x212121)
    $0.register(Reusable.optionCell)
  }
  
  lazy var goodsItemList = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 40), collectionViewLayout: self.layout).then{
    $0.backgroundColor = .init(rgb:0x212121)
    $0.register(Reusable.goodsCell)
  }
  
  lazy var ShopSectionDataSource = RxCollectionViewSectionedReloadDataSource<ShopSectionModel> (configureCell: {
    _, collectionView, indexPath, item in
    let cell = collectionView.dequeue(Reusable.goodsCell, for: indexPath)
    cell.setGoods(goods: item.returnItem())
    return cell
  })
  
  override func initialize() {
    super.initialize()
    backgroundColor = UIColor(named: "mainColor")
    self.addSubview(goodsItemList)
    self.addSubview(optionCollection)
  
    cache.memoryStorage.config.expiration = .seconds(10)
  }
  
  override func customise() {
    optionCollection.isPagingEnabled = true
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    optionCollection.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(20)
      make.size.equalTo(CGSize(width: self.frame.width, height: 100))
    }
    
    goodsItemList.snp.makeConstraints { (make) in
      make.top.equalTo(optionCollection.snp.bottom)
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview().offset(15)
      make.trailing.equalToSuperview().offset(-15)
      make.size.equalTo(CGSize(width: self.frame.width - 15, height: self.frame.height-100))
    }
  }
  
  
  
  func bind(reactor: ShopViewReactor) {
    goodsItemList.rx.setDelegate(self).disposed(by: self.disposeBag)
    optionCollection.dataSource = self
    
    
    Observable.just(Reactor.Action.refresh).bind(to: reactor.action).disposed(by: disposeBag)
    
    
    reactor.state.asObservable().map { $0.goodsItems }
      .bind(to: goodsItemList.rx.items(dataSource: self.ShopSectionDataSource))
      .disposed(by: self.disposeBag)
    
    cache.cleanExpiredMemoryCache()
  }
}


extension ShopView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return options.count
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(Reusable.optionCell, for: indexPath)
    let name = options[indexPath.item]
    
    cell.setOption(optionNmae: name, image: self.itemImageDictionary[name]!)
    
    cell.shopOptionButton.rx.tap.subscribe(onNext: {
      if name == "전체" {
        Observable.just(Reactor.Action.refresh).bind(to: self.reactor!.action).disposed(by: self.disposeBag)
      }else{
        Observable.just(Reactor.Action.filter(catagory: name)).bind(to: self.reactor!.action).disposed(by: self.disposeBag)
      }
    })
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let item = ShopSectionDataSource[indexPath]
    let collectionViewSize = collectionView.frame.size.width
        
    return CGSize(width: collectionViewSize/2 - 7.5, height: collectionViewSize/2 + 170)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
