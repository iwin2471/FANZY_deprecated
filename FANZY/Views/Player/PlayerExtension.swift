//
//  PlayerExtension.swift
//  FANZY
//
//  Created by 김연준 on 16/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher
import YoutubeKit
import SnapKit
import RxSwift
import RxCocoa

extension PlayerView {
  func rewardSocket(){
    
    socket.on("test") { data, ack in
      print("hello")
    }
  }
  
  func playerViewCustom(){
    self.player.backgroundColor = .black
    
    let height = UIScreen.main.bounds.width * 9 / 16
    let videoPlayerFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
    self.player.frame = videoPlayerFrame
    
    
    
    //    self.player.rx
    //      .panGesture()
    //      .when(.recognized)
    //      .asTranslation()
    //      .subscribe(onNext: { [unowned self] translation, _ in
    //        print("x: \(translation.x) y: \(translation.y)")
    //        view?.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    //      })
    //      .disposed(by: disposeBag)
  }
  
  func videoSummary(){
    
    videoTitle.text = "video!.title"
    viewCount.text = "0 views"
    channelTitle.text = "-"
    coinLabel.text = "0.0"
    
    
    channelPic.layer.with {
      $0.borderWidth = 1
      $0.masksToBounds = true
      $0.borderColor = UIColor.black.cgColor
      $0.cornerRadius = channelPic.frame.width/2.25
    }
    
    channelPic.clipsToBounds = true
    
    channelSubscribers.text = "10 subscribers"
  }
}


extension PlayerView: UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let reactor = self.dataSource[indexPath]
    
    return RelateVideoCell.height(fits: tableView.width, reactor: reactor)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}


extension ConstraintMaker{
  public func aspectRatio(_ x: Int, by y: Int, self instance: ConstraintView) {
    self.width.equalTo(instance.snp.height).multipliedBy(x / y)
  }
}

extension Reactive where Base: YTSwiftyPlayer {
  
  public var origin: Binder<String?> {
    return Binder(self.base) { player, origin in
      player.cueVideo(videoID: origin!)
//      player.pauseVideo()
      player.loadVideo(videoID: origin!)
    }
  }
}




//MARK: Player rx extenstion
extension Reactive where Base: PlayerView {
  func positionDuringSwipe(scaleFactor: CGFloat) -> CGPoint {
    let width = UIScreen.main.bounds.width * 0.5 * scaleFactor
    let height = width * 9 / 16
    let x = (UIScreen.main.bounds.width - 10) * scaleFactor - width
    let y = (UIScreen.main.bounds.height - 10) * scaleFactor - height - 10
    let coordinate = CGPoint.init(x: x, y: y)
    return coordinate
  }
  
  
  //  func swipeToMinimize(translation: CGFloat, toState: stateOfVC){
  //    switch toState {
  //    case .fullScreen:
  //      self.view.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
  //    case .hidden:
  //      self.view.frame.origin.x = UIScreen.main.bounds.width/2 - abs(translation) - 10
  //    case .minimized:
  //      self.view.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
  //    }
  //  }
  
  internal var PlayerAnimation: Binder<PlayerReactor.PlayerState>{
    
    return Binder(self.base) { view, data in
      switch data {
      case .fullScreen:
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.beginFromCurrentState], animations: {
          view.frame.origin = view.fullScreenOrigin
          view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        })
        
        UIView.animate(withDuration: 0.3, animations: {
          view.relateVideoList.alpha = 1
          view.player.transform = CGAffineTransform.identity
          view.statusBar.isHidden = true
          view.summary.alpha = 1
          view.backgroundColor = .init(rgb: 0x212121, alpha: 1)
        })
      case .minimized:
        UIView.animate(withDuration: 0.3, animations: {
          view.frame.origin = CGPoint.init(x: view.x2, y: view.y2)
          
          //        self.playerView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        })
        
        UIView.animate(withDuration: 0.3, animations: {
          view.statusBar.isHidden = false
          view.relateVideoList.alpha = 0
          view.summary.alpha = 0
          
          let scale = CGAffineTransform.init(scaleX: 0.6, y: 0.6)
          
          let trasform = scale.concatenating(CGAffineTransform.init(translationX: -view.player.bounds.width/4, y: -view.player.bounds.height/4))

          view.player.transform = trasform
//          view.player.isUserInteractionEnabled = true
          
//          view.isUserInteractionEnabled = false
          
          view.backgroundColor = UIColor(white: 1, alpha: 0)
        })
      case .hidden:
        UIView.animate(withDuration: 0.3, animations: {
          view.frame.origin = view.hiddenOrigin
        })
        view.YTPlayer.pauseVideo()
        view.chat.removeAllCell()
        view.chat.removeFromSuperview()
      case .start:
        view.frame.origin = view.hiddenOrigin
      case .chatRoom:
        break
      }
    }
  }
}
