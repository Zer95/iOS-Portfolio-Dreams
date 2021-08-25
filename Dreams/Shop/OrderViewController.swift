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
    
    
    var productInfo = ShopInfo(keyName: "", name: "", price: 0, stock: 0, delivery: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
    }
    
    func updateUI() {
        nameLabel.text = productInfo.name
        priceLabel.text = "\(productInfo.price)원"
        stockLabel.text = "잔여 수량: \(productInfo.stock)"
        deliveryLabel.text = "+ \(productInfo.delivery)원"
        
        
    }
    

    @IBAction func cancleBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}





