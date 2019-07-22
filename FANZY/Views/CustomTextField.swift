//
//  CustomTextField.swift
//  FANZY
//
//  Created by minwank on 30/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import UIKit

class TextField: UITextField {
  var padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
  
  
  init(padding: UIEdgeInsets) {
    self.init()
    self.padding = padding
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}
