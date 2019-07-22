//
//  File.swift
//  FANZY
//
//  Created by 김연준 on 16/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Alamofire
import EFCountingLabel
import Foundation
import UIKit
import MaterialComponents
import YoutubeKit
import SnapKit
import Kingfisher
import ReactorKit
import ReusableKit
import RxAlamofire
import RxCocoa
import RxDataSources
import RxGesture
import RxSwift


final class PlayerView: BaseView, ReactorKit.View {
  var player = UIView()
  
  var videoTitle = UILabel()
  var videoDesc = UILabel()
  var viewCount = UILabel()
  var channelTitle = UILabel()
  var channelPic = UIImageView()
  var channelSubscribers = UILabel()
  var coinLabel = EFCountingLabel()
  let subscribeButton = MDCButton()
  let subscribeImg = UIImageView(image: UIImage(named: "youtube"))
  let subscribeAlreadyImg = UIImageView(image: UIImage(named: "youtube_gray"))
  let subscribeLabel = UILabel()
  
  let pv: UIProgressView = UIProgressView(frame: CGRect(x:0, y:0, width:200, height:10))
  
  var coinImage = UIImageView(image: UIImage(named: "Coin"))
  var chatBtnImg = UIImageView(image: UIImage(named: "Chat")?.resized(newSize: CGSize(width: 25, height: 25)))
  var chatBtnLabel = UILabel()
  var reportBtnImg = UIImageView(image: UIImage(named: "danger")?.resized(newSize: CGSize(width: 25, height: 25)))
  var reportBtnLabel = UILabel()
  var addToChatBtnImg = UIImageView(image: UIImage(named: "add_to_chat")?.resized(newSize: CGSize(width: 25, height: 25)))
  var addToChatBtnLabel = UILabel()
  
  
  let chat = ChatView()
  let report = ReportView()
  let channelWrapper = UIView()
  let channelWrapperTopBar = UIView()
  let channelWrapperBottomBar = UIView()
  
  var summary = UIView().then {
    $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300)
  }
  
  var chatButton = MDCButton()
  var reportButton = MDCButton()
  var addToChatButton = MDCButton()
  
  struct Reusable {
    static let videoCell = ReusableCell<RelateVideoCell>()
  }
  
  let relateVideoList = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-120)).then {
    $0.backgroundColor = .init(rgb: 0x212121)
    $0.register(Reusable.videoCell)
  }
  
  let dataSource = RxTableViewSectionedReloadDataSource<RelateVideoSection>(
    configureCell: { _, tableView, indexPath, reactor in
      
      let cell = tableView.dequeue(Reusable.videoCell, for: indexPath)
      cell.reactor = reactor
      return cell
  })
  
  let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
  
  var YTPlayer = YTSwiftyPlayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 9 / 16), playerVars: [.playsInline(true), .videoID("test"), .showRelatedVideo(false)])
  
  var coinCounterTimer = Timer()
  var rewardCount = 0
  var duration = 0
  
  let hiddenOrigin: CGPoint  = {
    let x = -UIScreen.main.bounds.width
    let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
    let coordinate = CGPoint.init(x: x, y: y)
    return coordinate
  }()
  
  let x2 = UIScreen.main.bounds.width/2 - 10
  let y2 = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 68
  let fullScreenOrigin = CGPoint.init(x: 0, y: 0)
  
  override func initialize() {
    
    backgroundColor = .white
    frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    playerViewCustom()
    
    
    addSubview(player)
    addSubview(summary)
    
    
    addSubview(relateVideoList)
    addSubview(channelWrapper)
    
    summary.addSubview(pv)
    summary.addSubview(coinLabel)
    summary.addSubview(coinImage)
    
    summary.addSubview(videoTitle)
    summary.addSubview(viewCount)
    summary.addSubview(videoDesc)
    
    summary.addSubview(chatButton)
    summary.addSubview(reportButton)
    summary.addSubview(addToChatButton)
    
    chatButton.addSubview(chatBtnImg)
    chatButton.addSubview(chatBtnLabel)
    
    addToChatButton.addSubview(addToChatBtnImg)
    addToChatButton.addSubview(addToChatBtnLabel)
    
    reportButton.addSubview(reportBtnImg)
    reportButton.addSubview(reportBtnLabel)
    
    addToChatButton.addSubview(addToChatBtnImg)
    addToChatButton.addSubview(addToChatBtnLabel)
    
    channelWrapper.addSubview(channelTitle)
    channelWrapper.addSubview(channelPic)
    channelWrapper.addSubview(channelSubscribers)
    channelWrapper.addSubview(channelWrapperTopBar)
    channelWrapper.addSubview(channelWrapperBottomBar)
    channelWrapper.addSubview(subscribeButton)
    
    subscribeButton.addSubview(subscribeImg)
    subscribeButton.addSubview(subscribeLabel)
    
    player.addSubview(YTPlayer)
    
    setupLayout()
    super.initialize()
    //    self.view.frame = CGRect.init(origin: self.hiddenOrigin, size: UIScreen.main.bounds.size)
  }
  
  
  override func customise() {
    let height = self.frame.width * 9 / 16
    let videoPlayerFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: player.frame.height)
    
    self.YTPlayer.delegate = self
    self.YTPlayer.loadPlayer()
    
    self.backgroundColor = .init(rgb: 0x212121)
    //    self.translatesAutoresizingMaskIntoConstraints = true
    //    self.isUserInteractionEnabled = true
    
    self.videoTitle.numberOfLines = 2
    self.videoTitle.textColor = .white
    self.videoTitle.font = UIFont.systemFont(ofSize: 18)
    
    self.viewCount.textColor = .white
    self.viewCount.alpha = 0.7
    self.viewCount.font = UIFont.systemFont(ofSize: 14)
    
    self.relateVideoList.separatorStyle = .none
    
    self.coinLabel.textColor = .white
    self.coinImage.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    
    self.viewCount.font = UIFont.systemFont(ofSize: 14)
    
    self.chatButton.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width/4, height: 80)
    self.chatButton.backgroundColor = .init(rgb: 0x212121)
    self.chatBtnImg.alpha = 0.7
    self.chatBtnLabel.text = "실시간 채팅"
    self.chatBtnLabel.font = UIFont.systemFont(ofSize: 14)
    self.chatBtnLabel.textColor = .white
    self.chatBtnLabel.alpha = 0.7
    
    self.addToChatButton.frame = self.chatButton.frame
    self.addToChatButton.backgroundColor = .init(rgb: 0x212121)
    self.addToChatBtnImg.alpha = 0.7
    self.addToChatBtnLabel.text = "채팅방에 추가"
    self.addToChatBtnLabel.font = UIFont.systemFont(ofSize: 14)
    self.addToChatBtnLabel.textColor = .white
    self.addToChatBtnLabel.alpha = 0.7
    
    self.reportButton.frame = self.chatButton.frame
    self.reportButton.backgroundColor = .init(rgb: 0x212121)
    self.reportBtnImg.alpha = 0.7
    self.reportBtnLabel.text = "신고"
    self.reportBtnLabel.font = UIFont.systemFont(ofSize: 14)
    self.reportBtnLabel.textColor = .white
    self.reportBtnLabel.alpha = 0.7
    
    self.channelWrapperTopBar.backgroundColor = .white
    self.channelWrapperTopBar.alpha = 0.1
    self.channelWrapperBottomBar.backgroundColor = .white
    self.channelWrapperBottomBar.alpha = 0.1
    
    self.channelTitle.textColor = .white
    self.channelTitle.font = UIFont.systemFont(ofSize: 18)
    self.channelSubscribers.textColor = .white
    self.channelSubscribers.font = UIFont.systemFont(ofSize: 15)
    self.channelSubscribers.alpha = 0.7
    self.channelPic.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    
    self.subscribeButton.backgroundColor = .init(rgb: 0x212121)
    self.subscribeLabel.text = "구독"
    self.subscribeLabel.font = UIFont.systemFont(ofSize: 18)
    self.subscribeLabel.textColor = .red
    
    self.coinLabel.format = "%.8f"
    
    clearCoinLabel()
    setupPv()
    
    rewardSocket()
    playerViewCustom()
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let subview = super.hitTest(point, with: event)
    let touchEvent = subview !== self ? subview : nil
    
    if let state = self.reactor?.currentState.playerState {
      switch state {
      case .minimized:
        return touchEvent
      case .fullScreen, .hidden, .start, .chatRoom:
        break
      }
    }
    
    return subview
  }
  
  
  func bind(reactor: PlayerReactor) {
    rewardCount = 0
    if self.chat.didSetupConstraints {
      self.chat.removeAllCell()
      self.chat.removeFromSuperview()
    }
    
    self.relateVideoList.rx.setDelegate(self).disposed(by: self.disposeBag)
    
    Observable.just(Reactor.Action.relate(videoID: reactor.currentState.video!.org_video_id))
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    if let video = reactor.currentState.video {
      setVideo(video: video)
    }
    
    self.relateVideoList.rx.itemSelected
      .map { [weak self] indexPath in
        return self?.dataSource[indexPath]
      }
      .subscribe(onNext: {
        guard let item = $0 else { return }
        
        self.reactor = PlayerReactor(video: item.currentState, playerState: .fullScreen)
      })
      .disposed(by: disposeBag)
    
    
    if self.reactor!.currentState.playerState != .chatRoom {
      self.player.rx.panGesture()
        .when(.began, .ended)
        .map {
          self.chat.messageInputBar.textView.endEditing(true)
          return Reactor.Action.doGesture($0)
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
    
    self.chatButton.rx.tap.subscribe(onNext: {
      self.addSubview(self.chat)
      let provider = ServiceProvider()
      self.chat.reactor = ChatViewReactor(provider: provider, roomId: "video_"+self.reactor!.currentState.video!.org_video_id)
      self.chat.animateIn()
    }).disposed(by: disposeBag)
    
    self.reportButton.rx
      .tap.subscribe(onNext: {
        self.addSubview(self.report)
        self.report.animateIn()
      }).disposed(by: disposeBag)
    
    self.relateVideoList.nextPage
      .distinctUntilChanged()
      .subscribe(onNext: {
        if $0 {
          Observable.just(Reactor.Action.loadMore).bind(to: reactor.action).dispose()
        }
      }).disposed(by: disposeBag)
    
    reactor.state.map { $0.video! }
      .distinctUntilChanged()
      .map {
        self.chat.removeAllCell()
        return $0.org_video_id
      }
      .bind(to: YTPlayer.rx.origin)
      .disposed(by: disposeBag)
    
    reactor.state
      .asObservable()
      .map {
        $0.playerState
      }
      .bind(to: self.rx.PlayerAnimation)
      .disposed(by: disposeBag)
    
    reactor.state
      .asObservable()
      .map {
        $0.relateVideo
      }
      .bind(to: relateVideoList.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }
  
  func setVideo(video: Video){
    videoTitle.text = video.title
    viewCount.text = "조회수 \(video.viewCount)회"
    let title = video.creator["name"] as! String
    
    if title.count > 16 {
      channelTitle.text = "\(title.prefix(16))..."
    } else {
      channelTitle.text = title
    }
    
    channelSubscribers.text = "0 POT"
    clearCoinLabel()
    pv.setProgress(0.0, animated: true)
    
    var playtime = video.playtime as! String
    var playtimeArr = playtime.components(separatedBy: ":")
    
    switch playtimeArr.count {
    case 3:
      let hrs: String = playtimeArr[0]
      let mins: String = playtimeArr[1]
      let secs: String = playtimeArr[2]
      
      duration = 3600*Int(hrs)! + 60*Int(mins)! + Int(secs)!
      break
    case 2:
      let mins: String = playtimeArr[0]
      let secs: String = playtimeArr[1]
      
      duration = 60*Int(mins)! + Int(secs)!
      break
    default:
      let secs = playtime
      
      duration = Int(secs)!
    }
    
    Alamofire.request("/\(video.creator["id"]!)").responseJSON { response in
      if let json = response.result.value as? [String: Any] {
        let channelPicUrl = URL(string: json["profile_img"] as! String)!
        
        let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 40, height: 40))
          >> RoundCornerImageProcessor(cornerRadius: 20)
        
        self.channelPic.kf.setImage(with: channelPicUrl, placeholder: nil, options: [.processor(resizingProcessor)])
        
        let tmpPot = json["pot"] as! NSNumber
        
        if tmpPot != 0 {
          let pot = tmpPot.floatValue
          self.channelSubscribers.text = "\(pot) POT"
        }
        
        self.channelPic.contentMode = .scaleAspectFill
        self.channelPic.clipsToBounds = true
        
        self.channelPic.layer.then {
          $0.borderWidth = 1
          $0.masksToBounds = true
          $0.borderColor = UIColor.black.cgColor
          $0.cornerRadius = self.channelPic.frame.width/2
        }
      }
    }
    
    //    socketBind()
    
    //    channelPic.clipsToBounds = true
  }
  
  func getVideoView(originID: String){
    socket.emit("join:room", ["video_\(originID)", avator, id, originID, "false", "false"])
    let url = "\(originID)&id=\(id)"
    let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    
    
    //    RxAlamofire
    //      .requestJSON(.get, encodedUrl!)
    //      .debug().reponse
    //      .responseString { (response) in
    //        switch response.result {
    //        case .success(let data):
    //          print(data)
    //          self.YTPlayer.autoplay = true
    //          break
    //        case .failure:
    //          print("response code: \(response.response?.statusCode)")
    //          break
    //
    //        }
    //    }
  }
  
  @objc func cuntCoin(){
    rewardCount += 1
    print("rewardCount: \(rewardCount)")
    let gotToken = Double(-0.086 + 0.048 * log(Double(rewardCount) + 1.0) <= 0 ? 0.0 : (-0.086 + 0.048 * log(Double(rewardCount + 1))) / 20);
    
    if (rewardCount >= duration) {
      coinLabel.text = String(format: "%.8f", gotToken as! Double)
      coinCounterTimer.invalidate()
    } else {
      let startValue = Double(coinLabel.text!)
      let percentage = CGFloat(rewardCount) / CGFloat(duration)
      
      pv.progress = Float(Float(String(format: "%.2f", percentage))!)
      
      coinLabel.format = "%.8f"
      coinLabel.countFrom(CGFloat(startValue!), to: CGFloat(gotToken), withDuration: 1.0)
    }
  }
  
  func clearCoinLabel(){
    self.coinLabel.countFrom(CGFloat(0.00000000), to: CGFloat(0.00000000), withDuration: 0.1)
  }
  
  
  func changeValues(scaleFactor: CGFloat) {
    self.relateVideoList.alpha = 1 - scaleFactor
    let scale = CGAffineTransform.init(scaleX: (1 - 0.5 * scaleFactor), y: (1 - 0.5 * scaleFactor))
    let trasform = scale.concatenating(CGAffineTransform.init(translationX: -(self.player.bounds.width / 4 * scaleFactor), y: -(self.player.bounds.height / 4 * scaleFactor)))
    self.player.transform = trasform
  }
  
  
  deinit {
    NotificationCenter.default.removeObserver(self)
    coinCounterTimer.invalidate()
  }
}


extension PlayerView {
  
  func setupLayout(){
    setupSummary()
    setupCoinBar()
    setupRelateList()
    setupChannelWrapper()
    
    videoTitle.snp.makeConstraints { make in
      make.top.equalTo(coinImage.snp.bottom).offset(10)
      make.leading.equalToSuperview().offset(15)
      make.trailingMargin.equalToSuperview().offset(-40)
    }
    
    viewCount.snp.makeConstraints { make in
      make.top.equalTo(videoTitle.snp.bottom).offset(10)
      make.leading.equalTo(videoTitle.snp.leading)
    }
    
    chatButton.snp.makeConstraints { (make) in
      make.top.equalTo(viewCount.snp.bottom).offset(15)
      make.leading.equalToSuperview()
      make.size.equalTo(CGSize(width:UIScreen.main.bounds.width/4, height: 60))
    }
    
    chatBtnImg.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    
    chatBtnLabel.snp.makeConstraints { (make) in
      make.top.equalTo(chatBtnImg.snp_bottom).offset(5)
      make.centerX.equalToSuperview()
    }
    
    addToChatButton.snp.makeConstraints { (make) in
      make.top.equalTo(chatButton.snp.top)
      make.leading.equalTo(chatButton.snp.trailing)
      make.size.equalTo(chatButton)
    }
    
    addToChatBtnImg.snp.makeConstraints { (make) in
      make.top.equalTo(chatButton.snp.top)
      make.centerX.equalToSuperview()
    }
    
    addToChatBtnLabel.snp.makeConstraints { (make) in
      make.top.equalTo(chatBtnImg.snp.bottom).offset(5)
      make.centerX.equalToSuperview()
    }
    
    reportButton.snp.makeConstraints { (make) in
      make.top.equalTo(chatButton.snp_top)
      make.leading.equalTo(addToChatButton.snp.trailing)
      make.size.equalTo(chatButton)
    }
    
    reportBtnImg.snp.makeConstraints { (make) in
      make.top.equalTo(chatButton.snp_top)
      make.centerX.equalToSuperview()
    }
    
    reportBtnLabel.snp.makeConstraints { (make) in
      make.top.equalTo(chatBtnImg.snp_bottom).offset(5)
      make.centerX.equalToSuperview()
    }
    
  }
  
}


extension PlayerView {
  func setupPv(){
    pv.progressTintColor = UIColor.white
    pv.trackTintColor = .init(rgb: 0x101010)
    pv.layer.cornerRadius = pv.frame.size.height / 2
    pv.layer.masksToBounds = true;
    pv.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
  }
  
  func setupSummary() {
    summary.snp.makeConstraints { make in
      make.top.equalTo(player.snp.bottom)
      make.trailing.equalTo(player.snp.trailing)
      make.leading.equalTo(player.snp.leading)
      make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: player.frame.height/1.45 + videoTitle.height + chatButton.frame.height))
    }
  }
  
  func setupCoinBar(){
    pv.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(14)
      make.leading.equalToSuperview().offset(15)
      make.trailing.equalToSuperview().offset(-(coinLabel.width + coinImage.width + 20))
      make.height.equalTo(3)
    }
    
    coinImage.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(8)
      make.trailing.equalTo(pv.snp.trailing).offset(20)
      make.size.equalTo(CGSize(width: 14, height: 14))
    }
    
    coinLabel.snp.makeConstraints { make in
      make.centerY.equalTo(coinImage.snp.centerY)
      make.top.equalTo(coinImage.snp.top)
      make.trailing.equalToSuperview().offset(-15)
    }
  }
  
  func setupRelateList(){
    relateVideoList.snp.makeConstraints { (make) in
      make.top.equalTo(channelWrapper.snp.bottom)
      make.leading.equalTo(summary.snp.leading)
      make.trailing.equalTo(summary.snp.trailing)
      make.bottom.equalToSuperview()
    }
  }
  
  func setupChannelWrapper() {
    channelWrapper.snp.makeConstraints { (make) in
      make.top.equalTo(chatButton.snp.bottom).offset(5)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 70))
    }
    
    channelWrapperTopBar.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.width.equalTo(UIScreen.main.bounds.width)
      make.height.equalTo(1)
    }
    
    channelWrapperBottomBar.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.width.equalTo(UIScreen.main.bounds.width)
      make.height.equalTo(1)
    }
    
    channelPic.snp.makeConstraints { make in
      make.leading.equalTo(videoTitle.snp.leading)
      make.width.equalTo(50)
      make.height.equalTo(50)
      make.centerY.equalToSuperview()
    }
    
    subscribeButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-15)
    }
    
    subscribeLabel.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview()
    }
    
    subscribeImg.snp.makeConstraints { (make) in
      make.width.equalTo(30)
      make.height.equalTo(20)
      make.centerY.equalToSuperview()
      make.trailing.equalTo(subscribeLabel.snp.leading).offset(-10)
    }
    
    channelTitle.snp.makeConstraints { make in
      make.centerY.equalToSuperview().offset(-10)
      make.leading.equalTo(channelPic.snp.trailing).offset(20)
      make.trailing.equalTo(subscribeImg.snp.leading).offset(-20)
    }
    
    channelSubscribers.snp.makeConstraints { make in
      make.centerY.equalToSuperview().offset(10)
      make.leading.equalTo(channelTitle.snp.leading)
    }
    
  }
}


extension PlayerView {
  func socketBind(){
    socket.rx.on("response:player status check")
      .asObservable()
      .distinctUntilChanged({
        let videoUrlFirst = $0[2] as! String
        guard let videoUrlSecond = $1[2] as? String else { return false }
        
        if videoUrlFirst == videoUrlSecond {
          return true
        }
        return false
      })
      .subscribe(onNext: {
        let videoUrl = $0[2] as! String
        
        if videoUrl != "https://www.youtube.com/watch" {
          let videoID = videoUrl.components(separatedBy: "v=")[1]
          
          let curretTime = $0[0] as! NSNumber
          let curretStatus = $0[1] as! NSNumber
          let info = self.reactor!.currentState.video!.org_video_id
          
          if ( videoID == info) {
            self.YTPlayer.seek(to: curretTime.intValue, allowSeekAhead: true)
          } else {
            
            _ = Observable.just(videoID).bind(to: self.YTPlayer.rx.origin)
            self.YTPlayer.seek(to: curretTime.intValue, allowSeekAhead: true)
          }
        }
      }).disposed(by: self.disposeBag)
  }
}
