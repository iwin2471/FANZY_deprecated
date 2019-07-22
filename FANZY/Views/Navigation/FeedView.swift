//
//  FeedView.swift
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
import Then
import ReusableKit
import Kingfisher


class FeedView: BaseCell, ReactorKit.View {
  var videos = [Video]()
  let cache = ImageCache.default

  
  enum Reusable {
    static let videoCell = ReusableCell<VideoCell>()
  }
  
  let layout = UICollectionViewFlowLayout().then {
    $0.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*0.5625 + 85)
  }
  
  lazy var feed = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout).then{
    $0.backgroundColor = .init(rgb:0x212121)
    $0.register(Reusable.videoCell)
  }
  
  let collectionViewDataSource = RxCollectionViewSectionedReloadDataSource<VideoCellSelection> (configureCell: { _, collectionView, indexPath, video in
    let cell = collectionView.dequeue(Reusable.videoCell, for: indexPath)
    
    cell.set(video: video)
    
    return cell
  })
  
  @objc func reloadVideoListWithArray(notification: NSNotification) {
    if let newValue = notification.object as? [Video] {
      if newValue.count == 0 {
        let alertController = UIAlertController(title: "FANZY", message:
          "검색결과가 없습니다", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
//        homeC.present(alertController, animated: true, completion: nil)
      }else{
        self.videos = newValue
        self.feed.reloadData()
      }
    }
  }
  
  override func initialize() {
    super.initialize()
    print(self.frame)
    self.addSubview(self.feed)
    backgroundColor = .white
    cache.memoryStorage.config.expiration = .seconds(10)
    setupLayout()
  }
  
  func setupLayout() {
    feed.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: self.frame.width, height: self.frame.height))
    }
  }
  
  override func customise() {
    
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    
  }

  
  
  
  func bind(reactor: FeedViewReactor) {
    feed.rx.setDelegate(self).disposed(by: self.disposeBag)
    
    Observable.just(Reactor.Action.refresh).bind(to: self.reactor!.action).disposed(by: disposeBag)
    
    feed.nextPage
      .distinctUntilChanged()
      .subscribe(onNext: {
        if $0 {
          Observable.just(Reactor.Action.loadMore).bind(to: reactor.action).dispose()
        }
      }).disposed(by: disposeBag)
    
    reactor.state.asObservable().map { $0.videos }
      .bind(to: feed.rx.items(dataSource: self.collectionViewDataSource))
      .disposed(by: self.disposeBag)
    
    
    cache.cleanExpiredMemoryCache()
  }
}


extension FeedView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

extension FeedView {
  func search(query: String){
    Observable.just(Reactor.Action.search(query: query)).bind(to: self.reactor!.action).disposed(by: disposeBag)
  }
}
