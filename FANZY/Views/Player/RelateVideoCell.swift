//
//  RelateVideoCell.swift
//  FANZY
//
//  Created by 김연준 on 21/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import ReactorKit
import Kingfisher

class RelateVideoCell: BaseTableViewCell, ReactorKit.View{
  typealias Reactor = RelateVideoCellReactor
  
  var thumbnail = UIImageView()
  var title = UILabel()
  var view = UILabel()
  var name = UILabel()
  let durationLabel = UILabel()
  let baseWidth = UIScreen.main.bounds.width/2.4
  let baseHeight = UIScreen.main.bounds.width/2.4 * 0.5625
  
  // MARK: Constants
  
  struct Constant {
    static let titleLabelNumberOfLines = 2
  }
  
  struct Metric {
    static let cellPadding = 15.0
  }
  
  struct Font {
    static let titleLabel = UIFont.systemFont(ofSize: 14)
  }
  
  struct Color {
    static let titleLabelText = UIColor.black
  }
  
  override func initialize() {
    super.initialize()
    addSubview(thumbnail)
    addSubview(title)
    addSubview(name)
    addSubview(view)
    thumbnail.addSubview(durationLabel)
    
    backgroundColor = .init(rgb: 0x212121)
    
    layout()
  }
  
  override func customise() {
    self.title.textColor = .white
    self.title.numberOfLines = 3
    self.title.font = UIFont.systemFont(ofSize: 16)
    self.name.textColor = .white
    self.name.alpha = 0.7
    self.name.font = UIFont.systemFont(ofSize: 14)
    self.view.textColor = .white
    self.view.alpha = 0.7
    self.view.font = UIFont.systemFont(ofSize: 14)
    self.thumbnail.frame = CGRect(x: 0, y: 0, width: baseWidth, height: baseHeight)
    
    self.durationLabel.then {
      $0.frame = CGRect(x: 0, y: 0, width: self.durationLabel.frame.width+20, height: self.durationLabel.frame.height + 8)
      $0.textAlignment = .center
      $0.textColor = .white
      $0.lineBreakMode = .byWordWrapping
      $0.numberOfLines = 1
      $0.font = .systemFont(ofSize: 13)
      $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 4
    }
  }
  
  func layout() {
    thumbnail.snp.makeConstraints { (make) in
      make.top.leading.equalToSuperview().offset(20)
      make.bottom.equalToSuperview().inset(2)
      make.size.equalTo(CGSize(width: baseWidth, height: baseHeight))
    }
    
    durationLabel.snp.removeConstraints()
    
    durationLabel.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().offset(-6)
      make.trailing.equalToSuperview().offset(-6)
    }
    
    title.snp.makeConstraints { (make) in
      make.top.equalTo(thumbnail.snp_top).offset(1)
      make.leading.equalTo(thumbnail.snp_trailing).offset(20)
      make.trailing.equalToSuperview().offset(-60)
    }
    
    name.snp.makeConstraints { (make) in
      make.top.equalTo(title.snp_bottom).offset(6)
      make.leading.equalTo(title.snp_leading)
    }
    
    view.snp.makeConstraints { (make) in
      make.top.equalTo(name.snp_bottom).offset(2)
      make.leading.equalTo(title.snp_leading)
    }
  }
  
  
  func bind(reactor: RelateVideoCellReactor) {
    var thumbnailURL = URL(string: "https://fanzy.io/pc/images/logo.png")!
    
    self.title.text = reactor.currentState.title
    self.view.text = "조회수 \(reactor.currentState.viewCount)회"
    self.name.text = reactor.currentState.creator["name"] as! String
    thumbnailURL = URL(string: reactor.currentState.thumbnail)!
    self.durationLabel.text = "\(reactor.currentState.playtime)"
    self.durationLabel.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: durationLabel.textWidth() + 12, height:18))
    }
    
    thumbnail.kf.setImage(
      with: thumbnailURL,
      placeholder: nil,
      options: [.processor(CroppingImageProcessor(
        size: CGSize(
          width: 480,
          height: 270
        ),
        anchor: CGPoint(x:0, y: 0.5))
        )])
  }
  
  class func height(fits width: CGFloat, reactor: Reactor) -> CGFloat {
    
    let height =  UIScreen.main.bounds.width/2.4 * 0.5625
    
    return CGFloat(height) + CGFloat(Metric.cellPadding * 2)
  }
}
