//
//  OrderViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/25.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    
    @IBOutlet weak var selectPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderBtn: UIButton!
    
    @IBOutlet weak var productCntLabel: UILabel!
    
    
    var productInfo = ShopInfo(keyName: "", name: "", price: 0, stock: 0, delivery: 0)
    
    var totalPrice = 0
    var productPrice = 0
    var deliveryPrice = 0
    
    var productStockCnt = 0
    var productSelectCnt = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
    }
    
    func updateUI() {
        nameLabel.text = productInfo.name
        
        priceLabel.text = "\(priceFormatter(number: productInfo.price))원"
        self.productPrice = productInfo.price
        
        stockLabel.text = "잔여 수량: \(productInfo.stock)"
        self.productStockCnt = productInfo.stock
        
        deliveryLabel.text = "+ \(priceFormatter(number:productInfo.delivery))원"
        self.deliveryPrice = productInfo.delivery
        
        let defaultTotal = productInfo.price + productInfo.delivery
        totalPriceLabel.text = "\(priceFormatter(number:defaultTotal))원"
        orderBtn.setTitle("\(priceFormatter(number:defaultTotal))원 결제하기", for: .normal)
    }
    

    @IBAction func cancleBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func productPlus(_ sender: Any) {
        
        if self.productStockCnt > self.productSelectCnt {
        self.productSelectCnt += 1
        let selectProductPrice = self.productPrice * self.productSelectCnt
        self.totalPrice = selectProductPrice + deliveryPrice
        
        self.productCntLabel.text = "\(self.productSelectCnt)"
        self.selectPriceLabel.text = "\(priceFormatter(number:selectProductPrice))원"
        self.totalPriceLabel.text = "\(priceFormatter(number:self.totalPrice))원"
        orderBtn.setTitle("\(priceFormatter(number:self.totalPrice))원 결제하기", for: .normal)
        } else {
            print("최대 선택 개수 입니다!")
        }
    }
    
    
    @IBAction func productMinus(_ sender: Any) {
        if self.productSelectCnt > 1 {
        self.productSelectCnt -= 1
            let selectProductPrice = self.productPrice * self.productSelectCnt
            self.totalPrice = selectProductPrice + deliveryPrice
            
            self.productCntLabel.text = "\(self.productSelectCnt)"
            self.selectPriceLabel.text = "\(priceFormatter(number:selectProductPrice))원"
            self.totalPriceLabel.text = "\(priceFormatter(number:self.totalPrice))원"
            orderBtn.setTitle("\(priceFormatter(number:self.totalPrice))원 결제하기", for: .normal)
        } else {
            print("1개이상은 필수 입니다!")
        }
    }
    
    // #숫자 단위 계산
    func priceFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
}





