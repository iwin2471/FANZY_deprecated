//
//  ShopOption.swift
//  FANZY
//
//  Created by 김연준 on 01/06/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

class ShopOptionCell: BaseCell {
  var shopOptionButton: ShopOption = ShopOption()
  
  func setOption(optionNmae: String, image: String) {
    shopOptionButton = ShopOption(optionName: optionNmae, image: image)
    contentView.addSubview(shopOptionButton)
    contentView.isUserInteractionEnabled = true
    
    shopOptionButton.snp.makeConstraints { (make) in
      make.edges.equalTo(0)
    }
  }
}

class ShopOption: MDCButton {
  init(optionName: String, image: String) {
    self.init()
    let optionLabel = UILabel()
    let optionImg = UIImageView(image: UIImage(named: image)?.resized(newSize: CGSize(width: 50, height: 50)))
    self.addSubview(optionImg)
    self.addSubview(optionLabel)
    self.backgroundColor = .init(rgb: 0x282828)
    self.layer.cornerRadius = 5
    self.layer.masksToBounds = false
    self.clipsToBounds = true
    
    optionImg.alpha = 0.7
    optionImg.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-13)
    }
    
    optionLabel.text = optionName
    optionLabel.font = UIFont.systemFont(ofSize: 16)
    optionLabel.textColor = .white
    optionLabel.alpha = 0.7
    optionLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(optionImg.snp.bottom).offset(8)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
