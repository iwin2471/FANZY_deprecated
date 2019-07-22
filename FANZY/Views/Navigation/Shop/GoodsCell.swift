//
//  GoodsCell.swift
//  FANZY
//
//  Created by 김연준 on 14/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import Kingfisher
import SnapKit

class GoodsCell: BaseCardCell {
  let imageView = UIImageView()
  let infoWrapper = UIView()
  let goodsNameLabel = UILabel()
  let affiliate = UILabel()
  let expDate = UILabel()
  let price = UILabel()
  let fanzyPriceWrapper = UIView()
  let fanzyCoinImg = UIImageView(image: UIImage(named: "Coin")?.resized(newSize: CGSize(width: 16, height: 16)))
  let fanzyPriceLabel = UILabel()
  var goods: Goods? = nil
  
  override func initialize() {
    addSubview(imageView)
    addSubview(infoWrapper)
    infoWrapper.addSubview(goodsNameLabel)
    infoWrapper.addSubview(affiliate)
    infoWrapper.addSubview(expDate)
    infoWrapper.addSubview(price)
    infoWrapper.addSubview(fanzyPriceWrapper)
    fanzyPriceWrapper.addSubview(fanzyCoinImg)
    fanzyPriceWrapper.addSubview(fanzyPriceLabel)
    
    super.initialize()
  }
  
  override func customise(){
    let width = self.width
    
    self.then {
      $0.backgroundColor = .init(rgb: 0x212121)
    }
    
    imageView.then {
      $0.layer.cornerRadius = 10
      $0.layer.masksToBounds = false
      $0.clipsToBounds = true
      
      $0.snp.makeConstraints({ (make) in
        make.top.equalToSuperview().offset(15)
        make.leading.equalToSuperview()
        make.width.equalToSuperview()
        make.height.equalTo(self.frame.width)
      })
    }
    
    goodsNameLabel.then {
      $0.frame = CGRect(x: 0, y: 0, width: width, height: 50)
      $0.font = .systemFont(ofSize: 16, weight: .bold)
      $0.lineBreakMode = .byTruncatingTail
      $0.numberOfLines = 2
      $0.adjustsFontSizeToFitWidth = false
      $0.textColor = .white
      
      $0.snp.makeConstraints({ (make) in
        make.top.equalTo(imageView.snp.bottom).offset(10)
        make.leading.equalTo(imageView.snp.leading)
        make.trailing.equalTo(imageView.snp.trailing)
      })
    }
    
    affiliate.then {
      $0.font = .systemFont(ofSize: 14)
      $0.lineBreakMode = .byTruncatingTail
      $0.numberOfLines = 1
      $0.adjustsFontSizeToFitWidth = false
      $0.textColor = .white
      $0.alpha = 0.7
      
      $0.snp.makeConstraints({ (make) in
        make.top.equalTo(goodsNameLabel.snp.bottom).offset(10)
        make.leading.equalTo(imageView.snp.leading)
        make.trailing.equalTo(imageView.snp.trailing)
      })
    }
    
    expDate.then {
      $0.font = .systemFont(ofSize: 14)
      $0.lineBreakMode = .byTruncatingTail
      $0.numberOfLines = 1
      $0.adjustsFontSizeToFitWidth = false
      $0.textColor = .white
      $0.alpha = 0.7
      
      $0.snp.makeConstraints({ (make) in
        make.top.equalTo(affiliate.snp.bottom).offset(5)
        make.leading.equalTo(imageView.snp.leading)
        make.trailing.equalTo(imageView.snp.trailing)
      })
    }
    
    price.then {
      $0.font = .systemFont(ofSize: 14)
      $0.lineBreakMode = .byTruncatingTail
      $0.numberOfLines = 1
      $0.adjustsFontSizeToFitWidth = false
      $0.textColor = .white
      $0.alpha = 0.7
      
      $0.snp.makeConstraints({ (make) in
        make.top.equalTo(expDate.snp.bottom).offset(5)
        make.leading.equalTo(imageView.snp.leading)
        make.trailing.equalTo(imageView.snp.trailing)
      })
    }
    
    fanzyCoinImg.then {
      $0.snp.makeConstraints({ (make) in
        make.top.equalTo(price.snp.bottom).offset(10)
        make.leading.equalTo(imageView.snp.leading)
        make.width.equalTo(16)
        make.height.equalTo(16)
      })
    }
    
    fanzyPriceLabel.then {
      $0.font = .systemFont(ofSize: 16, weight: .bold)
      $0.lineBreakMode = .byTruncatingTail
      $0.numberOfLines = 1
      $0.adjustsFontSizeToFitWidth = false
      $0.textColor = .white
      
      $0.snp.makeConstraints({ (make) in
        make.top.equalTo(fanzyCoinImg.snp.top).offset(-2)
        make.leading.equalTo(fanzyCoinImg.snp.trailing).offset(10)
      })
    }
  }
}

extension GoodsCell {
  func setGoods(goods: Goods){
    self.goods = goods
    setCell()
  }
  
  func setCell() {
    let imageURL = URL(string: goods!.img)
    let limitDate: Int = Int(goods!.limitDate)!
    let fanzyPrice: Double = Double(goods!.totalPrice)! / 200
    var goodsAffiliate: String =  "없음"
    
    if let affiliate = goods!.affiliate as? String {
      goodsAffiliate = affiliate
    }
    
    imageView.backgroundColor = .init(rgb: 0x282828)
    imageView.kf.setImage(with: imageURL)
    goodsNameLabel.text = goods!.name
    affiliate.text = "사용처 : \(goodsAffiliate)"
    expDate.text = "유효기간 : \(limitDate)"
    
    price.text = "가격 : \(goods!.totalPrice)₩"
    if case fanzyPrice = round(fanzyPrice) {
      fanzyPriceLabel.text = String(format: "%.0f", fanzyPrice)
    } else {
      fanzyPriceLabel.text = String(format: "%.1f", fanzyPrice)
    }
  }
}
