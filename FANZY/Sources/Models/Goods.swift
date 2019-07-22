//
//  Video.swift
//  FANZY
//
//  Created by 김연준 on 14/04/2019.
//  Copyright © 2019 underpin. All rights reserved.
//

import Foundation
import ObjectMapper

struct Goods: ImmutableMappable {
  let goodsId: String
  let category1: String
  let category2: String
  let affiliate: Any
  let desc: String
  let name: String
  let img: String
  let salePrice: String
  let saleVat: String
  let totalPrice: String
  let periodEnd: String
  let limitDate: String
  let endDate: String
  
  
  init(map: Map) throws {
    goodsId = try map.value("goods_id")
    name = try map.value("goods_nm")
    category1 = try map.value("category1")
    category2 = try map.value("category2")
    affiliate = try map.value("affiliate")
    desc = try map.value("desc")
    img = try map.value("goods_img")
    salePrice = try map.value("sale_price")
    saleVat = try map.value("sale_vat")
    totalPrice = try map.value("total_price")
    periodEnd = try map.value("period_end")
    limitDate = try map.value("limit_date")
    endDate = try map.value("end_date")
  }
  
  
  func mapping(map: Map) {
    goodsId         >>> map["goods_id"]
    name            >>> map["goods_nm"]
    category1       >>> map["category1"]
    category2       >>> map["category2"]
    affiliate       >>> map["affiliate"]
    desc            >>> map["desc"]
    img             >>> map["goods_img"]
    salePrice       >>> map["sale_price"]
    saleVat         >>> map["sale_vat"]
    totalPrice      >>> map["total_price"]
    periodEnd       >>> map["period_end"]
    limitDate       >>> map["limit_date"]
    endDate         >>> map["end_date"]
  }
}
