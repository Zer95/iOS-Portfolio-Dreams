//
//  DetailStadiumViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/11.
//

import UIKit
import Firebase

class DetailStadiumViewController: UIViewController {
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
  
    @IBOutlet weak var stadiumTitleLabel: UILabel!
    @IBOutlet weak var comment1Label: UILabel!
    @IBOutlet weak var comment2Label: UILabel!
    @IBOutlet weak var openTiemLabel: UILabel!
    @IBOutlet weak var maxPersonLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    
    @IBOutlet weak var backBtn: UIImageView!
    
   
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    

    var timer = Timer()
    var autoNum:Int = 1
    
    var imageGet: [UIImage]! = []
   
    var detailTitle: String!
    var detailKeyName: String!
    var detailImage1: UIImage!
    var detailImage2: UIImage!
    var detailImage3: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        ServerDataLoad()
        
        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
     //   imageView.image = UIImage(named: String(images[0]))
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(autoChange), userInfo: nil, repeats: true)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(DetailStadiumViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(DetailStadiumViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        
        // ????????? ??????
       

        let storageReference = Storage.storage().reference().child("\(self.detailKeyName!)")
        storageReference.listAll { (result, error) in
           
          if let error = error {
            // ...
          }
          for prefix in result.prefixes {
           
          }
            
           
            
            for i in 0...2 {
                
                print("?????? ??? ??? ???????????? \(result.items[i])")
   
     
                result.items[i].getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
            // Uh-oh, an error occurred!
            print("error: \(error)")
            } else {
                

            let image = UIImage(data: data!)
             //   cell.Thumbnail.image = image
                
                self.imageGet.append(image!)
                if i == 0 {
                    self.imageView.image = image
                }
               // else if i == 1 {
//                    self.imageView.image = image
//                } else if i == 2 {
//                    self.imageView.image = image
//                }
                
         
                }
            }
            }

        }
        
        
        
    }
    
    
    func ServerDataLoad() {
        db.collection("Stadium").document(self.detailKeyName).getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
           
                let info = querySnapshot?.data()
           //   print("?????? ???????????? ????????? ??? : \(info)")
                let title = info!["title"] as! String
                let comment1 = info!["comment1"] as! String
                let comment2 = info!["comment2"] as! String
                let maxPerson =  info!["maxPerson"] as! Int
                let tel  = info!["Tel"] as! String
                
                // ?????? ?????? ??????
                let openCloseTime = info!["openCloseTime"] as! [Int]
                
                self.stadiumTitleLabel.text = title
                self.comment1Label.text = comment1
                self.comment2Label.text = comment2
                self.telLabel.text = "????????????: \(tel)"
                self.openTiemLabel.text = "????????????: \(openCloseTime[0]):00 ~ \(openCloseTime[1]):00 "
                self.maxPersonLabel.text = "????????????: \(maxPerson)???"
                
                
               
                
      
                   }
            }
    }
    
    
    // ??? ????????? ???????????? ???????????? ????????? ??? ????????? ?????? ?????????
       @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
           // ?????? ???????????? ?????????
           if let swipeGesture = gesture as? UISwipeGestureRecognizer{
               
               // ????????? ???????????? ??? ????????? ???????????? ???????????????
               // pageControl??? ???????????? ?????? ???????????? ???????????? ???????????? imageView??? ??????
               switch swipeGesture.direction {
                   case UISwipeGestureRecognizer.Direction.left :
                       pageControl.currentPage -= 1
                    imageView.image = imageGet[pageControl.currentPage]
                   case UISwipeGestureRecognizer.Direction.right :
                       pageControl.currentPage += 1
                    imageView.image =  imageGet[pageControl.currentPage]
                     break
               default:
                print("")
               }

           }

       }
    
    @objc func autoChange(){
        if autoNum == 2{
            autoNum = 0
        }
        pageControl.currentPage = autoNum
        imageView.image =  imageGet[pageControl.currentPage]
        autoNum += 1
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        imageView.image = imageGet[pageControl.currentPage]
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reserveBtn(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(identifier: "ReserveViewController") as! ReserveViewController
        VC.modalPresentationStyle = .fullScreen
        VC.stadiumName = self.detailTitle
        VC.stadiumKeyName = self.detailKeyName
        self.present(VC, animated: true, completion: nil)
    }
    
}
