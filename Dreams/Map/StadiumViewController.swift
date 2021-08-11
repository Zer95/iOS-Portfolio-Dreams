//
//  StadiumViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/11.
//

import UIKit
import Firebase

class StadiumViewController: UIViewController {

    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    var ReadStadiumData: [(title: String, img: UIImage, price: Int, Latitude: Double, longitude: Double)]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerDataLoad()
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
