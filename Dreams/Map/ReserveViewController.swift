//
//  ReserveViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/13.
//

import UIKit
import FSCalendar
import Firebase

class ReserveViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var stadiumTitle: UILabel!
    
    @IBOutlet weak var reserveBtn: UIButton!
    @IBOutlet weak var optionBtn1: UIButton!
    @IBOutlet weak var optionBtn2: UIButton!
    
    
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    let dateFormatter = DateFormatter()
    
    var stadiumName = ""
    var stadiumKeyName = ""
    
    var openTime = 0
    var closeTime = 0
    
    var alreadyTime:[Int] = []
    
    var totalPrice = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        calendar.appearance.eventDefaultColor = UIColor.green
        calendar.appearance.eventSelectionColor = UIColor.green
        
        print("받아온 키 값: \(stadiumKeyName)")
        ServerDataLoad()
        
        let today = DateToString(RE_Date: Date(),format: "MMdd")
        dayDataLoad(day: today)
    }
    
    func ServerDataLoad() {
        db.collection("Stadium").document(stadiumKeyName).getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
           
                let info = querySnapshot?.data()
           //   print("특검 해당하는 데이터 값 : \(info)")
                let title = info!["title"] as! String
                let adress = info!["Address"] as! String
                self.stadiumTitle.text = "예약장소: " + title + "(" + adress + ")"
                
                let openCloseTime = info!["openCloseTime"] as! [Int]
                print(" 오픈마감 시간  : \(openCloseTime)")
                self.openTime = openCloseTime[0]
                self.closeTime = openCloseTime[1]
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                 
                }
                
                   }
            }
    }
    
    func dayDataLoad(day: String) {
        
        self.alreadyTime = []
        
        let year = DateToString(RE_Date: Date(),format: "YYYY")
   //     let day = DateToString(RE_Date: Date(),format: "MMdd")
        print("특검 오늘의 년도는 \(year)")
        print("특검 오늘의 날짜는 \(day)")
        
        db.collection("Stadium").document(stadiumKeyName).collection("Reserve").document("Year-\(year)").collection("Day-\(day)").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("특검 \(document.documentID) => \(document.data())")
                    
                    let key = document.documentID
                    let arr =  key.components(separatedBy: "-")
                    let time = Int(arr.last ?? "") ?? 0
                    print("특검 추출 \(time)")
                    
                    self.alreadyTime.append(time)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
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
          
        
       
    
    

    @IBAction func ReserveBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancleBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func optionBtn1(_ sender: Any) {
        optionBtn1.isSelected = !optionBtn1.isSelected
        
        if optionBtn1.isSelected == true {
            self.totalPrice = self.totalPrice + 10000
        } else {
            self.totalPrice = self.totalPrice - 10000
        }
        self.reserveBtn.setTitle("예약하기 (+\(self.totalPrice))", for: .normal)
    }
    
    @IBAction func optionBtn2(_ sender: Any) {
        optionBtn2.isSelected = !optionBtn2.isSelected
        
        if optionBtn2.isSelected == true {
            self.totalPrice = self.totalPrice + 15000
        } else {
            self.totalPrice = self.totalPrice - 15000
        }
        self.reserveBtn.setTitle("예약하기 (+\(self.totalPrice))", for: .normal)
    }
    
    
}


extension ReserveViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let timeCnt = self.closeTime - self.openTime
        
        return timeCnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeSelectCell", for: indexPath) as? timeSelectCell else {
            return UICollectionViewCell()
    }
        cell.time.layer.cornerRadius = 10
        cell.time.layer.borderWidth = 1.0
        cell.time.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        let time = self.openTime + indexPath.row
        
        
        cell.time.setTitle("\(time):00", for: .normal)
        
        
     
        if self.alreadyTime.count > 0 {
        
        for alreadyTime in self.alreadyTime {
        
            if time == alreadyTime {
             //  cell.time.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
                cell.time.setBackgroundImage(#imageLiteral(resourceName: "soldout"), for: .normal)
                cell.time.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
                break
            } else {
                cell.time.setBackgroundImage(.none, for: .normal)
                cell.time.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            }
        }
        } else {
            cell.time.setBackgroundImage(.none, for: .normal)
            cell.time.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        }
         
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: 90, height: 40)
    }
    
}

extension ReserveViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let day = DateToString(RE_Date: date,format: "MMdd")
        dayDataLoad(day: day)
        print("특검" + day + " 선택됨")
    }
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
       // print("특검" + dateFormatter.string(from: date) + " 해제됨")
    }
   
}


class timeSelectCell: UICollectionViewCell {
    @IBOutlet weak var time:UIButton!
    
}
    
  



