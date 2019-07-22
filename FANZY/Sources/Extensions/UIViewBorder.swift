//
//  UIViewBorder.swift
//  FANZY
//
//  Created by 김연준 on 24/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import UIKit

extension UIView {
  
  // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
  
  enum ViewSide {
    case Left, Right, Top, Bottom
  }
  
  func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
    
    let border = CALayer()
    border.backgroundColor = color
    
    switch side {
    case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
    case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
    case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
    case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
    }
    
    layer.addSublayer(border)
  }
}

