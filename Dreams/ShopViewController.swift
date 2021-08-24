//
//  ShopViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/24.
//

import UIKit

class ShopViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}


extension ShopViewController: UICollectionViewDataSource  , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCollectionCell", for: indexPath) as? ShopCollectionCell else {
            return UICollectionViewCell()
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
          
            
            print("클릭 인덱스: \(indexPath.row)")
       
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    


class ShopCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
}
