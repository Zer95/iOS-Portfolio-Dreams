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
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController {

    
    @IBOutlet weak var login_ID: UITextField!
    @IBOutlet weak var login_PW: UITextField!
    
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var loginBtn: UIButton!

    
    
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var kakaoBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    
    
    /* 앱 실행 후 토큰 존재하면 로그인 필요없이 자동 로그인 */
    override func viewWillAppear(_ animated: Bool) {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                    }
                    else {
                        //기타 에러
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    self.performSegue(withIdentifier: "MainViewController", sender: self)
                }
            }
        }
        else {
            //로그인 필요
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        settingBackground()
        SettingBtn()
        
        /* 구글로그인 연동 컨트롤러 연결을해당 현재 컨트롤로 값으로 부여 */
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        /*
         [로그인 핸들러]
         로그인 상태가 변경 되면 다음 화면으로 이동.
         */
        Auth.auth().addStateDidChangeListener { (auth, user) in
        if let user = user {
        self.performSegue(withIdentifier: "MainViewController", sender: self) // 현재 사용자가 로그인 된 상태가 맞다면 다음 화면으로 이동
                }
        }

        
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
   
        
        login_ID.layer.cornerRadius = 10
        login_ID.layer.borderWidth = 1.0
        login_ID.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
       
        
        login_PW.layer.cornerRadius = 10
        login_PW.layer.borderWidth = 1.0
        login_PW.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      
        
        login_ID.attributedPlaceholder = NSAttributedString(string: "  이메일을 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        login_PW.attributedPlaceholder = NSAttributedString(string: "  비밀번호를 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        // 테스트 모드
         //     self.performSegue(withIdentifier: "MainViewController", sender: self)
             
            
        /* 상용모드 */
        Auth.auth().signIn(withEmail: login_ID.text!, password: login_PW.text!){ // 입력한 ID,PW로 로그인 인증하는 부분
                 (user, error) in if user != nil {
                     print("로그인 성공")
                     // 로그인시 ID,PW 입력창 초기화
                     self.login_ID.text!=""
                     self.login_PW.text!=""
                 } else {
                     print("로그인 불가")
                     self.loginFailMessage() // 로그인 실패시 에러 알림창 출력 함수 호출
                 }
            }
    }
    
    
    /* 로그인 실패시 알람창 띄우는 함수 */
    func loginFailMessage() {
         let message = "아이디 / 비밀번호가 맞지 않습니다."
         let alert = UIAlertController(title: "로그인 실패", message: message, preferredStyle:.alert)
         let action = UIAlertAction(title: "확인", style: .default, handler: nil)
         alert.addAction(action)
         present(alert,animated: true, completion: nil)
     }
    
    
    @IBAction func googleBtn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn() // 구글 로그인 불러오기
        GIDSignIn.sharedInstance()
    }
    
    
    @IBAction func kakaoBtn(_ sender: Any) {
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                    if (AuthApi.hasToken()) {
                        UserApi.shared.accessTokenInfo { (_, error) in
                            if let error = error {
                                if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                                    //로그인 필요
                                }
                                else {
                                    //기타 에러
                                }
                            }
                            else {
                                //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                                self.performSegue(withIdentifier: "MainViewController", sender: self)
                            }
                        }
                    }
                    else {
                        //로그인 필요
                    }
              
                  
                }
            }
        }
    
        
}
    


}
