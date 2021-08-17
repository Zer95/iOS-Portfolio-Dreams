//
//  ReserveViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/13.
//

import UIKit
import FSCalendar

class ReserveViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.appearance.eventDefaultColor = UIColor.green
        calendar.appearance.eventSelectionColor = UIColor.green
        

        
    }
    

    @IBAction func ReserveBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancleBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


