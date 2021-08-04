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
      
        settingBackground()
        
        /* 구글로그인 연동 컨트롤러 연결을해당 현재 컨트롤로 값으로 부여 */
        GIDSignIn.sharedInstance()?.presentingViewController = self
            

        
    }

    /* 상태바 색상 설정 */
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
    }


    func settingBackground() {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainBackground.png")
        imageView.contentMode = .scaleToFill
        // Adding the image view to the view hierarchy
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        // Make image view to fit entire screen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          imageView.topAnchor.constraint(equalTo: view.topAnchor),
          imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    @IBAction func googleLoginBtn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn() // 구글 로그인 불러오기
        GIDSignIn.sharedInstance()
    }
    
}



