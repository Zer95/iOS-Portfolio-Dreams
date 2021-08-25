//
//  OrderViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/25.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

   
    }
    

    @IBAction func cancleBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}





