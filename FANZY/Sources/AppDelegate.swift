//
//  AppDelegate.swift
//  FANZY
//
//  Created by 김연준 on 14/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import UIKit

import Firebase
import GoogleSignIn
import RxOptional
import RxViewController
import SnapKit 
import Then

let preferences = UserDefaults.standard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    let layout = UICollectionViewFlowLayout()
    var viewController = UIViewController()
    
    window.backgroundColor = .white
    
    UINavigationBar.appearance().barTintColor = UIColor.init(rgb: 0x282828)
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    
    
    let statusBarBGView = UIView()
    statusBarBGView.backgroundColor = UINavigationBar.appearance().barTintColor
    
    FirebaseApp.configure()
    
    //    let serviceProvider = ServiceProvider()
    if Auth.auth().currentUser != nil {
      //      let reactor = ViewControllerReactor(provider: serviceProvider)
      //      let ListviewController = ViewController(reactor: reactor)
      viewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
    } else {
      viewController = UINavigationController(rootViewController: AuthController())
    }
    
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    window.addSubview(statusBarBGView)
    window.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBGView)
    window.addConstraintsWithFormat(format: "V:|[v0(20)]", views: statusBarBGView)
    
    socket.connect()
    
    self.window = window
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

