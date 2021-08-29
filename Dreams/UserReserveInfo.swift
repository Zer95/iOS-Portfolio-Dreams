//
//  UserReserveInfo.swift
//  Dreams
//
//  Created by SG on 2021/08/20.
//

import UIKit

struct UserReserveInfo {
   
    let stadiumName: String
    let reserveTime: String
    let totalPrice: Int
    let equipmentState: Bool
    let screenState: Bool
    let selectDay:String
    let selectTime:[Int]
    
    
    init(stadiumName: String, reserveTime: String, totalPrice: Int, equipmentState: Bool, screenState: Bool, selectDay:String,selectTime:[Int]) {
        self.stadiumName = stadiumName
        self.reserveTime = reserveTime
        self.totalPrice = totalPrice
        self.equipmentState = equipmentState
        self.screenState = screenState
        self.selectTime = selectTime
        self.selectDay = selectDay
    }
    
}
