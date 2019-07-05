//
//  ReviewCell.swift
//  BerlinTourReview
//
//  Created by Chandran, Sudha | SDTD on 04/07/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var reviewerNameLabel: UILabel!
    @IBOutlet weak var reviewMessageLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var revieweDateLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
