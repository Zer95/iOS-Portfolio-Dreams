//
//  AgreeViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/04.
//

import UIKit
import Firebase

class AgreeViewController: UIViewController {

    var receiveCode = 999
    var ref: DatabaseReference!
    let db = Firestore.firestore()

    @IBOutlet weak var agreeTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

    
        self.navigationController?.navigationBar.topItem?.title = ""

        
        db.collection("Agree").getDocuments() { (querySnapshot, err) in
            if let err = err {
            print("Error getting documents: \(err)")
            } else {
                
                let info = querySnapshot!.documents[self.receiveCode].data()
                
                guard let title = info["Title"] else {return}
                guard let content = info["Content"] else {return}
                                          
                self.navigationItem.title = "\(title)"
                self.agreeTextView.text = "\(content)"

             }
            }
    }
}
