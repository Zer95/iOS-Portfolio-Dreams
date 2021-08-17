//
//  MainViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/04.
//

import UIKit
import SOTabBar
class MainViewController: SOTabBarController {

    override func loadView() {
        super.loadView()
        SOTabBarSetting.tabBarTintColor = #colorLiteral(red: 2.248547389e-05, green: 0.7047000527, blue: 0.6947537661, alpha: 1)
        SOTabBarSetting.tabBarCircleSize = CGSize(width: 60, height: 60)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        
        self.delegate = self
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
        let contentStoryboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Content")
        let stadiumStoryboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Stadium")
        let settingStoryboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Setting")
    
        
        homeStoryboard.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_Selected"))
        contentStoryboard.tabBarItem = UITabBarItem(title: "컨텐츠", image: UIImage(named: "chat"), selectedImage: UIImage(named: "chat_Selected"))
        stadiumStoryboard.tabBarItem = UITabBarItem(title: "경기장", image: UIImage(named: "music"), selectedImage: UIImage(named: "music_Selected"))
        settingStoryboard.tabBarItem = UITabBarItem(title: "설정", image: UIImage(named: "menu"), selectedImage: UIImage(named: "menu_Selected"))
     
           
        viewControllers = [stadiumStoryboard, homeStoryboard,contentStoryboard,  settingStoryboard]
    }
    
}

extension MainViewController: SOTabBarControllerDelegate {
    func tabBarController(_ tabBarController: SOTabBarController, didSelect viewController: UIViewController) {
        print(viewController.tabBarItem.title ?? "")
    }
}
