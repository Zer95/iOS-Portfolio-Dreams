//
//  ShopViewModel.swift
//  Dreams
//
//  Created by SG on 2021/08/25.
//

import Foundation

class ShopViewModel {
    
    var shopList: [ShopInfo] = []
    
    var numOfShopList: Int {
        return shopList.count
    }
    
    func shopInfo(at index: Int) -> ShopInfo {
        return shopList[index]
    }
}
