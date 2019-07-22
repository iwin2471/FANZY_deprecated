//
//  AuthController.swift
//  FANZY
//
//  Created by 김연준 on 14/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation


import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Firebase
import Alamofire
import Foundation
import GoogleSignIn

class AuthController: BaseViewController, GIDSignInUIDelegate, GIDSignInDelegate {
  let introduceFanzy = UITextView().then {
    $0.text = "동영상을 시청하면 크리에이터와 시청자 모두가 현금처럼 쓸 수 있는 팬지를 받을 수 있습니다.\n 좋아하는 크리에이터의 동영상을 친구들과 함께 보면서 추억을 공유해보세요!"
    $0.isEditable = false
  }
  let logoImage = UIImageView(image: UIImage(named: "logo")?.resized(newSize: CGSize(width: UIScreen.main.bounds.width, height: 120)))
  let loginBtn = GIDSignInButton()
  let preferences = UserDefaults.standard
  let koreaButton = UIButton()
  let englishButton = UIButton()
  let japanButton = UIButton()
  let disposebag = DisposeBag()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance()?.scopes = ["profile","email", "https://www.googleapis.com/auth/youtube"]
//    GIDSignIn.sharedInstance().signIn()
    
    
    view.addSubview(logoImage)
    view.addSubview(introduceFanzy)
    view.addSubview(loginBtn)
    view.addSubview(koreaButton)
    view.addSubview(englishButton)
    view.addSubview(japanButton)
    language()
  }
  
  override func customise() {
    let gradient = CAGradientLayer()
    
    gradient.frame = view.bounds
    gradient.colors = [UIColor(rgb: 0x212121).cgColor, UIColor(rgb: 0x212121).cgColor]
    
    introduceFanzy.backgroundColor = UIColor.clear
    introduceFanzy.textColor = UIColor.white
    view.layer.insertSublayer(gradient, at: -0)
    
    introduceFanzy.backgroundColor = UIColor.clear
    introduceFanzy.textColor = UIColor.white
    introduceFanzy.font =  introduceFanzy.font?.withSize(19)
    
   
    koreaButton.setTitle("한국어", for: .normal)
    englishButton.setTitle("english", for: .normal)
    japanButton.setTitle("日本語", for: .normal)
  }
  
  override func setupConstraints() {
    
    introduceFanzy.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.leading.equalToSuperview().offset(5)
      make.trailing.equalToSuperview().offset(-5)
      make.top.equalTo(logoImage.snp_bottom).offset(5)
      make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 120))
    }
    
    logoImage.snp.makeConstraints { (make) in
//      make.bottom.equalTo(introduceFanzy.snp_top)
      make.leading.equalToSuperview().offset(10)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    loginBtn.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(introduceFanzy.snp.bottom)
      make.centerX.equalTo(introduceFanzy.snp.centerX)
    }
    
    koreaButton.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: UIScreen.main.bounds.width/3, height: 30))
      make.leading.equalToSuperview()
      make.trailing.equalTo(englishButton.snp_leading)
      make.centerY.equalTo(englishButton.snp_centerY)
    }
    englishButton.snp.makeConstraints { (make) in
      make.size.equalTo(koreaButton)
      make.top.equalTo(loginBtn.snp_bottom).offset(30)
    }
    japanButton.snp.makeConstraints { (make) in
      make.size.equalTo(koreaButton)
      make.leading.equalTo(englishButton.snp_trailing)
      make.centerY.equalTo(englishButton.snp_centerY)
    }
  }
  
  
  func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    
    guard error == nil else {
      print("Error while trying to redirect : \(String(describing: error))")
      return
    }
    
    print("Successful Redirection")
  }
  
  //MARK: GIDSignIn Delegate
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
    if (error == nil) {
      // Perform any operations on signed in user here.
      let accessToken = user.authentication.accessToken
      self.showSpinner(onView: self.view)
      
      Alamofire.request("\(TestFanzyURL)/auth/google/token?access_token=\(accessToken!)").responseJSON { response in
        if let json = response.result.value as? [String: Any] {
          let avator = json["avatar"] as! String
          let email = json["email"] as! String
          let id = json["id"] as! Int
          let name = json["name"] as! String
          let hash = json["hash"] as! String
          
          
          self.preferences.set(avator, forKey: "avator")
          self.preferences.set(email, forKey: "email")
          self.preferences.set(name, forKey: "name")
          self.preferences.set(id, forKey: "id")
          self.preferences.set(hash, forKey: "hash")
          
          //  Save to disk
          let didSave = self.preferences.synchronize()
          if !didSave {
            //                Couldn't save (I've never seen this happen in real world testing)
          }
          
          let layout = UICollectionViewFlowLayout()
          
          guard let authentication = user.authentication else { return }
          let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                         accessToken: authentication.accessToken)
          
          
          Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
              return
            }
            let statusBarBGView = UIView()
            statusBarBGView.backgroundColor = UINavigationBar.appearance().barTintColor
            
            self.removeSpinner()
            self.present(UINavigationController(rootViewController: HomeController(collectionViewLayout: layout)), animated: true, completion: nil)
          }
        }
      }
    } else {
      print("ERROR ::\(error.localizedDescription)")
    }
  }
  
  // Finished disconnecting |user| from the app successfully if |error| is |nil|.
  public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
    
  }
  
  
  func language() {
    
    koreaButton.rx.tap.subscribe(onNext: {
      self.introduceFanzy.text = "동영상을 시청하면 크리에이터와 시청자 모두가 현금처럼 쓸 수 있는 팬지를 받을 수 있습니다.\n 좋아하는 크리에이터의 동영상을 친구들과 함께 보면서 추억을 공유해보세요!"
//      self.lang = "kr"
//      self.preferences.set(self.lang, forKey: "lang")
      
    }).disposed(by: disposebag)
    
    englishButton.rx.tap.subscribe(onNext: {
      self.introduceFanzy.text! = "When you watch a video, both the creator and viewers will receive a fanzy that you can use like cash. \n Share your favorite creator's videos with your friends and make your memories!"
//      self.lang = "en"
//      self.preferences.set(self.lang, forKey: "lang")
    }).disposed(by: disposebag)
    
    japanButton.rx.tap.subscribe(onNext: {
      self.introduceFanzy.text = "動画を見るとクリエイターと視聴者の両方が現金のように使えるファンジーをもらえます。\n 好きなクリエイターの動画を友達と一緒に見ながら思い出を共有しましょう！"
//      self.lang = "jp"
//      self.preferences.set(self.lang, forKey: "lang")
    }).disposed(by: disposebag)
  }
}
