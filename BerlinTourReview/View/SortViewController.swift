//
//  SortViewController.swift
//  BerlinTourReview
//
//  Created by Chandran, Sudha | SDTD on 04/07/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import UIKit

// MARK: - Protocol SortViewControllerProtocol definition
/// A protocol which helps to delegate the selcted sort option to the parent viewcontrollers
protocol SortViewControllerProtocol: class {
    
    /// This method delegates to the called viewcontroller and send sort option selected.
    /// - parameters:
    ///     - sender: Instance of SortViewController
    ///     - sortedResults: Array of items fetch from ItemSeachAPI according to sort option
    /// selected
    ///     - selectedSortOption: SortOptions value selected
    func didSelectSortOption()
}

class SortViewController: UITableViewController {
    var lastSelectedRating = ReviewAPI.sharedInstance.selectedReviewOptions.rating;
    var lastSelectedSortBy = ReviewAPI.sharedInstance.selectedReviewOptions.sortBy == SortBy.reviewDate.rawValue ? 0 : 1;
    var lastSelectedDirection = ReviewAPI.sharedInstance.selectedReviewOptions.direction == SortDirection.asc.rawValue ? 0 : 1;
    weak var delegate:SortViewControllerProtocol?

    
    override func viewDidLoad() {
        tableView.selectRow(at: IndexPath(row: lastSelectedRating, section: 0), animated: false, scrollPosition: .none)
        tableView.selectRow(at: IndexPath(row: lastSelectedSortBy, section: 1), animated: false, scrollPosition: .none)
        tableView.selectRow(at: IndexPath(row: lastSelectedDirection, section: 2), animated: false, scrollPosition: .none)

        self.tableView.cellForRow(at: IndexPath(row: lastSelectedRating, section: 0))?.accessoryType = .checkmark
        self.tableView.cellForRow(at: IndexPath(row: lastSelectedSortBy, section: 1))?.accessoryType = .checkmark
        self.tableView.cellForRow(at: IndexPath(row: lastSelectedDirection, section: 2))?.accessoryType = .checkmark

    }

    @IBAction func doneButtonClicked(_ sender: Any) {
        ReviewAPI.sharedInstance.selectedReviewOptions.rating = lastSelectedRating
        ReviewAPI.sharedInstance.selectedReviewOptions.sortBy = (lastSelectedSortBy == 0) ? SortBy.reviewDate.rawValue : SortBy.rating.rawValue
        ReviewAPI.sharedInstance.selectedReviewOptions.direction = (lastSelectedDirection == 0) ? SortDirection.asc.rawValue : SortDirection.desc.rawValue
        
        self.delegate?.didSelectSortOption()
    }
}


// MARK: - UITableView Data Source
extension SortViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      print("select")
        switch indexPath.section {
        case 0:
            tableView.cellForRow(at: IndexPath(row: lastSelectedRating, section: indexPath.section))?.accessoryType = .none
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            lastSelectedRating = indexPath.row
        case 1:
            tableView.cellForRow(at: IndexPath(row: lastSelectedSortBy, section: indexPath.section))?.accessoryType = .none
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            lastSelectedSortBy = indexPath.row
        case 2:
            tableView.cellForRow(at: IndexPath(row: lastSelectedDirection, section: indexPath.section))?.accessoryType = .none
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            lastSelectedDirection = indexPath.row
        default: break
        }
    }
  
}
