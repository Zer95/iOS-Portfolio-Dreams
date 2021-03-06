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
    
    @IBOutlet weak var selectPay1: UIButton!
    @IBOutlet weak var selectPay2: UIButton!
    @IBOutlet weak var selectPay3: UIButton!
    @IBOutlet weak var selectPay4: UIButton!
    
    @IBOutlet weak var paymentAgreeBtn: UIButton!
    
    var selectPayType = ""
    
    
    var userUid = ""
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    let formatter = Formatter()
    
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
        
        priceLabel.text = "\(formatter.priceFormatter(number: productInfo.price))원"
        self.productPrice = productInfo.price
        
        stockLabel.text = "잔여 수량: \(productInfo.stock)"
        self.productStockCnt = productInfo.stock
        
        deliveryLabel.text = "+ \(formatter.priceFormatter(number:productInfo.delivery))원"
        self.deliveryPrice = productInfo.delivery
        
        let defaultTotal = productInfo.price + productInfo.delivery
        totalPriceLabel.text = "\(formatter.priceFormatter(number:defaultTotal))원"
        orderBtn.setTitle("(\(formatter.priceFormatter(number: defaultTotal)))원 결제하기", for: .normal)
        
        self.selectPay1.isSelected = true
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
            self.selectPriceLabel.text = "\(formatter.priceFormatter(number:selectProductPrice))원"
            self.totalPriceLabel.text = "\(formatter.priceFormatter(number:self.totalPrice))원"
            orderBtn.setTitle("\(formatter.priceFormatter(number:self.totalPrice))원 결제하기", for: .normal)
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
            self.selectPriceLabel.text = "\(formatter.priceFormatter(number:selectProductPrice))원"
            self.totalPriceLabel.text = "\(formatter.priceFormatter(number:self.totalPrice))원"
            orderBtn.setTitle("\(formatter.priceFormatter(number:self.totalPrice))원 결제하기", for: .normal)
        } else {
            print("1개이상은 필수 입니다!")
        }
    }
    
    @IBAction func selectPay1(_ sender: Any) {
        selectPay1.isSelected = true
        selectPay2.isSelected = false
        selectPay3.isSelected = false
        selectPay4.isSelected = false
        self.selectPayType = "kakaoPay"
        
    }
    
    @IBAction func selectPay2(_ sender: Any) {
        selectPay1.isSelected = false
        selectPay2.isSelected = true
        selectPay3.isSelected = false
        selectPay4.isSelected = false
        self.selectPayType = "naverPay"
    }
    
    @IBAction func selectPay3(_ sender: Any) {
        selectPay1.isSelected = false
        selectPay2.isSelected = false
        selectPay3.isSelected = true
        selectPay4.isSelected = false
        self.selectPayType = "card"
    }
    
    @IBAction func selectPay4(_ sender: Any) {
        selectPay1.isSelected = false
        selectPay2.isSelected = false
        selectPay3.isSelected = false
        selectPay4.isSelected = true
        self.selectPayType = "bank"
    }
    
    @IBAction func paymentAgreeBtn(_ sender: Any) {
        paymentAgreeBtn.isSelected = !paymentAgreeBtn.isSelected
    }
    
    @IBAction func agreeBtn(_ sender: Any) {
    }
    
    
    @IBAction func OrderBtn(_ sender: Any) {
        
        if self.paymentAgreeBtn.isSelected { // 약관동의가 되어 있는지 확인
           OderEvent()// 비밀번호 일치 & 약관을 모두 동의 할 경우 회원가입 하는 함수 호출
        } else {
            let alert = UIAlertController(title: "", message: "결제동의를 눌러주세요.", preferredStyle: .alert)
                                   alert.addAction(UIAlertAction(title: "확인", style: .default){
                                   UIAlertAction in
                             })
                            present(alert, animated: true, completion: nil)
        }
    }
  
    func OderEvent() {
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
                        VC.paymentType = self.selectPayType
                        self.present(VC, animated: true, completion: nil)
                    }
         
            }
        
    }
    }
        
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





