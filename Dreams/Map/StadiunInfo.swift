//
//  StadiunInfo.swift
//  Dreams
//
//  Created by SG on 2021/08/11.
//

import UIKit

struct StadiumInfo {
    let title: String
    let price: Int
    var image: UIImage? {
        return UIImage(named: "\(title).jpg")
    }
    
    init(name: String, price:Int) {
        self.title = name
        self.price = price
    }
}
