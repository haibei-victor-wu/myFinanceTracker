//
//  CategoryTableViewCell.swift
//  Final Project myFinanceTracker
//
//  Created by Haibei Wu on 2016-07-17.
//  Copyright © 2016 cs2680. All rights reserved.
//

import Foundation
import UIKit

class CategoryTableViewCell: UITableViewCell
{
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    func setGroup(name: String, amount: Double, type: String)
    {
        groupNameLabel.text = name
        amountLabel.text = type == "expense" ? "$(\(amount))" : "$\(amount)"
    }
    
}
