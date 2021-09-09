//
//  SettingTableViewController.swift
//  Dreams
//
//  Created by SG on 2021/09/03.
//

import UIKit
import Firebase
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import FBSDKLoginKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var bannerImage: UIImageView!
    
    var sectionCellCnt = [2,2,3,2,2]
    
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
    
    @IBAction func logoutBtn(_ sender: Any) {

        GIDSignIn.sharedInstance().disconnect()
        
        // 카카오 로그아웃
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    // 페이스북

        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
      
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionCellCnt[section]
    }

   

}
