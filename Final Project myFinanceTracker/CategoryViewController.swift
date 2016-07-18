//
//  CategoryViewController.swift
//  Final Project myFinanceTracker
//
//  Created by Haibei Wu on 2016-07-17.
//  Copyright © 2016 cs2680. All rights reserved.
//

import Foundation
import UIKit

class CategoryViewController: UITableViewController
{
    var group: Array<String>!
    var groupData: Array<CashFlow>!
    var type: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData(self.type)
        self.tableView.reloadData()
    }
    
    func loadData(type:String) {
        self.type = type
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let cashFlowService = CashFlowService(context: context)
        
        if(type == "income") {
            group = ["Salary", "Deposits", "Rental", "Other Income"]
            let predicate1 = NSPredicate(format: "type == %@", "1")
            groupData = cashFlowService.get(withPredicate: predicate1)
        } else {
            group = ["Clothing", "Transport", "Entertainment", "Dining"]
            let predicate1 = NSPredicate(format: "type == %@", "0")
            groupData = cashFlowService.get(withPredicate: predicate1)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("category") as! CategoryTableViewCell
        let categoryName = group[indexPath.row]
        let categoryAmount = getGroupAmount(categoryName)
        cell.setGroup(categoryName, amount: categoryAmount, type: self.type)
        return cell
    }
    
    func getGroupAmount(name:String) -> Double{
        var amount = 0.0
        for i in 0 ..< groupData.count {
            if (groupData[i].category == name){
                amount = amount + Double(groupData[i].amount!)
            }
        }
        return amount
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let transactionTableView = segue.destinationViewController as! TransactionDetailTableViewController
        let cellIndexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)!
        let groupName = group[cellIndexPath.row]
        transactionTableView.loadData(groupName, type: self.type)

    }
}