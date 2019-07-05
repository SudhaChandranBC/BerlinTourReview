//
//  API.swift
//  BerlinTourReview
//
//  Created by Chandran, Sudha | SDTD on 04/07/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import Alamofire

class ReviewAPI {
    
    // MARK: - Properties
    var alamofireManager = Alamofire.SessionManager()
    var selectedReviewOptions = ReviewAPIOptions()
    
    // MARK: - Shared Instance
    static let sharedInstance : ReviewAPI = {
        let instance = ReviewAPI()
        return instance
    }()
    
    // MARK: - Initialization
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 5
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    /// Function used to load reviews with other sort options of the function.
    /// - parameters:
    ///     - results: Array of review items from API
    ///     - error: Any error from API
    /// - Returns: A completion block which gives a response which contains array of reviews
    /// results and error from API
    func loadReviews(completion : @escaping (_ results: ReviewResponse?, _ error : NSError?) -> Void) {
        
        guard reviewUrl() != nil else {
            let APIError = NSError(domain: ErrorConstants.ErrorDomain, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:ErrorConstants.WrongAPIUrl])
            completion(nil, APIError)
            return
        }
        
        let urlString = reviewUrl()!
        Alamofire.request(urlString).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let reviewResponse = try decoder.decode(ReviewResponse.self, from: data)
                if reviewResponse.status == true {
                    completion(reviewResponse, nil)
                } else {
                    let APIError = NSError(domain: ErrorConstants.ErrorDomain, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:reviewResponse.message ?? ErrorConstants.NoDataFound])
                    completion(reviewResponse, APIError)
                }
                
            } catch let error {
                print(error)
                let APIError = NSError(domain: ErrorConstants.ErrorDomain, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:ErrorConstants.NoDataFound])
                completion(nil, APIError)
                return
            }
        }
    }
    
    /// Function which process the url options and returns the final URL for API
    /// - Returns: An Opional URL which is formed from all the url options
    internal func reviewUrl() -> URL? {
        var parameters: [String:Any] = [:]
        let reviewOptions = selectedReviewOptions
        parameters[ReviewAPIParameterKeys.Count] = reviewOptions.count
        parameters[ReviewAPIParameterKeys.Page] = reviewOptions.page
        
        parameters[ReviewAPIParameterKeys.Rating] = reviewOptions.rating
        parameters[ReviewAPIParameterKeys.Direction] = reviewOptions.direction
        if (reviewOptions.sortBy != nil) {
            parameters[ReviewAPIParameterKeys.SortBy] = reviewOptions.sortBy
        }
        
        let URLString = "\(ReviewAPIConstants.APIBaseURL)\(escapedParameters(parameters))"
        
        if let url = URL(string:URLString) {
            return url
        }
        
        return nil
    }
    
    /// Function which process the parameters ad does ASCII Encoding formatting
    /// - parameters:
    ///     - parameters: Dictionary of type [String:Any]
    /// - Returns: ASCII encoded string
    internal func escapedParameters(_ parameters: [String:Any]) -> String {
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                let stringValue = "\(value)"
                
                let generalDelimitersToEncode = ":#[]@"
                let subDelimitersToEncode = "!$&'()*+,;="
                
                var allowedCharacterSet = CharacterSet.urlQueryAllowed
                allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
                
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
                
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
                
            }
            
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
}
