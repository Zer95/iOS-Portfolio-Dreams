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

class LoginViewController: UIViewController {

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var kakaoBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        settingBackground()
        SettingBtn()
        
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
           self.view.endEditing(true)
     }
    
    
    func SettingBtn() {
        loginBtn.layer.cornerRadius = 10
        loginBtn.layer.borderWidth = 1.0
        loginBtn.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
   
        
        inputEmail.layer.cornerRadius = 10
        inputEmail.layer.borderWidth = 1.0
        inputEmail.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
       
        
        inputPassword.layer.cornerRadius = 10
        inputPassword.layer.borderWidth = 1.0
        inputPassword.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      
        
        inputEmail.attributedPlaceholder = NSAttributedString(string: "  이메일을 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        inputPassword.attributedPlaceholder = NSAttributedString(string: "  비밀번호를 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        
    }
    
    
    @IBAction func googleBtn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn() // 구글 로그인 불러오기
        GIDSignIn.sharedInstance()
    }
    
}




