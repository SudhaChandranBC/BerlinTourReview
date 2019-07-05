//
//  Review.swift
//  BerlinTourReview
//
//  Created by Chandran, Sudha | SDTD on 04/07/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import Foundation

struct Review: Codable {
    
    let id: Int?
    let rating: String?
    let message: String?
    let name: String?
    let reviewDate: String?

    private enum CodingKeys: String, CodingKey {
        case id = "review_id"
        case rating = "rating"
        case message = "message"
        case name = "reviewerName"
        case reviewDate = "date"
    }
    
}
