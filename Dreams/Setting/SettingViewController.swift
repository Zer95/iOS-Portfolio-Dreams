//
//  SettingViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/09.
//

import UIKit

import UIKit
import Firebase
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import FBSDKLoginKit

class SettingViewController: UIViewController {

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
                print("정보: \(email)")
                print("정보: \(photoURL)")
                print("정보: \(name)")
                
                
            }
            
        } else {
          // No user is signed in.
          // ...
        }
        
        
        // 카카오 로그인 정보 가져오기
        
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")

                //do something
                _ = user
                print("카카오 아이디 : \(user?.id)")
                print("카카오 프로필 : \(user?.kakaoAccount?.profile?.nickname)")
                print("카카오 이메일 : \(user?.kakaoAccount?.email)")
             
                
            }
        }
        
        
    }
    
    @IBAction func loginTest(_ sender: Any) {
        // 구글 헤제
//        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance().disconnect()
        
        // 카카오 계정 연결 해제 ( 토큰삭제 및 회원 탈퇴 )
//        UserApi.shared.unlink {(error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("unlink() success.")
//
//            }
//        }
        
        // 카카오 로그아웃
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
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
    
    
  

}
