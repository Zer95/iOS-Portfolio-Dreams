//
//  MainViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/04.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser != nil {
          
            let user = Auth.auth().currentUser
            if let user = user {
              // The user's ID, unique to the Firebase project.
              // Do NOT use this value to authenticate with your backend server,
              // if you have one. Use getTokenWithCompletion:completion: instead.
              let uid = user.uid
              let email = user.email
              let photoURL = user.photoURL
              let name = user.displayName
                
              var multiFactorString = "MultiFactor: "
              for info in user.multiFactor.enrolledFactors {
                multiFactorString += info.displayName ?? "[DispayName]"
                multiFactorString += " "
              }
               print("정보: \(uid)")
                print("정보: \(email!)")
                print("정보: \(photoURL)")
                print("정보: \(name)")
                
                
            }
            
        } else {
          // No user is signed in.
          // ...
        }
    }
    
    @IBAction func loginTest(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
    
  

}
