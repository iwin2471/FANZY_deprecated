//
//  walletView.swift
//  FANZY
//
//  Created by 김연준 on 16/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ReactorKit
import ReusableKit
import RxCocoa
import RxDataSources
import RxSwift
import MaterialComponents


class WalletView: BaseCell, View {
  
  struct Reusable {
    static let chatCell = ReusableCell<ChatCell>()
  }
  
  let coinLabel = UILabel()
  let coinWrapper = UIView()
  let coinImageView = UIImageView()
  
  let walletTitle = UILabel()
  let trasferTitle = UILabel()
  
  let walletAddressInput = TextField(padding: UIEdgeInsets(top: 0, left: 58, bottom: 0, right: 15))
  let amountInput = TextField(padding: UIEdgeInsets(top: 0, left: 58, bottom: 0, right: 15))
  let billingPassword = TextField(padding: UIEdgeInsets(top: 0, left: 58, bottom: 0, right: 15))
  let sendButton = MDCButton()
  
  let transferButton = MDCButton()
  let revenueButton = MDCButton()
  let watchingRevenueButton = MDCButton()
  
  let defaultSize = CGSize(width: UIScreen.main.bounds.width - 50, height: 30)
  let buttonSize = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - 50)/3, height: 30)
  
  let tableView = UITableView()
  
  let tableViewDataSource = RxTableViewSectionedReloadDataSource<RevenueCellSelection>(
    configureCell: { _, tableView, indexPath, reactor in
      let cell = tableView.dequeue(Reusable.chatCell, for: indexPath)
      
      return cell
  })
  
  
  override func initialize() {
    addSubview(coinWrapper)
    addSubview(walletTitle)
    addSubview(walletAddressInput)
    addSubview(amountInput)
    addSubview(billingPassword)
    addSubview(trasferTitle)
    addSubview(sendButton)
    
    
    coinWrapper.addSubview(coinLabel)
    coinWrapper.addSubview(coinImageView)
    
    addSubview(transferButton)
    addSubview(revenueButton)
    addSubview(watchingRevenueButton)
    addSubview(tableView)
    
    setCoin()
    setup()
    super.initialize()
  }
  
  override func customise() {
    coinImageView.image = UIImage(named: "Coin")?.resized(newSize: CGSize(width: 24, height: 24))
    
    walletTitle.text = "나의 지갑"
    walletTitle.textColor = .white
    walletTitle.alpha = 0.8
    walletTitle.font = .systemFont(ofSize:14.0)
    
    trasferTitle.text = "이체하기"
    trasferTitle.textColor = .white
    trasferTitle.alpha = 0.8
    trasferTitle.font = .systemFont(ofSize:14.0)
    
    
    coinLabel.textColor = .white
    coinLabel.font = .systemFont(ofSize: 20.0, weight: .bold)
    
    coinWrapper.then {
      $0.backgroundColor = .init(rgb: 0x323232)
      $0.layer.cornerRadius = 5;
      $0.layer.masksToBounds = true;
    }
    
    walletAddressInput.then {
      $0.attributedPlaceholder = NSAttributedString(string: "받는 사람 지갑주소",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
      $0.textColor = .white
      $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
      $0.borderStyle = UITextField.BorderStyle.roundedRect
      $0.autocorrectionType = .no
      $0.keyboardType = .default
      $0.returnKeyType = .done
      $0.clearButtonMode = UITextField.ViewMode.whileEditing
      $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
      
      $0.backgroundColor = .init(rgb: 0x323232)
      let img = UIImageView(image: UIImage(named: "wallet")?.resized(newSize: CGSize(width: 24, height: 24)))
      
      $0.leftViewMode = .always
      $0.leftView = UIView()
      $0.leftView!.addSubview(img)
      
      img.snp.makeConstraints({ (make) in
        make.centerY.equalToSuperview()
        make.leading.equalToSuperview().offset(20)
      })
    }
    
    amountInput.then {
      $0.attributedPlaceholder = NSAttributedString(string: "금액",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
      $0.textColor = .white
      $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
      $0.borderStyle = UITextField.BorderStyle.roundedRect
      $0.autocorrectionType = .no
      $0.keyboardType = .numberPad
      $0.returnKeyType = .done
      $0.clearButtonMode = UITextField.ViewMode.whileEditing
      $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
      $0.backgroundColor = .init(rgb: 0x323232)
      let img = UIImageView(image: UIImage(named: "Coin")?.resized(newSize: CGSize(width: 24, height: 24)))
      
      $0.leftViewMode = .always
      $0.leftView = UIView()
      $0.leftView!.addSubview(img)
      
      img.snp.makeConstraints({ (make) in
        make.centerY.equalToSuperview()
        make.leading.equalToSuperview().offset(20)
      })
    }
    
    billingPassword.then {
      $0.attributedPlaceholder = NSAttributedString(string: "결제 비밀번호",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
      $0.textColor = .white
      $0.textContentType = .password
      $0.isSecureTextEntry = true
      
      $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
      $0.borderStyle = UITextField.BorderStyle.roundedRect
      $0.autocorrectionType = .no
      $0.keyboardType = .default
      $0.returnKeyType = .done
      $0.clearButtonMode = UITextField.ViewMode.whileEditing
      $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
      $0.backgroundColor = .init(rgb: 0x323232)
      let img = UIImageView(image: UIImage(named: "password")?.resized(newSize: CGSize(width: 26, height: 26)))
      
      $0.leftViewMode = .always
      $0.leftView = UIView()
      $0.leftView!.addSubview(img)
      
      img.snp.makeConstraints({ (make) in
        make.centerY.equalToSuperview()
        make.leading.equalToSuperview().offset(18)
      })
    }
    
    sendButton.then {
      $0.layer.cornerRadius = 5
      $0.backgroundColor = .init(rgb: 0xf9415f)
      $0.setTitleFont(UIFont.systemFont(ofSize: 16, weight: .bold), for: .normal)
      $0.setTitle("보내기", for: .normal)
      $0.titleLabel?.textColor = .white
    }
    
    transferButton.setTitle("이체내역", for: .normal)
    transferButton.titleLabel?.textColor = .white
    transferButton.frame = buttonSize
    transferButton.translatesAutoresizingMaskIntoConstraints = false
    
    
    revenueButton.setTitle("콘텐츠수익", for: .normal)
    revenueButton.titleLabel?.textColor = .white
    revenueButton.frame = buttonSize
    
    
    
    watchingRevenueButton.setTitle("시청수익", for: .normal)
    watchingRevenueButton.titleLabel?.textColor = .white
    watchingRevenueButton.frame = buttonSize
    
  }
  
  override func setupConstraints() {
   
  }
  
  func setup(){
    coinWrapper.snp.makeConstraints { (make) in
      make.top.equalTo(walletTitle.snp.bottom).offset(10)
      make.leading.equalToSuperview().inset(15)
      make.trailing.equalToSuperview().offset(-15)
      make.size.equalTo(CGSize(width: defaultSize.width, height: defaultSize.height+22))
    }
    
    coinImageView.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(20)
    }
    
    coinLabel.snp.makeConstraints { (make) in
      make.top.equalTo(coinImageView)
      make.trailing.equalTo(coinWrapper.snp.trailing).offset(-20)
    }
    
    walletTitle.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(20)
      make.leading.equalTo(coinWrapper.snp.leading)
    }
    
    trasferTitle.snp.makeConstraints { (make) in
      make.top.equalTo(coinWrapper.snp.bottom).offset(10)
      make.leading.equalTo(coinWrapper.snp.leading)
    }
    
    walletAddressInput.snp.makeConstraints { (make) in
      make.top.equalTo(trasferTitle.snp.bottom).offset(10)
      make.leading.trailing.equalTo(coinWrapper)
      make.size.equalTo(coinWrapper)
    }
    
    amountInput.snp.makeConstraints { (make) in
      make.top.equalTo(walletAddressInput.snp.bottom).offset(10)
      make.leading.trailing.equalTo(coinWrapper)
      make.size.equalTo(coinWrapper)
    }
    
    billingPassword.snp.makeConstraints { (make) in
      make.top.equalTo(amountInput.snp.bottom).offset(10)
      make.leading.trailing.equalTo(coinWrapper)
      make.size.equalTo(coinWrapper)
    }
    
    sendButton.snp.makeConstraints { (make) in
      make.top.equalTo(billingPassword.snp.bottom).offset(10)
      make.leading.trailing.equalTo(coinWrapper)
      make.size.equalTo(coinWrapper)
    }
    
    transferButton.snp.makeConstraints { (make) in
      make.top.equalTo(sendButton.snp.bottom).offset(10)
      make.leading.equalTo(sendButton)
      make.size.equalTo(CGSize(width: defaultSize.width/3, height: defaultSize.height+5))
    }
    
    revenueButton.snp.makeConstraints { (make) in
      make.top.equalTo(transferButton)
      make.leading.equalTo(transferButton.snp.trailing)
      make.size.equalTo(transferButton)
    }
    
    watchingRevenueButton.snp.makeConstraints { (make) in
      make.top.equalTo(transferButton)
      make.leading.equalTo(revenueButton.snp.trailing)
      make.size.equalTo(revenueButton)
    }
    
    tableView.snp.makeConstraints { (make) in
      make.leading.equalTo(transferButton)
      make.trailing.equalTo(watchingRevenueButton)
    }
  }
}

extension WalletView {
  
  func bind(reactor: WalletViewReactor) {
    tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
    
    sendButton.rx.tap
      .subscribe(onNext: {
        let address = self.walletAddressInput.text!
        let amount = self.amountInput.text!
        let password = self.billingPassword.text!
        
        let url = "test"
        
        let data = [
          "amount":amount,
          "receiver":address,
          "password":password,
        ]
        
        
        Alamofire.request(url, method: .post, parameters: data).responseString { (response) in
          let result = response.result.value
          
          
          if (result! == "done") {
            //FgetMyBalance('transfer');
          } else {
            //FshowAlertMessage(result);
          }
        }
    }).disposed(by: self.disposeBag)
    
    transferButton.rx.tap.asObservable().subscribe(onNext: {
      Observable.just(Reactor.Action.getTransfers)
        .bind(to: reactor.action)
        .disposed(by: self.disposeBag)
    }).disposed(by: disposeBag)
    
    revenueButton.rx.tap.subscribe(onNext: {
      Observable.just(Reactor.Action.getRevenues)
        .bind(to: reactor.action)
        .disposed(by: self.disposeBag)
    }).disposed(by: disposeBag)
    
    watchingRevenueButton.rx.tap.subscribe(onNext: {
      Observable.just(Reactor.Action.getWatchRevenues)
        .bind(to: reactor.action)
        .disposed(by: self.disposeBag)
    }).disposed(by: disposeBag)
    
    reactor.state
      .asObservable()
      .map {
        $0.revenue
      }
      .bind(to: self.tableView.rx.items(dataSource: self.tableViewDataSource))
      .disposed(by: self.disposeBag)
  }
  
  func setCoin(){
    let url = "\(email)"
    let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    Alamofire.request(encodedUrl!).responseJSON(completionHandler: { (response) in
      switch response.result {
      case .success:
        if let json = response.result.value as? [String: Any] {
          let token = json["balance"] as! NSNumber
          let fixedToken = String(format: "%.8f", token as! Double)
          self.coinLabel.text = fixedToken
        }
        break
      case .failure(let error):
        print(error)
      }
    })
    
  }
}


extension WalletView: UITableViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    NotificationCenter.default.post(name: NSNotification.Name("open"), object: nil)
  }
}
