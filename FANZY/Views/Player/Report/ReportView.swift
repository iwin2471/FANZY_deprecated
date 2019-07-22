//
//  Report.swift
//  FANZY
//
//  Created by 김연준 on 28/05/2019.
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

class ReportView: BaseView {
  struct Reusable {
    static let reportCell = ReusableCell<ReportCell>()
  }
  
  let reportArray = ["성적인 콘텐츠",
                     "폭력적 또는 혐오스러운 콘텐츠",
                     "증오 또는 악의적인 콘텐츠",
                     "유해한 위험 행위",
                     "아동 학대",
                     "테러 조장",
                     "스팸 또는 사용자를 현혹하는 콘텐츠",
                     "재생불가"]
  
  let reportDictionalry = ["성적인 콘텐츠": "Sexual Content" ,
                           "폭력적 또는 혐오스러운 콘텐츠": "Violent or disgusting content",
                           "증오 또는 악의적인 콘텐츠": "Hateful or malicious content",
                           "유해한 위험 행위": "Harmful dangerous act",
                           "아동 학대": "Child abuse",
                           "테러 조장": "Terrorist promotion",
                           "스팸 또는 사용자를 현혹하는 콘텐츠": "Spammy or misleading content",
                           "재생불가": "Not playable"]
  //Mark: UI
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  let container = UIView()
  let exitButton = UIButton()
  let reportList = UITableView()
  
  let reportButton = MDCButton()
  let reportButtonText = UILabel()
  
  let networkProvider = MoyaProvider<VideoNetworkModel>()
  
  override func initialize() {
    super.initialize()
    addSubview(container)
    
    container.addSubview(titleLabel)
    titleLabel.addSubview(subtitleLabel)
    container.addSubview(exitButton)
    container.addSubview(reportButton)
    container.addSubview(reportList)
    reportButton.addSubview(reportButtonText)
    
    setEvent()
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.checkBoxEvent), name: NSNotification.Name("checkBoxEvent"), object: nil)
  }
  
  override func customise() {
    self.backgroundColor = .clear
    self.frame = UIScreen.main.bounds
    
    reportList.then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.delegate = self
      $0.dataSource = self
      $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat(reportArray.count) * 30.0)
      $0.separatorStyle = .none
      $0.isScrollEnabled = false
      $0.register(Reusable.reportCell)
    }
    
    titleLabel.then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
      $0.text = "신고"
      $0.textColor = .white
      $0.textAlignment = .left
    }
    
    subtitleLabel.then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
      $0.text = "신고사유를 선택해주세요."
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
    
    reportButton.then {
      $0.frame = CGRect(x: 0, y: 0, width: container.width-10, height: 50)
      $0.layer.cornerRadius = 5
      $0.backgroundColor = UIColor(named: "accentColor")
    }
    
    reportButtonText.then {
      $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
      $0.textColor = .white
      $0.text = "신고하기"
    }
  }
  
  func setEvent(){
    exitButton.rx.tap.subscribe(onNext: {
      self.animateOut()
    }).disposed(by: disposeBag)
    
    reportButton.rx.tap.subscribe(onNext: {
      var checkedIndex = 0
      
      for i in 0...self.reportArray.count-1 {
        let indexPath = IndexPath(row: i, section: 0)
        let cell = self.reportList.cellForRow(at: indexPath) as! ReportCell
        if cell.checkState() == .checked {
          checkedIndex = i
        }
      }
      
      let reason = self.reportDictionalry[self.reportArray[checkedIndex]]!
      
      self.networkProvider.request(.report(id: id, wallet_address: "wallet", org_video_id: "asdf" , reason: reason)) { result in
        switch result {
        case let .success(moyaResponse):
          let data = moyaResponse.data
          let statusCode = moyaResponse.statusCode
          print(data)
        case let .failure(error): break
        }
      }
    }).disposed(by: disposeBag)
  }
  
  override func setupConstraints() {
    container.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.75)
      make.width.equalToSuperview().multipliedBy(0.9)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    subtitleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(30)
      make.leading.equalTo(titleLabel.snp.leading)
    }
    
    exitButton.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    reportList.snp.removeConstraints()
    
    reportList.snp.makeConstraints { (make) in
      make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
      make.height.equalTo(reportArray.count * 50)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
//      make.width.equalTo(container.snp_width)
    }
    
    reportButton.snp.makeConstraints { (make) in
      make.height.equalTo(50)
      make.top.equalTo(reportList.snp.bottom).offset(20)
      make.width.equalToSuperview().offset(-40)
      make.leading.equalToSuperview().offset(20)
      make.bottom.equalToSuperview().offset(-20)
    }
    
    reportButtonText.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
    }
  }
}


extension ReportView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reportArray.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! ReportCell
    checkBoxEvent()
    cell.updateCheckBox()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(Reusable.reportCell, for: indexPath)
    cell.setReport(title: reportArray[indexPath.item])
    cell.selectionStyle = .none
    return cell
  }
}

extension ReportView {
  
  @objc fileprivate func checkBoxEvent() {
    for i in 0...reportArray.count-1 {
      let indexPath = IndexPath(row: i, section: 0)
      let cell = reportList.cellForRow(at: indexPath) as! ReportCell
      cell.unCheck()
    }
  }
  
  func animateIn() {
    self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
    self.alpha = 1
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
      self.container.transform = .identity
      self.alpha = 1
    })
  }
  
  @objc fileprivate func animateOut() {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
      self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
      self.alpha = 0
    }) { (complete) in
      if complete {
        self.removeFromSuperview()
      }
    }
  }
}
