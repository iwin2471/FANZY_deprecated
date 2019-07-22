//
//  BaseCardCell.swift
//  FANZY
//
//  Created by 김연준 on 01/06/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import MaterialComponents
import UIKit
import ReactorKit
import RxCocoa
import RxSwift


class BaseCardCell: MDCCardCollectionCell {
  var disposeBag: DisposeBag = DisposeBag()
  
  // MARK: Initializing
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private(set) var didSetupConstraints = false
  
  override func updateConstraints() {
    if !self.didSetupConstraints {
      self.setupConstraints()
      self.didSetupConstraints = true
    }
    super.updateConstraints()
  }
  
  func setupConstraints(){
    
  }
  
  func initialize(){
    customise()
  }
  
  func customise(){
    
  }
}
