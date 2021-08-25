//
//  ShopProductViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/25.
//

import UIKit

class ShopProductViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var delivery: UILabel!
    @IBOutlet weak var stock: UILabel!
    

    var recieveInfo = ShopInfo(keyName: "", name: "", price: 0, stock: 0, delivery: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text  = recieveInfo.name
        price.text = "\(recieveInfo.price)원"
        delivery.text = "배송비: \(recieveInfo.delivery)원"
        stock.text = "남은 수량: \(recieveInfo.stock)"
        
    }
    


}
