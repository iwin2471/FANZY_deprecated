//
//  VideoNetworkModel.swift
//  FANZY
//
//  Created by 김연준 on 16/05/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import Moya

enum StoreNetworkModel {
  case getItems
  case getSpecificItem(goodsID: String)
}

extension StoreNetworkModel: TargetType {
  var baseURL: URL { return URL(string: "")! }
  
  var path: String {
    switch self {
    case .getSpecificItem:
      return "/gift/api"
    case .getItems:
      return "/gift/api"
    }
  }
  
  var method: Moya.Method {
    switch self {
      case .getSpecificItem:
        return .get
      case .getItems:
        return .get
    }
  }
  
  var task: Task {
    switch self {
    case let .getSpecificItem(goodsID):
      return .requestParameters(parameters: [
        "goods_id" : goodsID
        ], encoding: URLEncoding.default)
    case .getItems:
      return .requestParameters(parameters: [
        "goods_id" : ""
        ], encoding: URLEncoding.default)
    }
  }
  
  var sampleData: Data {
    switch self {
      case .getItems, .getSpecificItem:
        return "[{\"goods_id\":\"G00000014231\",\"category1\":\"일반상품(물품교환형)\",\"category2\":\"커피/음료\",\"affiliate\":\"스타벅스\",\"desc\":\"▶상품설명\n진한 프리미엄 초콜릿을 한잔의 컵에 담았습니다.\n\n▶유의사항\n-본 상품은 매장 재고 상황에 따라 동일 상품으로 교환이 불가능할 수 있습니다.\n-동일 상품 교환이 불가능한 경우 동일 가격 이상의 다른 상품으로 교환이 가능하며 차액은 추가 지불하여야 합니다.\n-상기 이미지는 실제와 다를 수 있습니다.\n-상기 이미지는 연출된 것으로 실제와 다를 수 있습니다.\n\n▶사용불가매장\n평택험프리점, 캠프케이시점, 군산에어베이스점, 대구캠프워커점, 평택험프리 메인몰점, 평택험프리 트룹몰점, 오산에어베이스점, 캠프캐롤점, 용산미8군점, 용산타운하우스점, 오션월드점, 오션월드입구점\",\"goods_nm\":\"시그니처 핫 초콜릿 Tall\",\"goods_img\":\"http://imgs.giftishow.co.kr/Resource/goods/G00000014231/G00000014231_250.jpg\",\"sale_price\":\"5300\",\"sale_vat\":\"0\",\"total_price\":\"5300\",\"period_end\":\"29991231\",\"limit_date\":\"60\",\"end_date\":\"20190730\"}]".utf8Encoded
    }
  }

  var headers: [String: String]? {
    return ["Content-type": "application/json"]
  }
}

private extension String {
  var urlEscaped: String {
    return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
  
  var utf8Encoded: Data {
    return data(using: .utf8)!
  }
}

