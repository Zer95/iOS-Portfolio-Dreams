//
//  Formatter.swift
//  Dreams
//
//  Created by SG on 2021/08/29.
//

import Foundation

class Formatter {
    
    // 숫자 , 단위 계산
    func priceFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    
}


