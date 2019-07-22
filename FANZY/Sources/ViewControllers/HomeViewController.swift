//
//  HomeViewController.swift
//  FANZY
//
//  Created by 김연준 on 14/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Alamofire
import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SnapKit
import ReactorKit
import ReusableKit
import MaterialComponents
import Then
import Firebase
import GoogleSignIn
import Toaster

var email: String = ""
var avator: String = ""
var id: Int = 1
var name: String = ""

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MDCBottomNavigationBarDelegate {
  let navTitles = ["홈", "채팅", "지갑", "스토어", "더보기"]
  
  enum Reusable {
    static let FeedCell = ReusableCell<FeedView>()
    static let chatCell = ReusableCell<ChatListView>()
    static let walletCell = ReusableCell<WalletView>()
    static let accountCell = ReusableCell<AccountView>()
    static let storeCell = ReusableCell<ShopView>()
  }
  
  var selectedIndex = 0
  var titleLabel = UILabel()
  let bottomNavBar = MDCBottomNavigationBar()
  let disposeBag = DisposeBag()
  let playerView = PlayerView()
  let titleImage = UIImageView(image: UIImage(named: "logo")?.resized(newSize: CGSize(width: 92.6, height: 27.2)).withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
  let searchView = SearchView()
  let addChatView = AddChatModal()
  
  let searchIcon = UIImage(named: "navSearch")?.resized(newSize: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysOriginal)
  let addChatIcon =  UIImage(named: "addchats")?.resized(newSize: CGSize(width: 24, height:24)).withRenderingMode(.alwaysOriginal)
  
  lazy var addChatButton = UIBarButtonItem(image: addChatIcon, style: .plain, target: self, action: nil)
  lazy var searchButton = UIBarButtonItem(image: searchIcon, style: .plain, target: self, action: nil)
  
  
  let serviceProvider = ServiceProvider()

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.view.addSubview(searchView)
    searchView.isHidden = true
    self.view.addSubview(addChatView)
    addChatView.isHidden = true
    
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
    }
    
    
    navigationItem.titleView = UILabel().then {
      $0.text = ""
    }
    
    navigationController?.navigationBar.addSubview(titleImage)
    titleImage.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(15)
    }
    
    setupMenuBar()
    setupNavBar()
    setupCollectionView()
    
    email = preferences.string(forKey: "email")!
    avator = preferences.string(forKey: "avator")!
    id = preferences.integer(forKey: "id")
    name = preferences.string(forKey: "name")!
    
    print("id: \(id)")
    
    playerView.translatesAutoresizingMaskIntoConstraints = true
    addPlayer()
  }
  
  func addPlayer(){
    guard let window = UIApplication.shared.keyWindow else { return }
    
    playerView.reactor = PlayerReactor(video: Video(JSON:
      [
        "title"   : "개발자일한다",
        "thumbnail" : "none",
        "url" : "nil",
        "org_video_id" : "NaN",
        "creator" : ["id" : 1, "name": "김연준"],
        "duration" : "30",
        "playtime" : "3:30",
        "view_count" : 0,
        "published_at" : "",
      ]
    ), playerState: .start)
    
    window.addSubview(playerView)
    
  }
  
  func setupCollectionView() {
    if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
      layout.minimumLineSpacing = 0
    }
    
    collectionView?.isPagingEnabled = true
    collectionView?.backgroundColor = .init(rgb: 0x212121)
    collectionView?.isScrollEnabled = false
    
    collectionView?.snp.removeConstraints()
    collectionView?.snp.makeConstraints({ (make) in
      make.width.equalTo(UIScreen.main.bounds.width)
      make.height.equalTo(UIScreen.main.bounds.height - navigationController!.navigationBar.height - bottomNavBar.frame.height + 20)
      make.top.equalTo(navigationController!.navigationBar.height - 20)
    })
    
    collectionView?.register(Reusable.FeedCell)
    collectionView?.register(Reusable.storeCell)
    collectionView?.register(Reusable.walletCell)
    collectionView?.register(Reusable.accountCell)
    collectionView?.register(Reusable.chatCell)
  }
  
  func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
    
  }
  
  private func setupNavBar() {
    navigationController?.navigationBar.backgroundColor = .init(rgb: 0x282828)
    
    addChatButton.rx.tap.subscribe(onNext: {
      self.addChatView.isHidden = false
      self.addChatView.animateIn()
    }).disposed(by: self.disposeBag)
  
    searchButton.rx.tap.subscribe(onNext: {
      self.searchView.alpha = 0
      self.searchView.isHidden = false
      
      UIView.animate(withDuration: 0.1, animations: {
        self.searchView.alpha = 1
      })
    }).disposed(by: disposeBag)
    
    let border = UIView()
    navigationController?.navigationBar.addSubview(border)
    border.backgroundColor = .init(rgb: 0x212121)
    border.snp.makeConstraints { (make) in
      make.width.equalTo(UIScreen.main.bounds.width)
      make.height.equalTo(1)
      make.bottom.equalToSuperview()
    }
    
    navigationItem.rightBarButtonItems = [searchButton]
  }
  
  
  func scrollToMenuAtIndex(index: Int) {
    let indexPath = IndexPath(item: index, section: 0)
    collectionView?.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition(), animated: true)
    setTitleForIndex(index: index)
  }
  
  private func setTitleForIndex(index: Int) {
    if case index = 0 {
      navigationItem.titleView = UILabel().then {
        $0.text = ""
      }
      
      self.titleImage.alpha = 1
    } else {
      self.titleImage.alpha = 0
      titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width-32, height: view.frame.size.height))
      titleLabel.text = "\(navTitles[index])"
      titleLabel.textColor = UIColor.white
      titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
      navigationItem.titleView = titleLabel
    }
  }
  
  
  @objc func handleMenu() {
    //    settingsMenu.openMenu()
  }
  
  
  private func setupMenuBar() {
    bottomNavBar.sizeThatFitsIncludesSafeArea = true
    layoutBottomNavBar()
    self.view.addSubview(bottomNavBar)
  }
  
  func layoutBottomNavBar() {
    let size = bottomNavBar.sizeThatFits(view.bounds.size)
    
    var bottomNavBarFrame = CGRect(x: 0,
                                   y: view.bounds.height - size.height,
                                   width: size.width,
                                   height: size.height)
    
    if #available(iOS 11.0, *) {
      bottomNavBarFrame.size.height += view.safeAreaInsets.bottom
      bottomNavBarFrame.origin.y -= view.safeAreaInsets.bottom
    }
    
    TabBarIteminit()
    bottomNavBar.delegate = self
    bottomNavBar.frame = bottomNavBarFrame
    bottomNavBar.selectedItem = bottomNavBar.items[0]
    let border = UIView()
    bottomNavBar.addSubview(border)
    border.backgroundColor = .init(rgb: 0x212121)
    border.snp.makeConstraints { (make) in
      make.width.equalTo(UIScreen.main.bounds.width)
      make.height.equalTo(1)
      make.top.equalToSuperview()
    }
  }
  
  func TabBarIteminit(){
    let homeImage = UIImage(named: "home")?.resized(newSize: CGSize(width: 20, height: 20)).withRenderingMode(UIImage.RenderingMode.alwaysOriginal).addImagePadding(x: 0, y: 10)
//    let chatImage = UIImage(named: "Chat")?.resized(newSize: CGSize(width: 20, height: 20)).withRenderingMode(UIImage.RenderingMode.alwaysTemplate).addImagePadding(x: 0, y: 10)
    let walletImage = UIImage(named: "wallet")?.resized(newSize: CGSize(width: 20, height: 20)).withRenderingMode(UIImage.RenderingMode.alwaysTemplate).addImagePadding(x: 0, y: 10)
    let storeImage = UIImage(named: "shop")?.resized(newSize: CGSize(width: 20, height: 20)).withRenderingMode(UIImage.RenderingMode.alwaysTemplate).addImagePadding(x: 0, y: 10)
    let moreImage = UIImage(named: "more")?.resized(newSize: CGSize(width: 20, height: 20)).withRenderingMode(UIImage.RenderingMode.alwaysTemplate).addImagePadding(x: 0, y: 10)
    
    let home = UITabBarItem(title: "홈", image: homeImage, tag: 0)
//    let chat = UITabBarItem(title: "채팅", image: chatImage, tag: 1)
    let FANZY = UITabBarItem(title: "지갑", image: walletImage, tag: 2)
    let store = UITabBarItem(title: "스토어", image: storeImage, tag: 3)
    let account = UITabBarItem(title: "더보기", image: moreImage, tag: 4)
    
    //bottom navber color Setting
    let colorScheme = MDCSemanticColorScheme()
    
    colorScheme.primaryColor = UIColor(rgb: 0x282828)
    
    colorScheme.primaryColorVariant = UIColor(rgb: 0x282828)
    
    colorScheme.secondaryColor = colorScheme.primaryColor
    
    MDCBottomNavigationBarColorThemer.applySemanticColorScheme(colorScheme, toBottomNavigation: bottomNavBar)
    
    bottomNavBar.titleVisibility = MDCBottomNavigationBarTitleVisibility.always
    bottomNavBar.tintColor = .white
//    chat
    bottomNavBar.items = [home, FANZY, store, account]
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.item {
    case 0:
     return defaultCell(collectionView: collectionView, indexPath: indexPath)
    case 1:
      let cell = collectionView.dequeue(Reusable.chatCell, for: indexPath)
      cell.reactor = ChatListViewReactor(provider: serviceProvider)
      cell.chatList.rx.itemSelected
        .map { indexPath in
          cell.dataSource[indexPath]
        }
        .subscribe(onNext: { data in
          let serviceProvider = ServiceProvider()
          let reactor = ChatViewReactor(provider: serviceProvider, roomId: "chat_"+data.currentState.roomId, chatMode: .small)
          let viewController = ChatRoomViewController(reactor: reactor)
          
          self.navigationController?.pushViewController(viewController, animated: false)
        })
        .disposed(by: disposeBag)
      
      addChatView.makeRoomButton.rx.tap.subscribe(onNext: {
        let title = self.addChatView.chatTitleInput.text!
        
        if title == "" {
          Toast(text: "채팅방 제목을 정확히 써주세요").show()
          return
        }
        
        self.addChatView.chatTitleInput.text = ""
        self.addChatView.isHidden = true
        cell.createRoom(title: title)
      }).disposed(by: disposeBag)
      
      return cell
    case 2:
      let cell = collectionView.dequeue(Reusable.walletCell, for: indexPath)
      cell.reactor = WalletViewReactor(provider: serviceProvider)
      return cell
    case 3:
      let cell = collectionView.dequeue(Reusable.storeCell, for: indexPath)
      cell.reactor = ShopViewReactor(provider: serviceProvider)
      cell.goodsItemList.rx.itemSelected
        .map { indexPath in
          cell.ShopSectionDataSource[indexPath]
        }.subscribe(onNext: {
          let reactor = $0.returnItemReactor()
          let viewController = PurchaseViewController(reactor: reactor)
          let navigationController = UINavigationController(rootViewController: viewController)
          self.present(navigationController, animated: true, completion: nil)
        }).disposed(by: disposeBag)
      
      return cell
    case 4:
      let cell = collectionView.dequeue(Reusable.accountCell, for: indexPath)
      cell.logOutButton.rx.tap.subscribe(onNext: {
        do {
          try Auth.auth().signOut()
          GIDSignIn.sharedInstance().signOut()
      
          self.navigationController?.popViewController(animated: false)
          let domain = Bundle.main.bundleIdentifier!
          preferences.removePersistentDomain(forName: domain)
          preferences.synchronize()
          
          self.dismiss(animated: true, completion: nil)
          self.present(UINavigationController(rootViewController: AuthController()), animated: true, completion: nil)
          
          
        } catch {
          
        }
      }).disposed(by: disposeBag)
      return cell
    default:
      return defaultCell(collectionView: collectionView, indexPath: indexPath)
    }
  }
  
  func defaultCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(Reusable.FeedCell, for: indexPath)
    cell.reactor = FeedViewReactor(provider: serviceProvider)
    cell.feed
      .rx
      .itemSelected
      .map { cell.reactor!.currentState.videos[0].items[$0.item] }
      .subscribe(onNext: {
        self.playerView.reactor = PlayerReactor(video: $0, playerState: .fullScreen)
      })
      .disposed(by: disposeBag)
    
    self.searchView.searchButton
      .rx
      .tap.subscribe(onNext: {
        cell.search(query: self.searchView.inputField.text!)
        self.searchView.hideSearchView()
      }).disposed(by: self.disposeBag)
    return cell
  }
  
  func showSearchButton(){
    navigationItem.rightBarButtonItem = nil
    navigationItem.rightBarButtonItem = searchButton
  }
  
  func showAddChatButton(){
    navigationItem.rightBarButtonItem = nil
    navigationItem.rightBarButtonItem = addChatButton
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.size.width, height: view.frame.size.height - bottomNavBar.frame.height - (navigationController?.navigationBar.frame.height)!)
  }
  
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //    menuBar.barLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
  }
  
  
  
  override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let index = targetContentOffset.pointee.x / view.frame.size.width
    let indexPath = IndexPath(item: Int(index), section: 0)
    
    
    setTitleForIndex(index: Int(index))
  }
  
  
  
  func bottomNavigationBar(_ bottomNavigationBar: MDCBottomNavigationBar, didSelect item: UITabBarItem) {
    if self.selectedIndex != item.tag {
      self.selectedIndex = item.tag
      self.scrollToMenuAtIndex(index: item.tag)
      
      switch item.tag {
      case 0: showSearchButton()
      case 1: showAddChatButton()
      default: navigationItem.rightBarButtonItem = nil
      }
    }
  }
}
