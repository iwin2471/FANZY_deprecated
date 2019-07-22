//
//  ChatCell.swift
//  FANZY
//
//  Created by 김연준 on 01/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation

import UIKit
import ReactorKit
import RxSwift
import SwiftyImage


final class ChatCell: BaseTableViewCell, ReactorKit.View {
  typealias Reactor = ChatCellReactor
  
  struct Constant {
    static let titleLabelNumberOfLines = 1
  }
  
  struct Metric {
    static let cellPadding = 30.0
  }
  
  let titleLabel = UILabel().then {
    $0.textColor = .white
    $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    $0.lineBreakMode = .byTruncatingTail
    $0.numberOfLines = 1
    $0.adjustsFontSizeToFitWidth = false
  }
  
  let participantCountLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    $0.textColor = .white
  }
  
  let latestMessageLabel = UILabel().then {
    $0.textColor = .white
    $0.font = UIFont.systemFont(ofSize: 15)
    $0.alpha = 0.75
    $0.lineBreakMode = .byTruncatingTail
    $0.numberOfLines = 2
    $0.adjustsFontSizeToFitWidth = false
  }
  
  let latestMessageDateLabel = UILabel().then {
    $0.textColor = .white
    $0.font = UIFont.systemFont(ofSize: 15)
    $0.alpha = 0.4
  }
  
  let unReadMessages = UIView().then {
    $0.backgroundColor = .init(rgb: 0xf9415f)
    $0.layer.masksToBounds = true;
    $0.layer.cornerRadius = 11
  }
  
  let unReadMessagesLabel = UILabel().then {
    $0.textColor = .white
    $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
  }
  
  var circleProfileView = UIView()
  
  var avatar1 = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 7
    $0.layer.masksToBounds = false
    $0.clipsToBounds = true
    $0.layer.masksToBounds = true
    $0.snp.makeConstraints({ (make) in
      make.width.equalTo(50)
      make.height.equalTo(50)
    })
  }
  
  var avatar2A = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 7
    $0.layer.masksToBounds = false
    $0.clipsToBounds = true
    $0.layer.masksToBounds = true
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1;
    $0.snp.makeConstraints({ (make) in
      make.width.equalTo(33)
      make.height.equalTo(33)
    })
  }
  
  var avatar2B = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 7
    $0.layer.masksToBounds = false
    $0.clipsToBounds = true
    $0.layer.masksToBounds = true
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1;
    $0.snp.makeConstraints({ (make) in
      make.width.equalTo(33)
      make.height.equalTo(33)
    })
  }
  
  var avatar3A = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 7
    $0.layer.masksToBounds = false
    $0.clipsToBounds = true
    $0.layer.masksToBounds = true
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1;
    $0.snp.makeConstraints({ (make) in
      make.width.equalTo(30)
      make.height.equalTo(30)
    })
  }
  
  var avatar3B = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 7
    $0.layer.masksToBounds = false
    $0.clipsToBounds = true
    $0.layer.masksToBounds = true
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1;
    $0.snp.makeConstraints({ (make) in
      make.width.equalTo(30)
      make.height.equalTo(30)
    })
  }
  
  var avatar3C = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 7
    $0.layer.masksToBounds = false
    $0.clipsToBounds = true
    $0.layer.masksToBounds = true
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1;
    $0.snp.makeConstraints({ (make) in
      make.width.equalTo(30)
      make.height.equalTo(30)
    })
  }
  
  var avatar4A = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 7
    $0.layer.masksToBounds = false
    $0.clipsToBounds = true
    $0.layer.masksToBounds = true
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1;
    $0.snp.makeConstraints({ (make) in
      make.width.equalTo(24.5)
      make.height.equalTo(24.5)
    })
  }
  
  var avatar4B = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 7
    $0.layer.masksToBounds = false
    $0.clipsToBounds = true
    $0.layer.masksToBounds = true
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1;
    $0.snp.makeConstraints({ (make) in
      make.width.equalTo(24.5)
      make.height.equalTo(24.5)
    })
  }
  
  var avatar4C = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 7
    $0.layer.masksToBounds = false
    $0.clipsToBounds = true
    $0.layer.masksToBounds = true
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1;
    $0.snp.makeConstraints({ (make) in
      make.width.equalTo(24.5)
      make.height.equalTo(24.5)
    })
  }
  
  var avatar4D = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 7
    $0.layer.masksToBounds = false
    $0.clipsToBounds = true
    $0.layer.masksToBounds = true
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1;
    $0.snp.makeConstraints({ (make) in
      make.width.equalTo(24.5)
      make.height.equalTo(24.5)
    })
  }
  
  
  // MARK: Initializing
  
  override func initialize() {
    self.contentView.addSubview(self.titleLabel)
    self.contentView.addSubview(self.participantCountLabel)
    self.contentView.addSubview(self.circleProfileView)
    self.contentView.addSubview(self.latestMessageLabel)
    self.contentView.addSubview(self.latestMessageDateLabel)
    self.contentView.addSubview(self.unReadMessages)
    
    self.unReadMessages.addSubview(self.unReadMessagesLabel)
    
    super.initialize()
  }
  
  
  override func customise() {
    backgroundColor = .init(rgb: 0x212121)
    test()
  }
  
  func test() {
    circleProfileView.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(15)
      make.width.equalTo(50)
      make.height.equalTo(50)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(circleProfileView.snp.top).offset(-2)
      make.leading.equalTo(circleProfileView.snp.trailing).offset(15)
    }
    
    participantCountLabel.snp.makeConstraints({ (make) in
      make.top.equalTo(titleLabel.snp.top)
      make.leading.equalTo(titleLabel.snp.trailing).offset(10)
    })
    
    latestMessageLabel.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(6)
      make.leading.equalTo(titleLabel.snp_leading)
      make.trailing.equalToSuperview().offset(-100)
    }
    
    latestMessageDateLabel.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.top)
      make.trailing.equalToSuperview().offset(-15)
    }
    
    unReadMessages.snp.makeConstraints { (make) in
      make.width.equalTo(22)
      make.height.equalTo(22)
      make.top.equalTo(latestMessageDateLabel.snp.bottom).offset(6)
      make.trailing.equalTo(latestMessageDateLabel.snp.trailing)
    }
    
    unReadMessagesLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
  
  
  override func setupConstraints() {
    
  }
  
  
  
  // MARK: Binding
  
  func bind(reactor: Reactor) {
    self.titleLabel.text = reactor.currentState.title
    self.participantCountLabel.text = "\(reactor.currentState.participantCount)"
    self.latestMessageLabel.text = reactor.currentState.latestMessage
    self.latestMessageDateLabel.text = reactor.currentState.latestMessageDate
    self.unReadMessagesLabel.text = "\(reactor.currentState.unReadMessages)"
    setCell(chat: reactor.currentState)
  }
  
  // MARK: Cell Height
  
  class func height(fits width: CGFloat, reactor: Reactor) -> CGFloat {
    return 80
  }
}

extension ChatCell {
  func setCell(chat: Chat){
    let participantCount = UILabel()
    
    if chat.participantCount > 2 {
      participantCountLabel.alpha = 0.3
    } else {
      participantCountLabel.alpha = 0
    }
    
    if chat.unReadMessages > 0 {
      unReadMessages.alpha = 1
    } else {
      unReadMessages.alpha = 0
    }
    
    if chat.participantCount <= 2 {
      print("case 1")
      circleProfileView.addSubview(avatar1)
      let url = URL(string: chat.bgUsers[0]["avatar"] as! String)!
      self.avatar1.then {
        $0.kf.setImage(with: url)
        
        $0.snp.makeConstraints({ (make) in
          make.top.equalToSuperview()
          make.leading.equalToSuperview()
        })
      }
    } else if chat.participantCount == 3 {
      print("case 2")
      circleProfileView.addSubview(avatar2A)
      circleProfileView.addSubview(avatar2B)
      let url1 = URL(string: chat.bgUsers[0]["avatar"] as! String)!
      let url2 = URL(string: chat.bgUsers[1]["avatar"] as! String)!
      
      self.avatar2A.then {
        $0.kf.setImage(with: url1)
        
        $0.snp.makeConstraints({ (make) in
          make.top.equalToSuperview().offset(0)
          make.leading.equalToSuperview().offset(0)
        })
      }
      
      self.avatar2B.then {
        $0.kf.setImage(with: url2)
        
        $0.snp.makeConstraints({ (make) in
          make.bottom.equalToSuperview().offset(0)
          make.trailing.equalToSuperview().offset(0)
        })
      }
    } else if chat.participantCount == 4 {
      print("case 3")
      circleProfileView.addSubview(avatar3A)
      circleProfileView.addSubview(avatar3B)
      circleProfileView.addSubview(avatar3C)
      let url1 = URL(string: chat.bgUsers[0]["avatar"] as! String)!
      let url2 = URL(string: chat.bgUsers[1]["avatar"] as! String)!
      let url3 = URL(string: chat.bgUsers[2]["avatar"] as! String)!
      
      self.avatar3A.then {
        $0.kf.setImage(with: url1)
        
        $0.snp.makeConstraints({ (make) in
          make.bottom.equalToSuperview().offset(0)
          make.leading.equalToSuperview().offset(0)
        })
      }
      
      self.avatar3B.then {
        $0.kf.setImage(with: url2)
        
        $0.snp.makeConstraints({ (make) in
          make.bottom.equalToSuperview().offset(0)
          make.trailing.equalToSuperview().offset(0)
        })
      }
      
      self.avatar3C.then {
        $0.kf.setImage(with: url3)
        
        $0.snp.makeConstraints({ (make) in
          make.top.equalToSuperview().offset(0)
          make.centerX.equalToSuperview().offset(0)
        })
      }
    } else if chat.participantCount > 4 {
      print("case 4")
      circleProfileView.addSubview(avatar4A)
      circleProfileView.addSubview(avatar4B)
      circleProfileView.addSubview(avatar4C)
      circleProfileView.addSubview(avatar4D)
      let url1 = URL(string: chat.bgUsers[0]["avatar"] as! String)!
      let url2 = URL(string: chat.bgUsers[1]["avatar"] as! String)!
      let url3 = URL(string: chat.bgUsers[2]["avatar"] as! String)!
      let url4 = URL(string: chat.bgUsers[3]["avatar"] as! String)!
      
      self.avatar4A.then {
        $0.kf.setImage(with: url1)
        
        $0.snp.makeConstraints({ (make) in
          make.top.equalToSuperview()
          make.leading.equalToSuperview()
        })
      }
      
      self.avatar4B.then {
        $0.kf.setImage(with: url2)
        
        $0.snp.makeConstraints({ (make) in
          make.top.equalToSuperview()
          make.trailing.equalToSuperview()
        })
      }
      
      self.avatar4C.then {
        $0.kf.setImage(with: url3)
        
        $0.snp.makeConstraints({ (make) in
          make.bottom.equalToSuperview()
          make.leading.equalToSuperview()
        })
      }
      
      self.avatar4D.then {
        $0.kf.setImage(with: url4)
        
        $0.snp.makeConstraints({ (make) in
          make.bottom.equalToSuperview()
          make.trailing.equalToSuperview()
        })
      }
    }
  }
}
