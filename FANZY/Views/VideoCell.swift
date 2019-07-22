//
//  VideoCell.swift
//  FANZY
//
//  Created by 김연준 on 14/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import Kingfisher
import SnapKit

class VideoCell: UICollectionViewCell {
  let videoThumbnail = UIImageView(image: UIImage(named: "userPlaceHolder")?.resized(newSize: CGSize(
    width: UIScreen.main.bounds.width,
    height: UIScreen.main.bounds.width*0.5625)))
  let durationLabel = UILabel()
  let channelPic = UIImageView()
  let videoTitle = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-50, height: 50))
  let videoDescription = UILabel()
  let videoSummary = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 101))
  
  
  let cache = ImageCache(name: "videoThumbnail cache")
  var checkExist = true
  
  var channelPicURL: URL = URL(string: "https://fanzy.io/images/user.png")!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init code not implemented")
  }
  
  func setupView()  {
    videoThumbnail.addSubview(durationLabel)
    
    videoSummary.addSubview(channelPic)
    videoSummary.addSubview(videoTitle)
    videoSummary.addSubview(videoDescription)
    
    addSubview(videoThumbnail)
//    addSubview(durationLabel)
    addSubview(videoSummary)
    
    customise()
  }
  
  
  func customise(){
    channelPic.kf.indicatorType = .activity
    
    
    videoSummary.backgroundColor = .init(rgb: 0x212121)
    
    channelPic.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    
    
    videoTitle.frame = CGRect(x: 0, y: 0, width: videoSummary.frame.width-50, height: videoSummary.frame.height/2)
    
    
    videoTitle.then {
      $0.font = .systemFont(ofSize: 14, weight: .bold)
      $0.lineBreakMode = .byTruncatingTail
      $0.numberOfLines = 2
      $0.adjustsFontSizeToFitWidth = false
      $0.textColor = .white
    }
    
    videoDescription.font = .systemFont(ofSize: 13)
    videoDescription.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.6)
    
    
    self.channelPic.layer.with {
      $0.borderWidth = 1
      $0.masksToBounds = true
      $0.borderColor = UIColor.black.cgColor
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.durationLabel.text = nil
    self.channelPic.image = nil
    self.videoTitle.text = nil
    self.videoDescription.text = nil
  }
  
  func set(video: Video)  {
    let thumnailURL = URL(string: video.thumbnail)!
    var channelPicURL: URL = URL(string: "https://fanzy.io/images/user.png")!
    
    videoThumbnail.kf.setImage(
      with: thumnailURL,
      placeholder: nil,
      options: [
        .processor(CroppingImageProcessor(
          size: CGSize(
            width: 480,
            height: 270
          ),
          anchor: CGPoint(x:0, y: 0.5))
        )])  {
          result in
          switch result {
          case .failure(let error):
            self.checkExist = false
            break
          case .success(let value):
            print(value)
          }
    }
    
    
    if let avatar = video.creator["avatar"] as? String{
      channelPicURL = URL(string: avatar)!
    }
    
    let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 32, height: 32))
      >> RoundCornerImageProcessor(cornerRadius: 16)
    
    channelPic.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    channelPic.kf.setImage(with: channelPicURL, placeholder: nil, options: [.processor(resizingProcessor)])
    
    channelPic.contentMode = .scaleAspectFill
    channelPic.clipsToBounds = true
    
    self.channelPic.layer.then {
      $0.borderWidth = 1
      $0.masksToBounds = true
      $0.borderColor = UIColor.black.cgColor
      $0.cornerRadius = self.channelPic.frame.width/2
    }
    
    self.videoTitle.text = video.title
    
    let name: String = video.creator["name"] as! String
    
    if name.count > 16 {
      let subName = name.prefix(16)
      self.videoDescription.text =  "\(subName)... • 조회수 \(video.viewCount)회 • \(video.publishedAt)"
    } else {
      self.videoDescription.text =  "\(name) • 조회수 \(video.viewCount)회 • \(video.publishedAt)"
    }
    
    
    setupLayout()
    
    durationLabel.text = "\(video.playtime)"
    durationLabel.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: durationLabel.textWidth() + 12, height:18))
    }
  }
  
  
  func setupLayout() {
    durationLabel.snp.removeConstraints()
    
    durationLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(UIScreen.main.bounds.width*0.5625 - 25)
      make.trailing.equalToSuperview().offset(-6)
    }
    
    videoSummary.snp.makeConstraints { (make) in
      make.top.equalTo(videoThumbnail.snp_bottom)
      make.size.equalTo(CGSize(width: frame.width, height: 50))
    }
    channelPic.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(10)
    }
    videoTitle.snp.makeConstraints { (make) in
      make.top.equalTo(channelPic.snp_top).offset(0)
      make.leading.equalToSuperview().offset(55)
      make.trailing.equalToSuperview().offset(-30)
    }
    
    durationLabel.then {
      $0.textAlignment = .center
      $0.textColor = .white
      $0.font = .systemFont(ofSize: 13)
      $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 4
    }
    
    videoDescription.snp.makeConstraints { (make) in
      make.top.equalTo(videoTitle.snp_bottom).offset(5)
      make.leading.equalTo(videoTitle.snp_leading)
    }
    
  }
  
  func height() -> CGFloat {
    return self.videoTitle.frame.height + self.videoDescription.frame.height
  }
}
