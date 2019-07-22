//
//  File.swift
//  FANZY
//
//  Created by 김연준 on 18/06/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import ReactorKit
import Kingfisher
import MaterialComponents

class PurchaseViewController: BaseViewController, ReactorKit.View {
  let titleLabel = UILabel()
  let itemImageView = UIImageView()
  let summaryLabel = UILabel()
  let priceWrapper = UIView()
  let coinImageView = UIImageView(image: UIImage(named: "Coin")!.resized(newSize: CGSize(width: 25, height: 25)))
  let coinPriceText = UILabel()
  let purchaseButton = MDCButton()
  let backButton = UIButton(type: .custom)
  let baseItemInfo = UIView()
  let baseItemInfoLabel = UILabel()
  
  init(reactor: ShopPurchaseReactor) {
    super.init()
    self.reactor = reactor
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(itemImageView)
    view.addSubview(summaryLabel)
    view.addSubview(priceWrapper)
    view.addSubview(purchaseButton)
    view.addSubview(baseItemInfo)
    view.addSubview(titleLabel)
    
    priceWrapper.addSubview(coinImageView)
    priceWrapper.addSubview(coinPriceText)
    
    baseItemInfo.addSubview(baseItemInfoLabel)
  }
  
  override func customise() {
    view.backgroundColor = UIColor(named: "mainColor")
    titleLabel.textColor = .white
    navigationBarSetUp()
  }
  
  override func setupConstraints() {
    view.width = UIScreen.main.bounds.width
    view.height = UIScreen.main.bounds.height
    
    priceWrapper.height = 35
    priceWrapper.width = view.width
    priceWrapper.center = view.center
    
    summaryLabel.top = priceWrapper.bottom + 10
    summaryLabel.height = 50
    summaryLabel.width = view.width - 100
    summaryLabel.center = view.center
    
    priceWrapper.backgroundColor = .white
    coinImageView.top += 5
    coinImageView.left = priceWrapper.left + 5
    
    coinPriceText.left = coinImageView.right + 5
    coinPriceText.height = 35
    coinPriceText.width = 100
    
    baseItemInfo.width = view.width
    baseItemInfo.height = 350
    
    baseItemInfoLabel.width = baseItemInfo.width
    baseItemInfoLabel.height = baseItemInfo.height
    
    
    itemImageView.top += 100
    
    itemImageView.centerX = view.centerX
    itemImageView.right -= 50
    itemImageView.height = 150
    itemImageView.width = 150
    
    titleLabel.top = itemImageView.bottom
    titleLabel.center = itemImageView.center
    
    baseItemInfo.top = titleLabel.bottom
    
    titleLabel.height = 150
    titleLabel.width = view.width - 30
  }
  
  func bind(reactor: ShopPurchaseReactor) {
    let goods = reactor.currentState
    
    backButton.rx.tap.subscribe(onNext: {
      self.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
    
    summaryLabelSetUp(goods: goods)
    priceSetUp(goods: goods)
    itemImageSetUp(goods: goods)
  }
}

extension PurchaseViewController {
  func summaryLabelSetUp(goods: Goods) {
    summaryLabel.text = goods.name
  }
  
  func priceSetUp(goods: Goods){
    let fanzyPrice: Double = Double(goods.totalPrice)! / 200
    
    baseItemInfoLabel.textColor = .white
    baseItemInfoLabel.numberOfLines = 3

    
    baseItemInfoLabel.text = "사용처 : \(goods.affiliate) \n유효기간 : \(goods.limitDate)일\n 가격 : \(goods.totalPrice)₩"
    
    titleLabel.text = "\(goods.name)"
    
    if case fanzyPrice = round(fanzyPrice) {
      coinPriceText.text = String(format: "%.0f", fanzyPrice)
    } else {
      coinPriceText.text = String(format: "%.1f", fanzyPrice)
    }
    
  }
  
  func itemImageSetUp(goods: Goods) {
    let url = URL(string: goods.img)
    
    itemImageView.kf.setImage(
      with: url,
      placeholder: UIImage(named: "placeholderImage"),
      options: [
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(1)),
        .cacheOriginalImage
      ])
  }
}

extension PurchaseViewController {
  func navigationBarSetUp(){
    let backButtonItem  = UIBarButtonItem(customView: backButton)
    
    backButton.setImage(UIImage(named: "back")?.resized(newSize: CGSize(width: 28, height: 28)), for: .normal)
    
    self.navigationController?.navigationBar.barTintColor = UIColor(named: "navigationColor")
    
    self.navigationItem.leftBarButtonItem = backButtonItem
  }
}
