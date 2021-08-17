//
//  HomeViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/09.
//

import UIKit
import FSCalendar

class HomeViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    

    @IBOutlet weak var calendar: FSCalendar!

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var notiView: UIView!
    
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
        
    }
    
    deinit {
        print("\(#function)")
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
    

    

 
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
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
