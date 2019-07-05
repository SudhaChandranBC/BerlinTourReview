//
//  ViewController.swift
//  BerlinTourReview
//
//  Created by Chandran, Sudha | SDTD on 04/07/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import UIKit
import SVProgressHUD

class ReviewViewController: UIViewController {

    // MARK: - Properties
    var currentPage = 1
    var totalPages = 0
    var totalItems = 0
    var maxPages = 0
    var reviewItems = [Review]()
    @IBOutlet weak var tableView: UITableView!

    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSortOptions" {
            let controller = segue.destination as! SortViewController
            controller.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        getReviewItems()
        self.currentPage = (ReviewAPI.sharedInstance.selectedReviewOptions.page)
        tableView.prefetchDataSource = self
    }

    
    // MARK: - Methods
    /// Function which call Review API and fetch the results.
    fileprivate func getReviewItems() {
        ReviewAPI.sharedInstance.loadReviews() {
            response, error in
            
            if error != nil {
                SVProgressHUD.dismiss()
                self.showErrorAlert(errorInfo: error!)
                return
            }
            
            if let reviewResponse = response {
                self.currentPage = ReviewAPI.sharedInstance.selectedReviewOptions.page
                if self.currentPage == 1 {
                    self.totalItems = reviewResponse.total_reviews_comments
                    self.maxPages = reviewResponse.total_reviews_comments / 20
                }
                self.tableView.isUserInteractionEnabled = true
                self.reviewItems.append(contentsOf: reviewResponse.data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            }
        }
    }

    
    /// Function which display Alert of API Errors
    /// - parameters:
    ///     - errorInfo: NSError instance
    private func showErrorAlert(errorInfo: NSError)  {
        let alert = UIAlertController(title: "Error \(errorInfo.code)", message: errorInfo.userInfo[NSLocalizedFailureReasonErrorKey] as! String?, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: ErrorConstants.OkActionText, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - UITableView Data Source
extension ReviewViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((self.currentPage == self.maxPages
            || self.currentPage == self.totalPages
            || self.totalItems == self.reviewItems.count) && (self.reviewItems.count > 0)) {
            return self.reviewItems.count;
        }
        return self.reviewItems.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row != self.reviewItems.count) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            
            if reviewItems.count > 0 {
                let  item = reviewItems[indexPath.row]
                cell.reviewerNameLabel.text = String(item.name!)
                cell.revieweDateLabel.text = String(item.reviewDate!)
                let stars = String(repeating: "★ ", count: Int(Float(item.rating!)!) )
                cell.ratingLabel.text = "\(item.rating!):\(stars)"
                cell.reviewMessageLabel.text = item.message

            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
        if reviewItems.count == 0 {
            cell.textLabel?.text = "Sorry no items found!"
        }
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension ReviewViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print(indexPaths)
        for indexPath in indexPaths {
            if currentPage != maxPages && indexPath.row == reviewItems.count - 1 {
                SVProgressHUD.show()
                tableView.isUserInteractionEnabled = false
                ReviewAPI.sharedInstance.selectedReviewOptions.page = currentPage + 1
                self.getReviewItems()
            }
        }
    }
}

// MARK: - SortViewControllerProtocol
extension ReviewViewController: SortViewControllerProtocol {
    
    func didSelectSortOption()
    {
        _ = self.navigationController?.popViewController(animated: true)
        reviewItems.removeAll()
        SVProgressHUD.show()
        self.getReviewItems()
    }
}
