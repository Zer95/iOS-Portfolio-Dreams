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
    
    let formatter = Formatter()
    
    var recieveData = ""
    var recieveTitle = ""
   
    
    let shopViewModel = ShopViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.recieveTitle
        
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
                
                self.shopViewModel.shopList.append(ShopInfo(keyName: document.documentID, name: name, price: price, stock: stock, delivery: delivery))
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
        let price = formatter.priceFormatter(number: shopViewModel.shopList[indexPath.row].price)
        cell.price.text = "\(price)원"
        let delivery = formatter.priceFormatter(number: shopViewModel.shopList[indexPath.row].delivery)
        cell.delivery.text = "배송비: \(delivery)원"
        
        
        let storageReference = Storage.storage().reference().child("Shop").child("Data").child(self.recieveData).child("\(shopViewModel.shopList[indexPath.row].keyName).jpg")
        storageReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
            // Uh-oh, an error occurred!
            print("error: \(error)")
            } else {
                

            let image = UIImage(data: data!)
                cell.ImageView.image = image
              
                }
            }
        
        
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
            
            let VC = self.storyboard?.instantiateViewController(identifier: "ShopProductViewController") as! ShopProductViewController
            VC.modalPresentationStyle = .fullScreen
            VC.modalTransitionStyle = .crossDissolve
            VC.recieveInfo = shopViewModel.shopList[indexPath.row]
            VC.recieveCategory = self.recieveData
            print("클릭 인덱스: \(indexPath.row)")
            
            let imageReference = Storage.storage().reference().child("Shop").child("Data").child(self.recieveData).child("\(shopViewModel.shopList[indexPath.row].keyName).jpg")
            VC.recieveImageReference = imageReference
            
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }


class ShopDetailCell: UICollectionViewCell {
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var delivery: UILabel!
}
