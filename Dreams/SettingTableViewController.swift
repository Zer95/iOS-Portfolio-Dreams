//
//  SettingTableViewController.swift
//  Dreams
//
//  Created by SG on 2021/09/03.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var bannerImage: UIImageView!
    
    var sectionCellCnt = [3,2,3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        bannerImage.layer.cornerRadius = bannerImage.frame.height/2
        bannerImage.layer.borderWidth = 1.0
        bannerImage.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        bannerImage.layer.shadowColor = UIColor.black.cgColor
        bannerImage.layer.shadowOffset = CGSize(width: 1 , height: 1)
        bannerImage.layer.shadowOpacity = 0.5
        bannerImage.layer.shadowRadius = 4.0
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionCellCnt[section]
    }

   

}
