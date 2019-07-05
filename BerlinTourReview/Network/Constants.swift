//
//  Constants.swift
//  BerlinTourReview
//
//  Created by Chandran, Sudha | SDTD on 04/07/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import Foundation

/// A enum consists of sort from options
enum SortBy: String {
    case reviewDate = "date_of_review"
    case rating = "rating"
}

/// An enum consists of sort direction options
enum SortDirection: String {
    case asc = "asc"
    case desc = "desc"
}

/// A structure consists of App constants
struct ReviewAPIConstants {
    static let APIBaseURL = "https://www.getyourguide.com/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/reviews.json"
    static let ApplicationId = "1088449601673680377"
    static let ResponseFormat = "json"
    static let FormatVersion = "2"
}

/// A structure consists of Review API parameter options
struct ReviewAPIOptions {
    var count = 20
    var page = 1
    var rating = 0
    var direction = SortDirection.asc.rawValue
    
    var sortOptionChanged = false
    var sortBy: String? {
        didSet {
            if oldValue != sortBy {
                self.sortOptionChanged = true
                self.page = 1
            } else {
                self.sortOptionChanged = false
            }
        }
    }
}

/// A structure consists of Review API parameter keys
struct ReviewAPIParameterKeys {
    static let Count = "count"
    static let Page = "page"
    static let Rating = "rating"
    static let SortBy = "sortBy"
    static let Direction = "direction"
}

/// A Structure consists of Error constants
struct ErrorConstants {
    static let ErrorDomain = "Review API"
    static let WrongAPIUrl = "API url is wrong!"
    static let NoDataFound = "Could not find data for the requested tour."
    static let OkActionText = "Ok"
}
