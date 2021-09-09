//
//  StadiumTableViewCell.swift
//  Dreams
//
//  Created by SG on 2021/08/11.
//

import UIKit

class StadiumTableViewCell: UITableViewCell {
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Address: UILabel!
    
    @IBOutlet weak var Thumbnail: UIImageView!
    @IBOutlet weak var Thumbnail2: UIImageView!
    @IBOutlet weak var Thumbnail3: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib() // view 로드전에 실행

    
    }
    
  
}
