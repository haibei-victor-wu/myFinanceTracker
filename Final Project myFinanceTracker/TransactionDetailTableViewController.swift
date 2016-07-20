//
//  TransactionDetailTableViewController.swift
//  Final Project myFinanceTracker
//
//  Created by Haibei Wu on 2016-07-17.
//  Copyright © 2016 cs2680. All rights reserved.
//

import Foundation
import UIKit

class TransactionDetailTableViewController: UITableViewController
{
    var groupData: Array<CashFlow>!
    var type: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.getBackgroundColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    func loadData(category: String, type: String) {
        self.type = type
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let cashFlowService = CashFlowService(context: context)
        
        let predicate = NSPredicate(format: "category == %@", category)
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        groupData = cashFlowService.getWithSort(withPredicate: predicate, withSortDescriptor: sortDescriptor)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupData.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detail") as! TransactionDetailViewCell
        
        let cashFlow = groupData[indexPath.row]
        
        cell.setDetail(cashFlow.date!, amount: Double(cashFlow.amount!), type: self.type)
        
        cell.backgroundColor = UIColor.getBackgroundColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            let cashFlow = groupData[indexPath.row]
            let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            let cashFlowService = CashFlowService(context: context)
            cashFlowService.delete(cashFlow.objectID)
            groupData.removeAtIndex(indexPath.row)
            do
            {
                try context.save()
            } catch _ {
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}