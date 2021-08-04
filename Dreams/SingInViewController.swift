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
import FirebaseFirestore

class SingInViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var profileIMG: UIImageView!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    // Create left UIBarButtonItem.
    lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(buttonPressed(_:)))
        button.tag = 1
        return button
    }()

    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.leftButton
        self.navigationController?.navigationBar.barTintColor = .white
     
        
        profileIMG.layer.cornerRadius = profileIMG.frame.height/2
        profileIMG.layer.borderWidth = 1
        profileIMG.clipsToBounds = true
        profileIMG.layer.borderColor = UIColor.clear.cgColor  //원형 이미지의 테두리 제거
        
        // scrollView 클릭시 키보드 내리기
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
            
        ScrollView.addGestureRecognizer(singleTapGestureRecognizer)

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
           self.view.endEditing(true)
     }
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
          self.view.endEditing(true)
      }
    
  
    @IBAction func CreateUser(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, err) in
            
            let uid = user!.user.uid
            
            self.db.collection("Users").document(uid).setData([
                "name": self.name.text!,
                "성별": "남녀",
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            
        }
                                    
    }
    
    @objc private func buttonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        }

    
}
