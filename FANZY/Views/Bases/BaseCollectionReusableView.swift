//
//  BaseCollectionReusableView.swift
//  FANZY
//
//  Created by 김연준 on 03/06/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class BaseCollectionReusableView: UICollectionReusableView {
  
  // MARK: Properties
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
  
  func setupConstraints() {
    // Override point
  }
  
  func initialize() {
    // Override point
    customise()
  }
  
  func customise(){
    
  }
}
