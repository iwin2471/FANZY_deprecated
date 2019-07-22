//
//  File.swift
//  FANZY
//
//  Created by 김연준 on 14/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import RxSwift
import RxCocoa

extension UIImage {
  func resized(newSize:CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
    self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
}

extension UIView {
  func addConstraintsWithFormat(format: String, views: UIView...) {
    var viewsDictionary = [String: UIView]()
    for (index, view) in views.enumerated() {
      let key = "v\(index)"
      view.translatesAutoresizingMaskIntoConstraints = false
      viewsDictionary[key] = view
    }
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
  }
}

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
  }
  
  convenience init(rgb: Int, alpha: CGFloat = 1) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF,
      alpha: alpha
    )
  }
}

extension String {
  var hex: Int? {
    return Int(self, radix: 16)
  }
  func boundingRect(with size: CGSize, attributes: [NSAttributedString.Key: Any]) -> CGRect {
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
    let rect = self.boundingRect(with: size, options: options, attributes: attributes, context: nil)
    return snap(rect)
  }
  
  func size(fits size: CGSize, font: UIFont, maximumNumberOfLines: Int = 0) -> CGSize {
    let attributes: [NSAttributedString.Key: Any] = [.font: font]
    var size = self.boundingRect(with: size, attributes: attributes).size
    if maximumNumberOfLines > 0 {
      size.height = min(size.height, CGFloat(maximumNumberOfLines) * font.lineHeight)
    }
    return size
  }
  
  func width(with font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
    let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    return self.size(fits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).width
  }
  
  func height(fits width: CGFloat, font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    return self.size(fits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).height
  }
}


/// Ceil to snap pixel
func snap(_ x: CGFloat) -> CGFloat {
  let scale = UIScreen.main.scale
  return ceil(x * scale) / scale
}

func snap(_ point: CGPoint) -> CGPoint {
  return CGPoint(x: snap(point.x), y: snap(point.y))
}

func snap(_ size: CGSize) -> CGSize {
  return CGSize(width: snap(size.width), height: snap(size.height))
}

func snap(_ rect: CGRect) -> CGRect {
  return CGRect(origin: snap(rect.origin), size: snap(rect.size))
}


extension Array where Element: Hashable {
  
  func removingDuplicates() -> [Element] {
    var addedDict = [Element: Bool]()
    
    return filter {
      addedDict.updateValue(true, forKey: $0) == nil
    }
  }
  
  mutating func removeDuplicates() {
    self = self.removingDuplicates()
  }
}

public extension UIButton {
  
  func alignTextBelow(spacing: CGFloat = 6.0) {
    if let image = self.imageView?.image {
      let imageSize = self.imageView!.frame.size
      self.titleEdgeInsets = UIEdgeInsets(top: imageSize.height + spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
      let labelString = NSString(string: self.titleLabel!.text!)
      let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
      self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
    }
  }
  
}

extension UILabel {
  func textWidth() -> CGFloat {
    return UILabel.textWidth(label: self)
  }
  
  class func textWidth(label: UILabel) -> CGFloat {
    return textWidth(label: label, text: label.text!)
  }
  
  class func textWidth(label: UILabel, text: String) -> CGFloat {
    return textWidth(font: label.font, text: text)
  }
  
  class func textWidth(font: UIFont, text: String) -> CGFloat {
    let myText = text as NSString
    
    let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    return ceil(labelSize.width)
  }
}

extension UIImage {
  
  func addImagePadding(x: CGFloat, y: CGFloat) -> UIImage? {
    let width: CGFloat = size.width + x
    let height: CGFloat = size.height + y
    UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
    let origin: CGPoint = CGPoint(x: (width - size.width) / 2, y: (height - size.height) / 2)
    draw(at: origin)
    let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return imageWithPadding
  }
}


extension UIView{
  func copyView() -> UIView? {
    return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? UIView
  }
}

var vSpinner : UIView?

extension UIViewController {
  func showSpinner(onView : UIView) {
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let ai = UIActivityIndicatorView.init(style: .whiteLarge)
    ai.startAnimating()
    ai.center = spinnerView.center
    
    DispatchQueue.main.async {
      spinnerView.addSubview(ai)
      onView.addSubview(spinnerView)
    }
    
    vSpinner = spinnerView
  }
  
  func removeSpinner() {
    DispatchQueue.main.async {
      vSpinner?.removeFromSuperview()
      vSpinner = nil
    }
  }
}

extension UICollectionView {
  var nextPage:Observable<Bool> {
    return self
      .rx.contentOffset
      .flatMap { [unowned self] (offset) -> Observable<Bool> in
        var shouldTriger = false

        if self.contentSize.height != 0.0 {
          shouldTriger = offset.y + self.frame.size.height + 40  > self.contentSize.height
        }
        return Observable.just(shouldTriger)
    }
  }
}

extension UITableView {
  var nextPage:Observable<Bool> {
    return self
      .rx.contentOffset
      .flatMap { [unowned self] (offset) -> Observable<Bool> in
        var shouldTriger = false
        
        if self.contentSize.height != 0.0 {
          shouldTriger = offset.y + self.frame.size.height + 40  > self.contentSize.height
        }
        return Observable.just(shouldTriger)
    }
  }
}
