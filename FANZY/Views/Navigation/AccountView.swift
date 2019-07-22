//
//  accountView.swift
//  FANZY
//
//  Created by 김연준 on 16/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import WebKit
import FirebaseAuth

class AccountView: BaseCell {
  let profileImageView = UIImageView()
  let profileView = UIView()
  let divider = UIView()
  let nameView = UILabel()
  let emailView = UILabel()

  let logOutButton = UIButton()
  let privacyPolicyButton = UIButton()
  let termsAndConditionsButton = UIButton()
  let opinionButton = UIButton()
  let deleteAccountButton = UIButton()
  
  let disposebag = DisposeBag()
  let web = WKWebView()
  
  override func initialize() {
    addSubview(profileView)
    
    profileView.addSubview(profileImageView)
    profileView.addSubview(emailView)
    profileView.addSubview(nameView)
    profileView.addSubview(divider)
    
    addSubview(logOutButton)
    addSubview(opinionButton)
    addSubview(termsAndConditionsButton)
    addSubview(privacyPolicyButton)
    addSubview(deleteAccountButton)
    addSubview(web)
    
    event()
    super.initialize()
  }
  
  override func customise() {
    let avatorUrl = URL(string: avator)!
    
    profileView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70)
    
    profileImageView.then {
      $0.kf.setImage(with: avatorUrl)
      $0.frame.size = CGSize(width: 50, height: 50)
      $0.contentMode = .scaleAspectFill
      $0.layer.cornerRadius = profileImageView.frame.size.height / 2
      $0.layer.masksToBounds = false
      $0.clipsToBounds = true
    }
    
    nameView.then {
      $0.text = name
      $0.textColor = .white
      $0.font = .systemFont(ofSize: 18.0, weight: .bold)
    }
    
    emailView.then {
      $0.text = email
      $0.textColor = .white
      $0.alpha = 0.6
      $0.font = .systemFont(ofSize: 16.0)
    }
    
    divider.then {
      $0.backgroundColor = .white
      $0.alpha = 0.1
    }
    
    logOutButton.then {
      let img = UIImageView(image: UIImage(named: "logout")?.resized(newSize: CGSize(width: 22, height: 22)))
      let txt = UILabel()
      
      $0.addSubview(img)
      $0.addSubview(txt)
      
      txt.then {
        $0.text = "로그아웃"
        $0.textColor = .white
        $0.snp.makeConstraints({ (make) in
          make.centerY.equalToSuperview()
          make.leading.equalTo(img.snp_trailing).offset(20)
        })
      }
      
      img.snp.makeConstraints({ (make) in
        make.centerY.equalToSuperview()
        make.leading.equalToSuperview().offset(20)
      })
    }
    
    privacyPolicyButton.then {
      let img = UIImageView(image: UIImage(named: "privacy")?.resized(newSize: CGSize(width: 22, height: 22)))
      let txt = UILabel()
      
      $0.addSubview(img)
      $0.addSubview(txt)
      
      txt.then {
        $0.text = "개인정보 보호정책"
        $0.textColor = .white
        $0.snp.makeConstraints({ (make) in
          make.centerY.equalToSuperview()
          make.leading.equalTo(img.snp_trailing).offset(18)
        })
      }
      
      img.snp.makeConstraints({ (make) in
        make.centerY.equalToSuperview()
        make.leading.equalToSuperview().offset(20)
      })
    }
    
    termsAndConditionsButton.then {
      let img = UIImageView(image: UIImage(named: "terms")?.resized(newSize: CGSize(width: 20, height: 20)))
      let txt = UILabel()
      
      $0.addSubview(img)
      $0.addSubview(txt)
      
      txt.then {
        $0.text = "이용약관"
        $0.textColor = .white
        $0.snp.makeConstraints({ (make) in
          make.centerY.equalToSuperview()
          make.leading.equalTo(img.snp_trailing).offset(20)
        })
      }
      
      img.snp.makeConstraints({ (make) in
        make.centerY.equalToSuperview()
        make.leading.equalToSuperview().offset(20)
      })
    }
    
    opinionButton.then {
      let img = UIImageView(image: UIImage(named: "feedback")?.resized(newSize: CGSize(width: 20, height: 20)))
      let txt = UILabel()
      
      $0.addSubview(img)
      $0.addSubview(txt)
      
      txt.then {
        $0.text = "의견보내기"
        $0.textColor = .white
        $0.snp.makeConstraints({ (make) in
          make.centerY.equalToSuperview()
          make.leading.equalTo(img.snp_trailing).offset(20)
        })
      }
      
      img.snp.makeConstraints({ (make) in
        make.centerY.equalToSuperview()
        make.leading.equalToSuperview().offset(20)
      })
    }
    
    deleteAccountButton.then {
      let img = UIImageView(image: UIImage(named: "delete_account")?.resized(newSize: CGSize(width: 20, height: 20)))
      let txt = UILabel()
      
      $0.addSubview(img)
      $0.addSubview(txt)
      
      txt.then {
        $0.text = "회원탈퇴"
        $0.textColor = .white
        $0.snp.makeConstraints({ (make) in
          make.centerY.equalToSuperview()
          make.leading.equalTo(img.snp_trailing).offset(20)
        })
      }
      
      img.snp.makeConstraints({ (make) in
        make.centerY.equalToSuperview()
        make.leading.equalToSuperview().offset(20)
      })
    }
  }
  
  override func setupConstraints() {
    profileView.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(80)
    }
    
    profileImageView.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.size.equalTo(CGSize(width: 50, height: 50))
      make.leading.equalTo(profileView).offset(20)
    }
    
    nameView.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview().offset(-10)
      make.leading.equalTo(profileImageView.snp.trailing).offset(20)
    }
    
    emailView.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview().offset(10)
      make.leading.equalTo(profileImageView.snp.trailing).offset(20)
    }
    
    divider.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 1))
      make.bottom.equalToSuperview()
    }
    
    logOutButton.snp.makeConstraints { (make) in
      make.top.equalTo(divider.snp.bottom).offset(10)
      make.leading.trailing.equalToSuperview()
      make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 60))
    }
    
    privacyPolicyButton.snp.makeConstraints { (make) in
      make.top.equalTo(logOutButton.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 60))
    }
    
    termsAndConditionsButton.snp.makeConstraints { (make) in
      make.top.equalTo(privacyPolicyButton.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.size.equalTo(privacyPolicyButton)
    }
    
    opinionButton.snp.makeConstraints { (make) in
      make.top.equalTo(termsAndConditionsButton.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.size.equalTo(privacyPolicyButton)
    }
    
    deleteAccountButton.snp.makeConstraints { (make) in
      make.top.equalTo(opinionButton.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.size.equalTo(privacyPolicyButton)
    }
  }
  
  @objc func webViewDispose() {
    web.isHidden = true
  }
}

extension AccountView {
  func event(){
    self.web.configuration.userContentController.add(self, name: "test")
    
    privacyPolicyButton.rx.tap.subscribe(onNext: {
      let webUrl = URL(string: "")
      self.web.load(URLRequest(url: webUrl!))
      self.web.isHidden = false
      self.web.snp.makeConstraints({ (make) in
        make.top.leading.trailing.bottom.equalToSuperview()
      })
      self.load()
    }).disposed(by: disposebag)
    
    termsAndConditionsButton.rx.tap.subscribe(onNext: {
      let webUrl = URL(string: "")
      self.web.load(URLRequest(url: webUrl!))
      self.web.isHidden = false
      self.web.snp.makeConstraints({ (make) in
        make.top.leading.trailing.bottom.equalToSuperview()
      })
      
      self.load()
    }).disposed(by: disposebag)
    
    opinionButton.rx.tap.subscribe(onNext: {
      let webUrl = URL(string: "")
      self.web.load(URLRequest(url: webUrl!))
      self.web.isHidden = false
      self.web.snp.makeConstraints({ (make) in
        make.top.leading.trailing.bottom.equalToSuperview()
      })
      
      self.load()
      let close = UIButton()
      close.setImage(UIImage(named: "exit"), for: .normal)
      close.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
      
      self.web.addSubview(close)
      
      close.snp.makeConstraints({ (make) in
        make.top.equalToSuperview().offset(15)
        make.trailing.equalToSuperview().offset(-5)
      })
      
      close.rx.tap.subscribe(onNext:{
        self.webViewDispose()
        
      }).disposed(by: self.disposeBag)
    }).disposed(by: disposebag)
  }
}

extension AccountView: WKScriptMessageHandler {
  func load() {
    var scriptSource = ""
    
    if (web.url?.absoluteString.contains("google"))! == true {
      print("google")
    }
    
    scriptSource = "$('.i-red').click(function(){window.webkit.messageHandlers.test.postMessage('asdf')});"
    
    let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    let config = WKWebViewConfiguration()
    
    let contentController = WKUserContentController()
    contentController.add(self, name: "test")
    contentController.addUserScript(script)
    config.userContentController = contentController
    
    web.configuration.userContentController = contentController
    web.configuration.userContentController.addUserScript(script)
  }
  
  func loadUrl(url: String){
    let webUrl = URL(string: url)
    web.load(URLRequest(url: webUrl!))
  }
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    webViewDispose()
  }
}
