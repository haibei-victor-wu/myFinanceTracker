//
//  TransactionDetailViewCell.swift
//  Final Project myFinanceTracker
//
//  Created by Haibei Wu on 2016-07-17.
//  Copyright © 2016 cs2680. All rights reserved.
//

import Foundation
import UIKit

class TransactionDetailViewCell: UITableViewCell
{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    func setDetail(date: String, amount: Double, type: String)
    {
        dateLabel.text = date
        amountLabel.text = type == "expense" ? "$(\(amount))" : "$\(amount)"
    }
}