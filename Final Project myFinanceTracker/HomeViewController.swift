//
//  HomeViewController.swift
//  Final Project myFinanceTracker
//
//  Created by Haibei Wu on 2016-07-11.
//  Copyright © 2016 cs2680. All rights reserved.
//

import Foundation
import UIKit
import Charts
import CoreData

class HomeViewController: UITableViewController
{
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!

    
    let greyColor:UIColor = UIColor.init(red: 52/255, green: 74/255.0, blue: 95/255.0, alpha: 1.0)
    var categories: Array<String>!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        load()
    }
    
    func load()
    {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let cashFlowService = CashFlowService(context: context)
        
        let predicate1 = NSPredicate(format: "type == %@", "1")
        let allIncomes = cashFlowService.get(withPredicate: predicate1)
        let allIncomesAmount = sumAmountByGroup(allIncomes)
        
        let predicate2 = NSPredicate(format: "type == %@", "0")
        let allExpenses = cashFlowService.get(withPredicate: predicate2)
        let allExpensesAmount = sumAmountByGroup(allExpenses)
        
        let totalAmount = allIncomesAmount + allExpensesAmount
        
        balanceLabel.text = allIncomesAmount > allExpensesAmount ? "$\(allIncomesAmount - allExpensesAmount)" : "($\(allExpensesAmount - allIncomesAmount))"
        
        incomeLabel.text = "\(allIncomesAmount)"
        expenseLabel.text = "(\(allExpensesAmount))"
        
        if (totalAmount > 0) {
            let incomePercentage = allIncomesAmount / totalAmount
            let expensePercentage = allExpensesAmount / totalAmount
            
            categories = ["Income", "Expense"]
            let amounts = [incomePercentage, expensePercentage]
            navigationController?.navigationBar.barTintColor = greyColor
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            setChart(categories, values: amounts)
        } else {
            pieChartView.noDataTextDescription = "no data available !!!"
        }
    }

    func sumAmountByGroup(data: [CashFlow]) -> Double {
        var total = 0.0
        for i in 0 ..< data.count
        {
            total = total + Double(data[i].amount!)
        }
        return total
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        pieChartDataSet.valueFormatter = formatter
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.descriptionText = ""
        pieChartView.legend.enabled = false
        //pieChartView.centerText = "Balance: ($1000)"
        
        let red = UIColor.init(red: 250/255, green: 128/255.0, blue: 144/255.0, alpha: 1.0)
        let green = UIColor.init(red: 67/255, green: 205/255.0, blue: 128/255.0, alpha: 1.0)
        let colors: [UIColor] = [green, red]
        pieChartDataSet.colors = colors
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if(indexPath.row == 0) {
            return false
        }
        return true
    }

    @IBAction func fromDateTextFieldEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(HomeViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }

    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        fromDateTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("IncomeGroup", sender: self)
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier != "addNew") {
            let categoryTableView = segue.destinationViewController as! CategoryViewController
            let cellIndexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)!
            if(cellIndexPath.row == 1)
            {
                categoryTableView.loadData("income")
            } else if (cellIndexPath.row == 2)
            {
                categoryTableView.loadData("expense")
            }
        }
    }
}
