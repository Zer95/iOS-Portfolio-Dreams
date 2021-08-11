//
//  DetailStadiumViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/11.
//

import UIKit

class DetailStadiumViewController: UIViewController {
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
  
    @IBOutlet weak var stadiumTitleLabel: UILabel!
    
    
    var images = ["baseball1.jpg","baseball2.jpg","baseball3.jpg"]
    var timer = Timer()
    var autoNum:Int = 1
    
   
    var detailTitle: String!
    
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

        
        stadiumTitleLabel.text = detailTitle
        
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imageView.image = UIImage(named: String(images[0]))
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(autoChange), userInfo: nil, repeats: true)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(DetailStadiumViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(DetailStadiumViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    // 한 손가락 스와이프 제스쳐를 행했을 때 실행할 액션 메서드
       @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
           // 만일 제스쳐가 있다면
           if let swipeGesture = gesture as? UISwipeGestureRecognizer{
               
               // 발생한 이벤트가 각 방향의 스와이프 이벤트라면
               // pageControl이 가르키는 현재 페이지에 해당하는 이미지를 imageView에 할당
               switch swipeGesture.direction {
                   case UISwipeGestureRecognizer.Direction.left :
                       pageControl.currentPage -= 1
                    imageView.image = UIImage(named: images[pageControl.currentPage])
                   case UISwipeGestureRecognizer.Direction.right :
                       pageControl.currentPage += 1
                    imageView.image = UIImage(named: images[pageControl.currentPage])
                   default:
                     break
               }

           }

       }
    
    @objc func autoChange(){
        if autoNum == 2{
            autoNum = 0
        }
        pageControl.currentPage = autoNum
        imageView.image = UIImage(named: String(images[autoNum]))
        autoNum += 1
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        imageView.image = UIImage(named: images[pageControl.currentPage])
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}
