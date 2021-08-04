//
//  ViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/04.
//

import UIKit
import SnapKit
import Firebase
import FirebaseRemoteConfig

class ViewController: UIViewController {

    var box = UIImageView()
    var remoteConfig: RemoteConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* 로고 이미지 생성 */
        self.view.addSubview(box)
        box.snp.makeConstraints{ (make) in
        make.center.equalTo(self.view)
        }
        box.image = #imageLiteral(resourceName: "loadingIcon")
        
        /* 리모트 세팅 */
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 36000
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.fetch() { (status, error) -> Void in
          if status == .success {
            print("Config fetched!")
            self.remoteConfig.activate() { (changed, error) in
              // ...
            }
          } else {
            print("Config not fetched")
            print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
          self.displayWelcome()
        }
        
    }
    
    func displayWelcome() {
        
        let caps = remoteConfig["splash_message_caps"].boolValue
        let message = remoteConfig["splash_message"].stringValue
        
        if(caps) {
            let alert = UIAlertController(title: "공지사항", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
                exit(0)
            }))
            self.present(alert, animated: true, completion: nil )
        } else {
            let loginVC = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: false, completion: nil)
        }
        
    }
  

}
