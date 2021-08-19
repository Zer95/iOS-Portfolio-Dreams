//
//  HomeViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/09.
//

import UIKit
import FSCalendar
import Firebase

class HomeViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    

    @IBOutlet weak var calendar: FSCalendar!

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var notiView: UIView!
    
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    var userUid = ""
    var userReserveCnt = 0
    
    var titleTemp: [String] = []
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
   
          //  navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notiView.layer.borderWidth = 0.5
        notiView.layer.borderColor =  #colorLiteral(red: 0.9122878909, green: 0.9124409556, blue: 0.9122678041, alpha: 1)
        
    
        
        
        collectionView.backgroundView = UIImageView(image: UIImage(named: "back1"))
        
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
    //    self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
        
        UserDataLoad()
    }
    
    deinit {
        print("\(#function)")
    }
    
    
    func UserDataLoad() {
        
        
        if Auth.auth().currentUser != nil {
          
            let user = Auth.auth().currentUser
            if let user = user {
              // The user's ID, unique to the Firebase project.
              // Do NOT use this value to authenticate with your backend server,
              // if you have one. Use getTokenWithCompletion:completion: instead.
              let uid = user.uid
       
                
              var multiFactorString = "MultiFactor: "
              for info in user.multiFactor.enrolledFactors {
                multiFactorString += info.displayName ?? "[DispayName]"
                multiFactorString += " "
              }
            
                self.userUid = uid
            }
            
        } else {
          // No user is signed in.
          // ...
        }

        print("정보: \(self.userUid)")
        
        let year = DateToString(RE_Date: Date(),format: "YYYY")
        
        db.collection("Users").document(self.userUid).collection("Stadium").document("Reserve").collection("Data").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.userReserveCnt = querySnapshot!.documents.count
                
                for document in querySnapshot!.documents {
                    print("정보 \(document.documentID) => \(document.data())")
                    let info = document.data()
                    guard let title = info["title"] as? String else {return}
                    self.titleTemp.append(title)
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
    }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    

    func DateToString(RE_Date: Date, format: String) -> String {
        let date:Date = RE_Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

 
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userReserveCnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollcectionCell", for: indexPath) as? homeCollcectionCell else {
            return UICollectionViewCell()
        }
        cell.allView.layer.cornerRadius = 10
        cell.allView.layer.borderWidth = 1.0
        cell.allView.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.allView.layer.shadowColor = UIColor.black.cgColor
        cell.allView.layer.shadowOffset = CGSize(width: 1 , height: 1)
        cell.allView.layer.shadowOpacity = 0.5
        cell.allView.layer.shadowRadius = 4.0
        
        cell.title.text = self.titleTemp[indexPath.row]
        
        return cell
    }
    
 
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 40, left: 0, bottom: 10, right: 0)
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 370, height: 250)
}

}
class homeCollcectionCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var allView: UIView!
    
    
}
