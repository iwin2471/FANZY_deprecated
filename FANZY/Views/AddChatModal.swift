//
//  AddChatView.swift
//  FANZY
//
//  Created by 김연준 on 12/06/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import UIKit
import Then
import MaterialComponents
import M13Checkbox
import ReusableKit
import ManualLayout
import Moya
import Toaster

class AddChatModal: BaseView {
  
  
  //Mark: UI
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  let container = UIView()
  let exitButton = UIButton()
  
  let makeRoomButton = MDCButton()
  let makeRoomButtonText = UILabel()
  var chatTitleInput = TextField(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 40))
  
  let networkProvider = MoyaProvider<VideoNetworkModel>()
  
  override func initialize() {
    super.initialize()
    addSubview(container)
    
    container.addSubview(titleLabel)
    titleLabel.addSubview(subtitleLabel)
    container.addSubview(exitButton)
    container.addSubview(makeRoomButton)
    container.addSubview(chatTitleInput)

    makeRoomButton.addSubview(makeRoomButtonText)
    
    setEvent()
  }
  
  override func customise() {
    self.backgroundColor = .clear
    self.frame = UIScreen.main.bounds
    

    titleLabel.then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.font = UIFont.systemFont(ofSize: 22, weight: .bold)
      $0.text = "채팅방 만들기"
      $0.textColor = .white
      $0.textAlignment = .left
    }
    
    subtitleLabel.then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.font = UIFont.systemFont(ofSize: 16)
      $0.text = "친구들과 함께 동영상을 보면서 현금처럼 쓸 수 있는 팬지를 받아보세요!"
      $0.numberOfLines = 3
      $0.textColor = .white
      $0.textAlignment = .left
      $0.alpha = 0.5
    }
    
    container.then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = UIColor.init(named: "modalColor")
      $0.layer.cornerRadius = 8
    }
    
    
    exitButton.then {
      $0.setImage(UIImage(named: "exit"), for: .normal)
    }
    
    makeRoomButton.then {
      $0.frame = CGRect(x: 0, y: 0, width: container.width-10, height: 50)
      $0.layer.cornerRadius = 5
      $0.backgroundColor = UIColor(named: "accentColor")
    }
    
    makeRoomButtonText.then {
      $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
      $0.textColor = .white
      $0.text = "만들기"
    }
    
    chatTitleInput.then {
      $0.backgroundColor = .init(rgb: 0x171717)
      $0.attributedPlaceholder = NSAttributedString(string: "채팅방 제목",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
      $0.textColor = .white
      $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
      $0.borderStyle = UITextField.BorderStyle.roundedRect
      $0.autocorrectionType = .no
      $0.keyboardType = .default
      $0.returnKeyType = .done
      $0.clearButtonMode = UITextField.ViewMode.whileEditing
      $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
      $0.layer.cornerRadius = 5;
      $0.layer.masksToBounds = true;
    }
    
  }
  
  func setEvent(){
    exitButton.rx.tap.subscribe(onNext: {
      self.animateOut()
    }).disposed(by: disposeBag)
    
    chatTitleInput.rx.text.orEmpty
      .scan("") { (previous, new) -> String in
        if new.count > 40 {
          return previous ?? String(new.prefix(40))
        } else {
          return new
        }
      }
      .bind(to: chatTitleInput.rx.text)
      .disposed(by: disposeBag)
  }
  
  override func setupConstraints() {
    container.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.4)
      make.width.equalToSuperview().multipliedBy(0.9)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(30)
      make.leading.equalToSuperview().offset(30)
      make.trailing.equalToSuperview().offset(-30)
    }
    
    subtitleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(15)
      make.leading.equalTo(titleLabel.snp.leading)
      make.trailing.equalTo(titleLabel.snp.trailing)
    }
    
    exitButton.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    chatTitleInput.snp.makeConstraints { (make) in
      make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
      make.leading.equalToSuperview().offset(30)
      make.trailing.equalToSuperview().offset(-30)
      make.height.equalTo(50)
    }
    
    makeRoomButton.snp.makeConstraints { (make) in
      make.height.equalTo(50)
      make.bottom.equalToSuperview().offset(-30)
      make.leading.equalToSuperview().offset(30)
      make.trailing.equalToSuperview().offset(-30)
    }
    
    makeRoomButtonText.snp.makeConstraints { (make) in
      make.centerX.centerY.equalToSuperview()
    }
  }
}


extension AddChatModal {
  
  func animateIn() {
    self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
    self.alpha = 1
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
      self.container.transform = .identity
      self.alpha = 1
    })
  }
  
  func animateOut() {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
      self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
      self.alpha = 0
    }) { (complete) in
      if complete {
        self.removeFromSuperview()
      }
    }
  }
}
