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
    
    @IBOutlet weak var optionLabel1: UILabel!
    @IBOutlet weak var optionLabel2: UILabel!
    
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    let dateFormatter = DateFormatter()
    
    var stadiumName = ""
    var stadiumKeyName = ""
    
    var openTime = 0
    var closeTime = 0
    
    var alreadyTime:[Int] = []
    
    var stadiumPrice = 0
    var totalPrice = 0
    var equipmentPrice = 0
    var screenPrice = 0
    
    var selectTime: [Int] = []
    var selectTimeDB: [Int] = []
    
    var userUid = ""
    var userEmail = ""
    var userName = ""
    
    var year = ""
    var userSelectDay = ""
    var userSelectTime = ""
    
    var option1State = false
    var option2State = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        calendar.appearance.eventDefaultColor = UIColor.green
        calendar.appearance.eventSelectionColor = UIColor.green
        
        print("받아온 키 값: \(stadiumKeyName)")
        
        ServerDataLoad()
        
        self.year = DateToString(RE_Date: Date(),format: "YYYY")
        let today = DateToString(RE_Date: Date(),format: "MMdd")
        self.userSelectDay = today
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
                
                let price =  info!["price"] as! Int
                let equipmentPrice =  info!["equipmentPrice"] as! Int
                let screenPrice =  info!["screenPrice"] as! Int
                
                // Setting Price
                self.stadiumPrice = price
                self.equipmentPrice = equipmentPrice
                self.screenPrice = screenPrice
                self.optionLabel1.text = "장비대여 (+\(self.priceFormatter(number: self.equipmentPrice))원)"
                self.optionLabel2.text = "스크린 점수판 (+\(self.priceFormatter(number: self.screenPrice))원)"
             
                
                // 오픈 마감 시간
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
        
        
   //     let day = DateToString(RE_Date: Date(),format: "MMdd")
        print("특검 오늘의 년도는 \(year)")
        print("특검 오늘의 날짜는 \(day)")
        
        
        db.collection("Stadium").document(stadiumKeyName).collection("Reserve").document("Year-\(self.year)").collection("Day-\(day)").getDocuments { (querySnapshot, err) in
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
          
        
    func ReserveDataSave() {
     
        if Auth.auth().currentUser != nil {
          
            let user = Auth.auth().currentUser
            if let user = user {
          
              let uid = user.uid
              let email = user.email ?? ""
              let name = user.displayName ?? ""
                
                self.userUid = uid
                self.userEmail = email
                self.userName = name
            }
            
        } else {
          // No user is signed in.
          // ...
        }
        
        print("특검 유저 정보 \(self.userUid)")
     
        
        
        let userSelectTime = self.selectTime
        if userSelectTime.count > 0 {
            
           
            for time in userSelectTime {
               
                if userSelectTime.last != time {
                    self.userSelectTime  = self.userSelectTime + "\(self.openTime + time),"
                    self.selectTimeDB.append((self.openTime + time))
                } else {
                    self.userSelectTime  = self.userSelectTime + "\(self.openTime + time)"
                    self.selectTimeDB.append((self.openTime + time))
                }
            }
            
        let dayPath = self.year + self.userSelectDay + "-Time"+self.userSelectTime + "-" +  self.stadiumKeyName
     
            
        self.db.collection("Users").document(self.userUid).collection("Stadium").document("Reserve").collection("Data").document(dayPath).setData([
            "stadiumName": self.stadiumName,
            "reserveTime": "\(self.DateToString(RE_Date: Date()))",
            "totalPrice": self.totalPrice,
            "equipmentState": self.option1State,
            "screenState": self.option2State,
            "selectTime": self.selectTimeDB
          
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
                print("특검 선택시간 배열 \(self.selectTimeDB)")
                
                for selectTime in self.selectTimeDB {
                // 사용자 DB 성공 후
                self.db.collection("Stadium").document(self.stadiumKeyName).collection("Reserve").document("Year-\(self.year)").collection("Day-\(self.userSelectDay)").document("Time-\(selectTime)").setData([
                    "ClientName": self.userName,
                    "ClientEmail": self.userEmail,
                    "ClinetUid":self.userUid,
                    "equipmentState": self.option1State,
                    "screenState": self.option2State
                    
                ])
                
                }
                
                let alert = UIAlertController(title: "알림", message: "예약이 완료 되었습니다.", preferredStyle: .alert)
                                       alert.addAction(UIAlertAction(title: "확인", style: .default){
                                       UIAlertAction in
                                        self.dismiss(animated: true, completion: nil)
                                          
                                 })
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        } else{
            let alert = UIAlertController(title: "알림", message: "시간을 선택해주세요!", preferredStyle: .alert)
                                   alert.addAction(UIAlertAction(title: "확인", style: .default){
                                   UIAlertAction in
                                   
                                      
                             })
                            present(alert, animated: true, completion: nil)
        }
       // self.userSelectTime = ""
        
    }
    
    // 날짜 데이터 문자열로 변환
    func DateToString(RE_Date: Date) -> String {
        let date:Date = RE_Date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd:HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

    @IBAction func ReserveBtn(_ sender: Any) {
        self.ReserveDataSave()

    }
    
    
    @IBAction func cancleBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func optionBtn1(_ sender: Any) {
        optionBtn1.isSelected = !optionBtn1.isSelected
        
        if optionBtn1.isSelected == true {
            self.totalPrice = self.totalPrice + self.equipmentPrice
            self.option1State = true
        } else {
            self.totalPrice = self.totalPrice - self.equipmentPrice
            self.option1State = false
        }
        self.reserveBtn.setTitle("예약하기 ( +\(self.priceFormatter(number: self.totalPrice))원 )", for: .normal)
    }
    
    @IBAction func optionBtn2(_ sender: Any) {
        optionBtn2.isSelected = !optionBtn2.isSelected
        
        if optionBtn2.isSelected == true {
            self.totalPrice = self.totalPrice + self.screenPrice
            self.option2State = true
        } else {
            self.totalPrice = self.totalPrice - self.screenPrice
            self.option2State = false
        }
       
        self.reserveBtn.setTitle("예약하기 ( +\(self.priceFormatter(number: self.totalPrice))원 )", for: .normal)
    }
    
  
    // #숫자 단위 계산
    func priceFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
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
        let timeString = "\(time):00"
        cell.time.setTitle(timeString, for: .normal)
        
        
     
        if self.alreadyTime.count > 0 {
        
        for alreadyTime in self.alreadyTime {
        
            if time == alreadyTime {
             //  cell.time.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
                cell.time.setBackgroundImage(#imageLiteral(resourceName: "soldout"), for: .normal)
                cell.time.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
                cell.time.isEnabled = false
                break
            } else {
                cell.time.setBackgroundImage(.none, for: .normal)
                cell.time.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                cell.time.isEnabled = true
            }
        }
        } else {
            cell.time.setBackgroundImage(.none, for: .normal)
            cell.time.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            cell.time.isEnabled = true
        }
        
        
        
        
        if selectTime.count > 0 {
            
            for select in self.selectTime {
                if select == indexPath.row {
                    cell.time.setBackgroundImage(#imageLiteral(resourceName: "map_Pin"), for: .normal)
                    cell.time.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    
            
                }
        }
        }
        
        cell.time.tag = indexPath.row
        cell.time.addTarget(self, action: #selector(cellBtn), for: .touchUpInside)

   
        
         
        return cell
    }
    
    @objc func cellBtn(sender : UIButton){
       
        let index = sender.tag
        
       
        
        // 중복 값 제거
        let set = Set(self.selectTime)
        self.selectTime = Array(set)
        
        
        
        
        let indexCheck = self.selectTime.firstIndex(of: index)
        let indexInt = Int(indexCheck ?? 9999)
        
        if indexInt == 9999 {
            self.selectTime.append(sender.tag)
            self.totalPrice = self.totalPrice + self.stadiumPrice
        } else {
            self.selectTime.remove(at: indexInt)
            self.totalPrice = self.totalPrice - self.stadiumPrice
            
        }
     
      
        self.reserveBtn.setTitle("예약하기 ( +\(self.priceFormatter(number: self.totalPrice))원 )", for: .normal)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        self.userSelectDay = day
        // 초기화
        self.selectTime = []
        optionBtn1.isSelected = false
        optionBtn2.isSelected = false
        self.totalPrice = 0
        self.reserveBtn.setTitle("예약하기 ( +\(self.priceFormatter(number: self.totalPrice))원 )", for: .normal)
        
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
    




