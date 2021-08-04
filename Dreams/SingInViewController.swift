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
    
    @IBOutlet weak var profileIMG: UIImageView!
    
    
    // Create left UIBarButtonItem.
    lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(buttonPressed(_:)))
        button.tag = 1
        return button
    }()

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.leftButton
        self.navigationController?.navigationBar.barTintColor = .white
     
        
        profileIMG.layer.cornerRadius = profileIMG.frame.height/2
        profileIMG.layer.borderWidth = 1
        profileIMG.clipsToBounds = true
        profileIMG.layer.borderColor = UIColor.clear.cgColor  //원형 이미지의 테두리 제거
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
    
    @objc private func buttonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        }

    
}
