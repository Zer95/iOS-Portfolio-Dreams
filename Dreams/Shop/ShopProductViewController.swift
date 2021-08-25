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
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var delivery: UILabel!
    @IBOutlet weak var stock: UILabel!
    
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    var recieveInfo = ShopInfo(keyName: "", name: "", price: 0, stock: 0, delivery: 0)
    var recieveImageReference: StorageReference?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
        
    }
    
    func updateUI(){
        name.text  = recieveInfo.name
        price.text = "\(recieveInfo.price)원"
        delivery.text = "배송비: \(recieveInfo.delivery)원"
        stock.text = "남은 수량: \(recieveInfo.stock)"
        
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
        
    }

}
