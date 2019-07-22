//
//  ReportCell.swift
//  FANZY
//
//  Created by 김연준 on 28/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import M13Checkbox
import UIKit

class ReportCell: BaseTableViewCell{
  private let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
  
  let title = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    $0.textColor = .white
    $0.textAlignment = .center
  }
  
  override func initialize() {
    super.initialize()
    
    self.contentView.addSubview(checkbox)
    self.contentView.addSubview(title)
    setupLayout()
    setEvent()
  }
  
  func setEvent() {
    checkbox.rx
      .tapGesture()
      .when(.recognized)
      .subscribe(onNext: { _ in
        NotificationCenter.default.post(name: NSNotification.Name("checkBoxEvent"), object: nil)
        self.updateCheckBox()
      })
      .disposed(by: disposeBag)
  }
  
  override func customise() {
    self.checkbox.stateChangeAnimation = .expand(.fill)
    self.backgroundColor = UIColor(named: "modalColor")
  }
  
  func setupLayout() {
    checkbox.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().offset(5)
      make.size.equalTo(CGSize(width: 20, height: 20))
      make.centerY.equalToSuperview()
    }
    
    title.snp.makeConstraints { (make) in
      make.top.equalTo(checkbox.snp_top)
      make.leading.equalTo(checkbox.snp_trailing).offset(5)
      make.centerY.equalToSuperview()
    }
  }
  
  func setReport(title: String) {
    self.title.text = title
  }
  
  func updateCheckBox() {
    switch checkbox.checkState {
      case .checked:
        checkbox.checkState = .unchecked
      case .unchecked:
        checkbox.checkState = .checked
      case .mixed:
        checkbox.checkState = .checked
    }
  }
  
  func unCheck(){
    checkbox.checkState = .unchecked
  }
  
  func checkState() -> M13Checkbox.CheckState{
    return checkbox.checkState
  }
}
