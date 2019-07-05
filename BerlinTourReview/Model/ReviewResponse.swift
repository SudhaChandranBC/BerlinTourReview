//
//  ReviewResponse.swift
//  BerlinTourReview
//
//  Created by Chandran, Sudha | SDTD on 04/07/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import Foundation

struct ReviewResponse: Codable {
    let status: Bool
    let total_reviews_comments: Int
    let data: [Review]
    let message: String?

}
