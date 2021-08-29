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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var noticeLabel: UILabel!
    
    let stringValue = StringValue()
    
    var images = ["banner4.png","banner3.png"]
    var notices = ["공지사항 안내",""]
    var timer = Timer()
    var autoNum:Int = 1
    
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    let userReserveDataModel = UserReserveDataModel()
    
 //   var UserReserveData: [(stadiumName: String, reserveTime: String, totalPrice: Int, equipmentState: Bool, screenState: Bool, selectTime:[Int])]! = []
    
    var userUid = ""
    var userReserveCnt = 0
    
    
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
   
        self.readServerNotice()
          //  navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notiView.layer.borderWidth = 0.5
        notiView.layer.borderColor =  #colorLiteral(red: 0.9122878909, green: 0.9124409556, blue: 0.9122678041, alpha: 1)
        
    
        imagePageControl()
        
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
    

    func readServerNotice() {
        db.collection("Setting").document("Notice").getDocument() { (querySnapshot, err) in
            if let err = err {
            print("Error getting documents: \(err)")
            } else {
                
                let info = querySnapshot!
                
                guard let noti1 = info["Noti1"] else {return}
                guard let noti2 = info["Noti2"] else {return}
                self.notices[0] = "\(noti1)"
                self.notices[1] = "\(noti2)"
              

             }
    }
    }
    func imagePageControl() {
        pageControl.numberOfPages = 2
        pageControl.currentPage = 1
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imageView.image = UIImage(named: String(images[0]))
        noticeLabel.text = notices[0]
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(autoChange), userInfo: nil, repeats: true)
      
    }
    
 
    @objc func autoChange(){
        if autoNum == 2{
            autoNum = 0
        }
        pageControl.currentPage = autoNum
        imageView.image = UIImage(named: String(images[autoNum]))
        noticeLabel.text = notices[autoNum]
        autoNum += 1
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        imageView.image = UIImage(named: images[pageControl.currentPage])
    }
    
    func UserDataLoad() {
        
        
        if Auth.auth().currentUser != nil {
          
            let user = Auth.auth().currentUser
            if let user = user {
        
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

        print("[Log]: \(self.userUid)")
        
        
        db.collection("Users").document(self.userUid).collection("Stadium").document("Reserve").collection("Data").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("[Log] Error getting documents: \(err)")
            } else {
                self.userReserveCnt = querySnapshot!.documents.count
                print("[Log] Read 개수: \(querySnapshot!.documents.count)")
                for document in querySnapshot!.documents {
                    
                  //  print("[Log] \(document.documentID) => \(document.data())")
                    
                    let info = document.data()
                    let stadiumName = info["stadiumName"] as? String ?? ""
                    let reserveTime = info["reserveTime"] as? String  ?? ""
                    let totalPrice = info["totalPrice"] as? Int ?? 0
                    let equipmentState = info["equipmentState"] as? Bool ?? false
                    let screenState = info["screenState"] as? Bool ?? false
                    let selectTime = info["selectTime"] as? [Int] ?? []
                    print("[Log] 셀렉 배열 \(selectTime)")
                    self.userReserveDataModel.userReserveDataList.append(UserReserveInfo(stadiumName: stadiumName, reserveTime: reserveTime, totalPrice: totalPrice, equipmentState: equipmentState, screenState: screenState, selectTime: selectTime))
                    
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
    }
    }
    
    func UserSelectDataLoad(day: String) {
        
        let year = DateToString(RE_Date: Date(),format: "YYYY")

        let queryDate = year + day
        
        if Auth.auth().currentUser != nil {
          
            let user = Auth.auth().currentUser
            if let user = user {
            
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

        print("[Log] 쿼리데이터  \(queryDate)")
        
        
        db.collection("Users").document(self.userUid).collection("Stadium").document("Reserve").collection("Data").whereField("date",isEqualTo: queryDate).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("[Log] Error getting documents: \(err)")
            } else {
                self.userReserveCnt = querySnapshot!.documents.count
                print("[Log] Read 개수: \(querySnapshot!.documents.count)")
                for document in querySnapshot!.documents {
                    
                  //  print("[Log] \(document.documentID) => \(document.data())")
                    
                    let info = document.data()
                    let stadiumName = info["stadiumName"] as? String ?? ""
                    let reserveTime = info["reserveTime"] as? String  ?? ""
                    let totalPrice = info["totalPrice"] as? Int ?? 0
                    let equipmentState = info["equipmentState"] as? Bool ?? false
                    let screenState = info["screenState"] as? Bool ?? false
                    let selectTime = info["selectTime"] as? [Int] ?? []
                    print("[Log] 셀렉 배열 \(selectTime)")
                    self.userReserveDataModel.userReserveDataList.append(UserReserveInfo(stadiumName: stadiumName, reserveTime: reserveTime, totalPrice: totalPrice, equipmentState: equipmentState, screenState: screenState, selectTime: selectTime))
                    
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
    }
    }
    
    func DateToString(RE_Date: Date, format: String) -> String {
        let date:Date = RE_Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    
    // MARK: - Calendar
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        // 초기화 필수
        self.userReserveDataModel.userReserveDataList = []
        
        let day = DateToString(RE_Date: date,format: "MMdd")
        print("[Log] 선택된 날짜는 \(day)")
        self.UserSelectDataLoad(day: day)
        self.calendar.setScope(.week, animated: true)
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    

  

 
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.userReserveCnt == 0 {
            collectionView.backgroundView = UIImageView(image: UIImage(named: "back2"))
        } else {
            collectionView.backgroundView = UIImageView(image: UIImage(named: "back1"))
        }
        
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
        
        let CheckData = userReserveDataModel.userReserveDataList[indexPath.row]
        cell.stadiumName.text = userReserveDataModel.userReserveDataList[indexPath.row].stadiumName
        cell.selectTime.text = "예약시간: \(userReserveDataModel.userReserveDataList[indexPath.row].selectTime)"
        cell.totalPrice.text = "결제금액: \(userReserveDataModel.userReserveDataList[indexPath.row].totalPrice)"
        cell.equipmentState.text = "장비대여: \(userReserveDataModel.userReserveDataList[indexPath.row].equipmentState)"
        cell.screenState.text = "스크린 전광판: \(userReserveDataModel.userReserveDataList[indexPath.row].screenState)"
        cell.reserveTime.text = "예약 일시: \(userReserveDataModel.userReserveDataList[indexPath.row].reserveTime)"
        
        print("[Log] MVVM Check : \(CheckData)")
        
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
    @IBOutlet weak var allView: UIView!
    
    @IBOutlet weak var stadiumName: UILabel!
    @IBOutlet weak var selectTime: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var equipmentState: UILabel!
    @IBOutlet weak var screenState: UILabel!
    
    @IBOutlet weak var reserveTime: UILabel!
    
    
}


class UserReserveDataModel {
    
    var userReserveDataList: [UserReserveInfo] = []
    
    var numOfDataList: Int {
        return userReserveDataList.count
    }
    
    func userReserveInfo(at index: Int) -> UserReserveInfo {
        return userReserveDataList[index]
    }
}
