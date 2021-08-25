//
//  ShopInfo.swift
//  Dreams
//
//  Created by SG on 2021/08/25.
//

import UIKit

struct ShopInfo {
    
    let name: String
    let price: Int
    let stock: Int
    let delivery: Int
 
    
    var image: UIImage? {
        return UIImage(named: "\(name).jpg")
    }
    

    init(name: String, price:Int, stock: Int, delivery: Int) {
        self.name = name
        self.price = price
        self.stock = stock
        self.delivery = delivery
    }
}
