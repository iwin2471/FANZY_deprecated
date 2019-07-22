//
//  CustomButton.swift
//  FANZY
//
//  Created by 김연준 on 09/06/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import MaterialComponents

class CustomButton: MDCButton {
  var buttonImage = UIImageView()
  var buttonTitle = UILabel()
  
  init(ImageName: String, title: String) {
    super.init(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width/4, height: 60))
    backgroundColor = .clear
    buttonImage = UIImageView(image: UIImage(named: ImageName)?.resized(newSize: CGSize(width: 25, height: 25)))
    buttonTitle.text = title
    addSubview(buttonTitle)
    addSubview(buttonImage)
    
    setupLayout()
    customise()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func customise(){
    self.buttonImage.alpha = 0.7
    self.buttonTitle.font = UIFont.systemFont(ofSize: 14)
    self.buttonTitle.textColor = .white
    self.buttonTitle.alpha = 0.7
  }
  
  private func setupLayout(){
    buttonImage.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    
    buttonTitle.snp.makeConstraints { (make) in
      make.top.equalTo(buttonImage.snp.bottom).offset(5)
      make.centerX.equalToSuperview()
    }
  }
}
