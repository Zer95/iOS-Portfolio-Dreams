//
//  ShopViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/24.
//

import UIKit
import Firebase
import Lottie

class ShopViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    let animationView = AnimationView()
    
    var readCategory: [String : Any] = [:]
    var readCategoryValue: [String] = []
    var readCategoryKey: [String] = []
    var CategoryCnt = 0
    
    override func viewDidAppear(_ animated: Bool) {
       // navigationController?.setNavigationBarHidden(true, animated: animated)
        topViewAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopDataLoad()
        topViewAnimation()

    }
    
    func topViewAnimation() {
        animationView.animation = Animation.named("shop")
        animationView.frame = topView.bounds
        animationView.contentMode = .scaleToFill
        animationView.loopMode = .loop
        animationView.play()
        topView.addSubview(animationView)
    }
    
    func shopDataLoad() {
        db.collection("Shop").document("Category").getDocument { (querySnapshot, err) in
            if let err = err {
                print("[Log] Error getting documents: \(err)")
            } else {
                let readData = querySnapshot?.data()
                self.readCategory = readData!
          
                for (key, value) in readData! {
                    self.readCategoryKey.append(key)
                    self.readCategoryValue.append(value as! String)
                    
                }
                print("[Log] 데이터 키 : \(self.readCategoryKey)")
                print("[Log] 데이터 값 : \(self.readCategoryValue)")
                print("[Log] 데이터 로드개수 : \(self.readCategory.count)")
                self.CategoryCnt = self.readCategory.count
                
    
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
       
}

}
extension ShopViewController: UICollectionViewDataSource  , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.CategoryCnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCollectionCell", for: indexPath) as? ShopCollectionCell else {
            return UICollectionViewCell()
        }
        cell.title.text = self.readCategoryValue[indexPath.row]
        
        
        let storageReference = Storage.storage().reference().child("Shop").child("Category").child("\(self.readCategoryKey[indexPath.row]).jpg")
        storageReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
            // Uh-oh, an error occurred!
            print("error: \(error)")
            } else {
                

            let image = UIImage(data: data!)
                cell.imageView.image = image
              
                }
            }
          return cell
        }
        
          
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (Int(collectionView.frame.width) - 10) / 3 - 2 * 10
        return CGSize(width: size, height: 120)
    }
}

extension ShopViewController: UICollectionViewDelegate {
  
        // 셀 클릭시 동작하는 부분
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
            let VC = self.storyboard?.instantiateViewController(identifier: "ShopDetailViewController") as! ShopDetailViewController
            VC.modalPresentationStyle = .fullScreen
            VC.modalTransitionStyle = .crossDissolve
            VC.recieveData = self.readCategoryKey[indexPath.row]
            VC.recieveTitle = self.readCategoryValue[indexPath.row]
            
            print("클릭 인덱스: \(indexPath.row)")
       
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    


class ShopCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
}
