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
    
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    let dateFormatter = DateFormatter()
    
    var stadiumName = ""
    var stadiumKeyName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        calendar.appearance.eventDefaultColor = UIColor.green
        calendar.appearance.eventSelectionColor = UIColor.green
        
        print("받아온 키 값: \(stadiumKeyName)")
        ServerDataLoad()
        
        let today = DateToString(RE_Date: Date())
        print("특검 오늘의 날짜는 \(today)")
    }
    
    func ServerDataLoad() {
        db.collection("Stadium").document(stadiumKeyName).getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
           
                let info = querySnapshot?.data()
                  print("특검 해당하는 데이터 값 : \(info)")
                let title = info!["title"] as! String
                let adress = info!["Address"] as! String
                self.stadiumTitle.text = "예약장소: " + title + "(" + adress + ")"
                
                   }
            }
    }
      
    func DateToString(RE_Date: Date) -> String {
        let date:Date = RE_Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMdd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
          
        
       
    
    

    @IBAction func ReserveBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancleBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension ReserveViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeSelectCell", for: indexPath) as? timeSelectCell else {
            return UICollectionViewCell()
    }
        cell.time.layer.cornerRadius = 10
        cell.time.layer.borderWidth = 1.0
        cell.time.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        
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
        print(dateFormatter.string(from: date) + " 선택됨")
    }
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(dateFormatter.string(from: date) + " 해제됨")
    }
   
}


class timeSelectCell: UICollectionViewCell {
    @IBOutlet weak var time:UIButton!
    
}
    
  



