//
//  StadiumViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/11.
//

import UIKit
import Firebase
import MaterialComponents.MaterialButtons
import Lottie

class StadiumViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let animationView = AnimationView()
    
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    var ReadStadiumData: [(title: String, img: UIImage, price: Int, Latitude: Double, longitude: Double)]? = []
    
    override func viewDidAppear(_ animated: Bool) {
        headerAnimation()
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerDataLoad()
        setFloatingButton()
        headerAnimation()
    }
    
    func headerAnimation() {
        animationView.animation = Animation.named("reservation")
        animationView.frame = headerView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        headerView.addSubview(animationView)
    }
    
    // 플로팅 버튼 정의
    func setFloatingButton() {
            let floatingButton = MDCFloatingButton()
            let image = UIImage(named: "mapIcon.jpg")
            floatingButton.sizeToFit()
            floatingButton.translatesAutoresizingMaskIntoConstraints = false
            floatingButton.setImage(image, for: .normal)
            floatingButton.setImageTintColor(.white, for: .normal)
            floatingButton.backgroundColor = .white
            floatingButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
            view.addSubview(floatingButton)
            view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -40))
            view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -20))
        }
    
    // 플로팅 버튼 클릭시 -> 바코드 & 입력창 띄우기
    @objc func tap(_ sender: Any) {
        let loginVC = self.storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.stadiumData = self.ReadStadiumData!
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    func ServerDataLoad() {
        db.collection("Stadium").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    print("왜 안먹어 ")
                    let info = document.data()
                    guard let title = info["title"] as? String else {return}
                    print("dd \(title)")
                    
                    guard let price = info["price"] as? Int else {return}
                    print("dd \(price)")
                    
                    guard let Latitude = info["Latitude"] as? Double else {return}
                    print("dd \(Latitude)")
                    
                    guard let Longitude = info["Longitude"] as? Double else {return}
                    print("dd \(Longitude)")
                    

                    self.ReadStadiumData?.append((title: title, img: #imageLiteral(resourceName: "baseball3"), price: price, Latitude: Latitude, longitude: Longitude))
                  // self.stadiumData?.append((title: "dd232", img: #imageLiteral(resourceName: "baseball3"), price: 3, Latitude: 3.0, longitude: 3.0))
//
                  print("검사  \(self.ReadStadiumData)")
                    
                }
            }
      
            print("마지막 전체개수 \( self.ReadStadiumData?.count ?? 0)")
            
            let loginVC = self.storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.stadiumData = self.ReadStadiumData!
            self.navigationController?.pushViewController(loginVC, animated: true)
            

            
        }
        
       
    }
   

}

extension StadiumViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StadiumTableViewCell", for: indexPath) as? StadiumTableViewCell else {
            return UITableViewCell()
        }
        
     
        return cell
    
    }
}

extension StadiumViewController:UITableViewDelegate {
    
}
