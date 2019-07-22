
//
//  File.swift
//  FANZY
//
//  Created by 김연준 on 30/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import UIKit
import SwiftyImage
import Kingfisher

class MessageCell: BaseCell {
  let progress = UIProgressView()
 
  // MARK: Types
  
  fileprivate enum BalloonAlignment {
    case left
    case right
  }
  
  
  // MARK: Constants
  
  struct Metric {
    static let maximumBalloonWidth = 240.f
    static let balloonViewInset = 10.f
  }
  
  struct Font {
    static let label = UIFont.systemFont(ofSize: 14)
  }
  
  
  // MARK: Properties
  
  fileprivate var balloonAlignment: BalloonAlignment = .left
  
  
  // MARK: UI
  
  fileprivate let otherBalloonViewImage = UIImage.resizable()
    .corner(radius: 5)
    .color(UIColor(rgb: 0x313131))
    .image
  
  fileprivate let myBalloonViewImage = UIImage.resizable()
    .corner(radius: 5)
    .color(UIColor(rgb: 0x3c3c3c))
    .image
  
  let balloonView = UIImageView()
  
  let label = UILabel().then {
    $0.font = Font.label
    $0.numberOfLines = 0
  }
  
  let profileImageView = UIImageView()
  
  
  // MARK: Initializing
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.balloonView)
    self.contentView.addSubview(self.label)
    self.contentView.addSubview(self.profileImageView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: Configuring
  
  func configure(message: Message) {
    let processor = ResizingImageProcessor(referenceSize: CGSize(width: 40, height: 40))
      >> RoundCornerImageProcessor(cornerRadius: 20)
    
    self.label.text = message.text
    let url = URL(string: message.userProfile)
    profileImageView.kf.setImage(
      with: url,
      options: [
        .processor(processor),
        .cacheOriginalImage
      ])
    
    switch message.user {
    case .other:
      self.balloonAlignment = .left
      self.balloonView.image = self.otherBalloonViewImage
      self.label.textColor = .white
      self.label.font = UIFont.systemFont(ofSize: 14)
      
    case .me:
      self.balloonAlignment = .right
      self.balloonView.image = self.myBalloonViewImage
      self.label.textColor = .white
      self.label.font = UIFont.systemFont(ofSize: 14)
    }
    
    self.setNeedsLayout()
  }
  
  
  // MARK: Size
  
  class func size(thatFitsWidth width: CGFloat, forMessage message: Message) -> CGSize {
    let labelWidth = Metric.maximumBalloonWidth - Metric.balloonViewInset * 2
    let constraintSize = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
    let rect = message.text.boundingRect(with: constraintSize,
                                         options: options,
                                         attributes: [.font: Font.label],
                                         context: nil)
    let labelHeight = ceil(rect.height)
    return CGSize(width: width, height: labelHeight + Metric.balloonViewInset * 2)
  }
  
  
  // MARK: Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.label.width = Metric.maximumBalloonWidth - Metric.balloonViewInset * 2
    self.label.sizeToFit()
    
    self.profileImageView.width = 40
    self.profileImageView.height = 40
    
    self.balloonView.width = self.label.width + Metric.balloonViewInset * 2
    self.balloonView.height = self.label.height + Metric.balloonViewInset * 2
    
    switch self.balloonAlignment {
    case .left:
      self.profileImageView.left = 10
      self.balloonView.left = self.profileImageView.right + 5
      self.profileImageView.alpha = 1
    case .right:
      self.balloonView.right = self.contentView.width - 10
      self.profileImageView.alpha = 0
    }
    
    self.label.top = self.balloonView.top + Metric.balloonViewInset
    self.label.left = self.balloonView.left + Metric.balloonViewInset
  }
}
