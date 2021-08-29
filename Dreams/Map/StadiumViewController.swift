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
    
    let formetter = Formatter()
  
    
    var imageGet: [UIImage]! = []
    
    var ReadStadiumData: [(keyName: String, title: String, img1: UIImage ,price: Int, Latitude: Double, longitude: Double)]! = []
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
   
           // navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    

  
    override func viewDidAppear(_ animated: Bool) {
       // navigationController?.setNavigationBarHidden(true, animated: animated)
        headerAnimation()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
  
        ServerDataLoad()
        setFloatingButton()
        headerAnimation()
        
        // 테이블 뷰 밑줄 제거
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    func headerAnimation() {
        animationView.animation = Animation.named("map1")
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
        let VC = self.storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
        VC.modalPresentationStyle = .fullScreen
        VC.stadiumData = self.ReadStadiumData!
        self.navigationController?.pushViewController(VC, animated: true)
        
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
                    
                    guard let address = info["Address"] as? String else {return}
             
                  
                    // 이미지 저장
                    let islandRef = Storage.storage().reference().child("\(document.documentID)").child("file" + "\(1)" + ".jpg")
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                    if let error = error {
                    // Uh-oh, an error occurred!
                    print("error: \(error)")
                    } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                       
                        
                     
                        self.ReadStadiumData.append((keyName: "\(document.documentID)", title: title, img1: image!, price: price, Latitude: Latitude, longitude: Longitude))
                  
                        }
                    }
              
                    self.stadiumViewModel.stadiumList.append(StadiumInfo(keyName: document.documentID ,name: title, price: price, address: address))
                }
            }
      
          
            print("마지막 전체개수 \( self.ReadStadiumData?.count ?? 0)")
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
 
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
        let price = formetter.priceFormatter(number: stadiumViewModel.stadiumList[indexPath.row].price)
        cell.Price.text = "시간당: \(price)원"
        cell.Address.text = stadiumViewModel.stadiumList[indexPath.row].address
        
        
        
        
        
        let storageReference = Storage.storage().reference().child("\(stadiumViewModel.stadiumList[indexPath.row].keyName)")
        storageReference.listAll { (result, error) in
           
          if let error = error {
            // ...
          }
          for prefix in result.prefixes {
           
          }
            
           
            
            for i in 0...2 {
                
                print("결과 값 다 가져오기 \(result.items[i])")
   
     
                result.items[i].getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
            // Uh-oh, an error occurred!
            print("error: \(error)")
            } else {
                

            let image = UIImage(data: data!)
             //   cell.Thumbnail.image = image
                if i == 0 {
                    cell.Thumbnail.image = image
                } else if i == 1 {
                    cell.Thumbnail2.image = image
                } else if i == 2 {
                    cell.Thumbnail3.image = image
                }
                
         
                }
            }
            }

        }
        
        return cell
    
    }
}

extension StadiumViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = self.storyboard?.instantiateViewController(identifier: "DetailStadiumViewController") as! DetailStadiumViewController
        VC.modalPresentationStyle = .fullScreen
        VC.modalTransitionStyle = .crossDissolve
        VC.detailTitle = stadiumViewModel.stadiumList[indexPath.row].title
        VC.detailKeyName =  stadiumViewModel.stadiumList[indexPath.row].keyName
        
        print("클릭 인덱스: \(indexPath.row)")
   
        self.navigationController?.pushViewController(VC, animated: true)
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
