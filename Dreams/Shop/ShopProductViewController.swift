//
//  ShopProductViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/25.
//

import UIKit
import Firebase

class ShopProductViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageInfoView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var delivery: UILabel!
    @IBOutlet weak var stock: UILabel!
    
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var buyBtn: UIButton!
    
    @IBOutlet weak var pointView: UIView!
    
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    let formatter = Formatter()
    
    var recieveInfo = ShopInfo(keyName: "", name: "", price: 0, stock: 0, delivery: 0)
    var recieveImageReference: StorageReference?
    var recieveInfoImageReference: StorageReference?
    var recieveCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        updateUI()
        settingNavigation()
        
    }
    
    func settingNavigation() {
        self.navigationController?.navigationBar.topItem?.title = ""
        let cart  = UIBarButtonItem(image: UIImage(systemName: "cart"),style: .plain,target: nil, action: nil)
        self.navigationItem.rightBarButtonItems = [cart]
    }
    
    func updateUI(){
        name.text  = recieveInfo.name
        price.text = "\(formatter.priceFormatter(number: recieveInfo.price))원"
        delivery.text = "배송비: \(formatter.priceFormatter(number: recieveInfo.delivery))원"
        stock.text = "남은 수량: \(recieveInfo.stock)"
        
        buyBtn.layer.cornerRadius = 10
        buyBtn.layer.borderWidth = 1.0
        buyBtn.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        buyBtn.layer.shadowColor = UIColor.black.cgColor
        buyBtn.layer.shadowOffset = CGSize(width: 1 , height: 1)
        buyBtn.layer.shadowOpacity = 0.5
        buyBtn.layer.shadowRadius = 4.0
        
        pointView.layer.cornerRadius = 7
        pointView.layer.borderWidth = 1.0
        pointView.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        
        let storageReference = self.recieveImageReference
        storageReference?.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
            // Uh-oh, an error occurred!
            print("error: \(error)")
            } else {
                

            let image = UIImage(data: data!)
                self.imageView.image = image
              
                }
            }
        
        let storageInfoReference = self.recieveInfoImageReference
        storageInfoReference?.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
            // Uh-oh, an error occurred!
            print("error: \(error)")
            } else {
                

            let image = UIImage(data: data!)
                self.imageInfoView.image = image
              
                }
            }
        
    }
    
    
    @IBAction func heartBtn(_ sender: Any) {
        heartBtn.isSelected = !heartBtn.isSelected
        
        if heartBtn.isSelected == true {
            heartBtn.tintColor = .red
        } else {
            heartBtn.tintColor = .darkGray
        }
        
        
    }
    
    @IBAction func buyBtn(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(identifier: "OrderViewController") as! OrderViewController
        VC.modalPresentationStyle = .fullScreen
        VC.productInfo = self.recieveInfo
        VC.receiveCategory = self.recieveCategory
        self.present(VC, animated: true, completion: nil)
    }
}
