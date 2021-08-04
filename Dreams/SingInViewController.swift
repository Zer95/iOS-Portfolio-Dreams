//
//  SingInViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/04.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SingInViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
           self.view.endEditing(true)
     }
  
    @IBAction func CreateUser(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, err) in
            
            let uid = user!.user.uid
            Database.database().reference().child("users").child(uid).setValue(["name":self.name.text!])
            
            
        }
                                    
    }
    
}
