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
    
    let stadiumViewModel = StadiumViewMoel()
    
    let animationView = AnimationView()
    
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    var ReadStadiumData: [(title: String, img: UIImage, price: Int, Latitude: Double, longitude: Double)]! = []
    
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
                    

              
                  
                    // 이미지 저장
                    let islandRef = Storage.storage().reference().child("\(document.documentID).jpg")
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                    if let error = error {
                    // Uh-oh, an error occurred!
                    print("error: \(error)")
                    } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
            
                        
                        self.ReadStadiumData.append((title: title, img: image!, price: price, Latitude: Latitude, longitude: Longitude))
                  
                        }
                    }
                    
                    self.stadiumViewModel.stadiumList.append(StadiumInfo(keyName: document.documentID ,name: title, price: price))
                }
            }
      
          
            print("마지막 전체개수 \( self.ReadStadiumData?.count ?? 0)")
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
//            let loginVC = self.storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
//            loginVC.modalPresentationStyle = .fullScreen
//            loginVC.stadiumData = self.ReadStadiumData!
//            self.navigationController?.pushViewController(loginVC, animated: true)
            
            
            
        }
        
       
    }
   

}

extension StadiumViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stadiumViewModel.numOfStadiumList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StadiumTableViewCell", for: indexPath) as? StadiumTableViewCell else {
            return UITableViewCell()
        }
        

        cell.Title.text = stadiumViewModel.stadiumList[indexPath.row].title
        cell.Price.text = "\(stadiumViewModel.stadiumList[indexPath.row].price)"
        
        let islandRef = Storage.storage().reference().child("\(stadiumViewModel.stadiumList[indexPath.row].keyName).jpg")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
        if let error = error {
        // Uh-oh, an error occurred!
        print("error: \(error)")
        } else {
        // Data for "images/island.jpg" is returned
        let image = UIImage(data: data!)

            cell.Thumbnail.image = image
         //   print("이미지 정보 값 \(image)")
            }
        }

        
     
      
        return cell
    
    }
}

extension StadiumViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loginVC = self.storyboard?.instantiateViewController(identifier: "DetailStadiumViewController") as! DetailStadiumViewController
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .crossDissolve
        loginVC.detailTitle = self.ReadStadiumData[indexPath.row].title
        
        print("클릭 인덱스: \(indexPath.row)")
   
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
}

class StadiumViewMoel {
    
var stadiumList: [StadiumInfo] = []
 
    var numOfStadiumList: Int {
        return stadiumList.count
    }
    
    func stadiumInfo(at index: Int) -> StadiumInfo {
        return stadiumList[index]
    }
}
