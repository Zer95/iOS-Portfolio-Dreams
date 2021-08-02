//
//  ViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/02.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
 
        /* 구글로그인 연동 컨트롤러 연결을해당 현재 컨트롤로 값으로 부여 */
        GIDSignIn.sharedInstance()?.presentingViewController = self
            

    }

    
    @IBAction func googleLoginBtn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn() // 구글 로그인 불러오기
        GIDSignIn.sharedInstance()
    }
    
}

