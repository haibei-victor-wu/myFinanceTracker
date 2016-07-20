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
    @IBOutlet weak var indicatorLabel: UILabel!
    
    func setGroup(name: String, amount: Double, type: String)
    {
        groupNameLabel.text = name
        amountLabel.text = type == "expense" ? "$(\(amount))" : "$\(amount)"
        if name == "Salary" || name == "Clothing"
        {
            indicatorLabel.backgroundColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.3)
        } else if name == "Deposits" || name == "Transport"
        {
            indicatorLabel.backgroundColor = UIColor.init(red: 0, green: 1, blue: 0, alpha: 0.3)
        } else if name == "Rental" || name == "Entertainment"
        {
            indicatorLabel.backgroundColor = UIColor.init(red: 0, green: 0, blue: 1, alpha: 0.3)
        } else {
            indicatorLabel.backgroundColor = UIColor.init(red: 153/255, green: 102/255, blue: 51/255, alpha: 0.3)
        }
    }
    
}
