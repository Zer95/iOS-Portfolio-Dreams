//
//  ShopDetailViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/24.
//

import UIKit
import Firebase

class ShopDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    var recieveData = ""
    
    let shopViewModel = ShopViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ServerDataLoad()

    }
    
    func ServerDataLoad() {
        db.collection("Shop").document("Category").collection(self.recieveData).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
            }
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
                
                let info = document.data()
                guard let name = info["name"] as? String else {return}
                guard let price = info["price"] as? Int else {return}
                guard let stock = info["stock"] as? Int else {return}
                guard let delivery = info["delivery"] as? Int else {return}
                
                self.shopViewModel.shopList.append(ShopInfo(name: name, price: price, stock: stock, delivery: delivery))
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension ShopDetailViewController: UICollectionViewDataSource  , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopViewModel.numOfShopList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopDetailCell", for: indexPath) as? ShopDetailCell else {
            return UICollectionViewCell()
        }
          
        cell.name.text = shopViewModel.shopList[indexPath.row].name
        cell.price.text = "\(shopViewModel.shopList[indexPath.row].price)원"
        cell.delivery.text = "\(shopViewModel.shopList[indexPath.row].delivery)원"
        
        
          return cell
        }
        
          
   
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 0)
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 10
       
        
        let width: CGFloat = (collectionView.bounds.width - itemSpacing)/2
        let height: CGFloat = width * 10/7
        return CGSize(width: width, height: height)
    }
}


extension ShopDetailViewController: UICollectionViewDelegate {
  
        // 셀 클릭시 동작하는 부분
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
         
        }
    }


class ShopDetailCell: UICollectionViewCell {
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var delivery: UILabel!
}
