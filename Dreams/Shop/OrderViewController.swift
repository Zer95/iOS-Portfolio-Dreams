//
//  OrderViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/25.
//

import UIKit
import Firebase

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
    
    var userUid = ""
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    var productInfo = ShopInfo(keyName: "", name: "", price: 0, stock: 0, delivery: 0)
    
    var totalPrice = 0
    var productPrice = 0
    var deliveryPrice = 0
    
    var productStockCnt = 0
    var productSelectCnt = 1
    
    var receiveCategory = ""
        
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
    
    @IBAction func OrderBtn(_ sender: Any) {
        
        // 유저 정보 조회
        if Auth.auth().currentUser != nil {
          
            let user = Auth.auth().currentUser
            if let user = user {
          
              let uid = user.uid
//              let email = user.email ?? ""
//              let name = user.displayName ?? ""
                
                self.userUid = uid
//                self.userEmail = email
//                self.userName = name
            }
            
        } else {
          // No user is signed in.
          // ...
        }
        
        let orderUid = "\(DateToString(RE_Date: Date(), format: "YYYYMMddHHmmss"))-\(productInfo.keyName)"
        
        self.db.collection("Users").document(self.userUid).collection("Shop").document("Order").collection("Data").document(orderUid).setData([
            "productName": productInfo.name,
            "orderTime": DateToString(RE_Date: Date(), format: "YYYY-MM-dd:HH:SS"),
            "orderCount": self.productSelectCnt,
            "totalPrice": self.totalPrice
          
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                
                self.db.collection("Shop").document("Category").collection(self.receiveCategory).document(self.productInfo.keyName).updateData([
                    "stock": self.productInfo.stock - self.productSelectCnt
                 
                  
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
//                        let alert = UIAlertController(title: "알림", message: "결제가 완료 되었습니다.", preferredStyle: .alert)
//                                               alert.addAction(UIAlertAction(title: "확인", style: .default){
//                                               UIAlertAction in
//                                                self.dismiss(animated: true, completion: nil)
//
//                                         })
//                        self.present(alert, animated: true, completion: nil)
                        
                        let VC =  self.storyboard?.instantiateViewController(withIdentifier:"NativeController") as! NativeController
                        VC.modalPresentationStyle = .overFullScreen
                        VC.modalTransitionStyle = .crossDissolve
                        self.present(VC, animated: true, completion: nil)
                    }
         
            }
        
    }
    }
    }
    // #숫자 단위 계산
    func priceFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    // 날짜 데이터 문자열로 변환
    func DateToString(RE_Date: Date, format: String) -> String {
        let date:Date = RE_Date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
}





