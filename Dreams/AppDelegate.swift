//
//  AppDelegate.swift
//  Dreams
//
//  Created by SG on 2021/08/02.
//

import UIKit
import Firebase
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth
import FBSDKCoreKit
import AuthenticationServices
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
    
        // 구글 로그인 연동 설정
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        // 카카오 로그인 연동
        KakaoSDKCommon.initSDK(appKey: "8fdfbdaae7ea82c3de42910f724e2292")
        
        
        // 페이스북 로그인 연동
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )//Facebook loing 하기 위해 사용된 코드 // Override point for customization after application launch.
        FBSDKCoreKit.Settings.appID = "868525054071636"//앱 ID : 페이스북 페이지에서 받은 앱의 ID

        
       // 애플 로그인 연동
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "00000.abcabcabcabc.0000") { (credentialState, error) in
            
            switch credentialState {
            case .authorized:
                print("해당 ID는 연동되어있습니다.")
                 case .revoked:
                    print("해당 ID는 연동되어있지않습니다.")
            case .notFound:
                print("해당 ID를 찾을 수 없습니다.")
                
           default:
            print("notFound")
            }

        // 구글 지도
        GMSServices.provideAPIKey("AIzaSyAePDTvKDyWbgya817QTmIHB1qZGurqE9s")
        GMSPlacesClient.provideAPIKey("AIzaSyAePDTvKDyWbgya817QTmIHB1qZGurqE9s") // 현재 위치
            
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

 
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
        
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                return AuthController.handleOpenUrl(url: url)
            }
        
        let google = GIDSignIn.sharedInstance().handle(url)
        
      
        
        return google
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let google = GIDSignIn.sharedInstance().handle(url)
        return google
    }
    
    
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if let error = error {
        // ...
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if (error != nil) {
            // Error. If error.code == .MissingOrInvalidNonce, make sure
            // you're sending the SHA256-hashed nonce as a hex string with
            // your request to Apple.
            print(error?.localizedDescription ?? "")
            return
        }
        guard let user = authResult?.user else { return }
        let email = user.email ?? ""
        let name = user.displayName ?? ""
        
    
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("Users").document(uid).setData([
            "email": email,
            "uid": uid,
            "name": name,
            "Type": "Google"
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("the user has sign up or is logged in")
            }
        }
        return
    }
    
 
}
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
