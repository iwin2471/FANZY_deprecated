//
//  ShopPurchaseModal.swift
//  FANZY
//
//  Created by 김연준 on 16/06/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import MaterialComponents
import ReactorKit
import ManualLayout

class ShopPurchaseModal: BaseView, ReactorKit.View  {
  //Mark: UI
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  let container = UIView()
  let exitButton = UIButton()
  let phoneNumHintLabel = UILabel()
  
  let purchaseButton = MDCButton()
  let purchaseButtonText = UILabel()
  var phoneNum = PhoneFormattedTextField()
  let puchasePasswordField = TextField()
  
  
  override func initialize() {
    super.initialize()
    addSubview(container)
    
    container.addSubview(titleLabel)
    titleLabel.addSubview(subtitleLabel)
    container.addSubview(exitButton)
    container.addSubview(purchaseButton)
    container.addSubview(phoneNum)
    container.addSubview(phoneNumHintLabel)
    container.addSubview(puchasePasswordField)
    
    purchaseButton.addSubview(purchaseButtonText)
    
    setEvent()
  }
  
  override func customise() {
    self.backgroundColor = .clear
    self.frame = UIScreen.main.bounds
    let phoneNumFormat2 = PhoneFormat(phoneFormat: "###-###-####", regexp: #"/^\d{3}-\d{3,4}-\d{4}$/"#)
    let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 24))
    let leftImage = UIImageView(image: UIImage(named: "phonedata")?.resized(newSize: CGSize(width: 24, height: 24)))
    
    phoneNum.keyboardType = .numberPad
    phoneNum.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "###-####-####")
    phoneNum.prefix = nil
    phoneNum.config.add(format: phoneNumFormat2)
    phoneNum.leftView = leftView
    phoneNum.leftViewMode = .always
    leftView.addSubview(leftImage)
    leftImage.center = leftView.center

    
    
    titleLabel.then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.font = UIFont.systemFont(ofSize: 22, weight: .bold)
      $0.text = "구매하기"
      $0.textColor = .white
      $0.textAlignment = .left
    }
    
    subtitleLabel.then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.font = UIFont.systemFont(ofSize: 16)
      $0.text = "상품을 받으실 휴대폰 번호와 결제 비밀번호를 입력해주세요"
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
    
    purchaseButton.then {
      $0.frame = CGRect(x: 0, y: 0, width: container.width-10, height: 50)
      $0.layer.cornerRadius = 5
      $0.backgroundColor = UIColor(named: "accentColor")
    }
    
    purchaseButtonText.then {
      $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
      $0.textColor = .white
      $0.text = "만들기"
    }
    
    phoneNum.then {
      $0.backgroundColor = .init(rgb: 0x171717)
      $0.attributedPlaceholder = NSAttributedString(string: "핸드폰 번호",
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
    
    phoneNum.snp.makeConstraints { (make) in
      make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
      make.leading.equalToSuperview().offset(30)
      make.trailing.equalToSuperview().offset(-30)
      make.height.equalTo(50)
    }
    
    phoneNumHintLabel.snp.makeConstraints { (make) in
      make.top.equalTo(phoneNum.snp.bottom)
      make.leading.trailing.equalTo(phoneNum)
      make.height.equalTo(30)
    }
    
    purchaseButton.snp.makeConstraints { (make) in
      make.height.equalTo(50)
      make.bottom.equalToSuperview().offset(-30)
      make.leading.equalToSuperview().offset(30)
      make.trailing.equalToSuperview().offset(-30)
    }
    
    purchaseButtonText.snp.makeConstraints { (make) in
      make.centerX.centerY.equalToSuperview()
    }
  }
  
  func bind(reactor: ShopPurchaseReactor) {
    setEvent()
  }
}

extension ShopPurchaseModal {
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

extension ShopPurchaseModal {
  func setEvent() {
    exitButton.rx.tap.subscribe(onNext: {
      self.animateOut()
    }).disposed(by: disposeBag)
    
    purchaseButton.rx.tap.subscribe(onNext: {
      //      let goods = self.reactor!.currentState
    }).disposed(by: disposeBag)
    
    
    phoneNum.rx.text.orEmpty.subscribe(onNext: {
      let regex = #"^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"#
      let test = self.phoneNum.text!.range(of: regex)
      do {
        let regex = try! NSRegularExpression(pattern: #"^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"#)
        let range = NSRange($0.startIndex..., in: $0)
        let test = regex.matches(in: $0, range: range)
        print(test)
      }catch {
        print("asdf")
      }
      print($0, test, "test")
    }).disposed(by: disposeBag)
  }
}

