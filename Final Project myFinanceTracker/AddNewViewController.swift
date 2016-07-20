//
//  AddNewViewController.swift
//  Final Project myFinanceTracker
//
//  Created by Haibei Wu on 2016-07-15.
//  Copyright © 2016 cs2680. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddNewViewController: UIViewController
{
    
    @IBOutlet var categoryButtonCollection: [UIButton]!
    @IBOutlet weak var dateUITextField: UITextField!
    @IBOutlet weak var typeUISegmentedControl: UISegmentedControl!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    let blueColor:UIColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    
    let incomeCategory = ["Clothing", "Transport", "Entertainment", "Dining"]
    let expenseCategory = ["Salary", "Deposits", "Rental", "Other Income"]
    var selectedCategory:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.getBackgroundColor()
        
        initCatories()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddNewViewController.viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        dateTextField.text = convertedDate
    }
    
    func viewTapped()
    {
        self.dateUITextField.resignFirstResponder()
        self.amountTextField.resignFirstResponder()
    }
    
    func initCatories() {
        for i in 0 ..< categoryButtonCollection.count
        {
            categoryButtonCollection[i].layer.borderWidth = 1
            categoryButtonCollection[i].layer.cornerRadius = 5
            categoryButtonCollection[i].layer.borderColor = blueColor.CGColor
            let buttonText = categoryButtonCollection[i].titleLabel?.text
            if(typeUISegmentedControl.selectedSegmentIndex == 0) {
                if(incomeCategory.indexOf(buttonText!) > -1) {
                    categoryButtonCollection[i].enabled = true
                } else {
                    categoryButtonCollection[i].enabled = false
                }
            } else {
                if(expenseCategory.indexOf(buttonText!)) > -1 {
                    categoryButtonCollection[i].enabled = true
                } else {
                    categoryButtonCollection[i].enabled = false
                }
            }
        }
    }
    
    func highlightButton(name: String) {
        for i in 0 ..< categoryButtonCollection.count
        {
            let button = categoryButtonCollection[i]
            if (button.titleLabel?.text == name)
            {
                button.backgroundColor = blueColor
                button.tintColor = UIColor.whiteColor()
            } else {
                button.backgroundColor = UIColor.whiteColor()
                button.tintColor = UIColor.blueColor()
            }
        }
    }
    
    func clearHighlightButton() {
        for i in 0 ..< categoryButtonCollection.count
        {
            let button = categoryButtonCollection[i]
            if (selectedCategory == button.titleLabel?.text) {
                button.backgroundColor = UIColor.whiteColor()
                button.tintColor = UIColor.blueColor()

            }
        }
    }
    
    @IBAction func touchUpOnButton(sender: AnyObject) {
        let button = sender as! UIButton
        selectedCategory = button.titleLabel?.text
        highlightButton(selectedCategory!)
    }
    
    @IBAction func switchType(sender: UISegmentedControl) {
        initCatories()
        clearHighlightButton()
    }
    
    @IBAction func editingDateInput(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(HomeViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)

    }
    
    @IBAction func completeOnTextInputEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }

    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateUITextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBAction func cancel(sender: UIButton) {
        clearForm()
    }
    
    func isFormInValid() -> Bool
    {
        return dateTextField.text!.isEmpty || amountTextField.text!.isEmpty || selectedCategory == nil
    }
    
    func getFirstEmptyFieldString() -> String {
        var emptyFieldsString:String = ""
        if self.dateTextField.text!.isEmpty {
            emptyFieldsString += "Date"
        } else if (self.amountTextField.text!.isEmpty){
            emptyFieldsString += "Amount"
        } else if (self.selectedCategory == nil) {
            emptyFieldsString += "Category"
        }
        return emptyFieldsString
    }
    
    @IBAction func save(sender: UIButton) {
        if(self.isFormInValid()) {
            let emptyFieldString:String = self.getFirstEmptyFieldString()
            
            let errorAlertController = UIAlertController(title: "Error", message: "\(emptyFieldString) Field Empty", preferredStyle: .Alert)
            let okayWithoutClearAction = UIAlertAction(title: "Okay", style: .Cancel, handler: nil)
            errorAlertController.addAction(okayWithoutClearAction)
            self.presentViewController(errorAlertController, animated: true, completion: nil)
            return;
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let cashFlowService = CashFlowService(context: managedContext)
        
        let date = dateTextField.text!
        let amount = Int(amountTextField.text!)!
        let type = typeUISegmentedControl.selectedSegmentIndex
        cashFlowService.create(selectedCategory, amount: amount, type: type, date: date)
        cashFlowService.saveChanges()
        clearForm()
    }
    
    func clearForm()
    {
        typeUISegmentedControl.selectedSegmentIndex = 0
        initCatories()
        clearHighlightButton()
        amountTextField.text = ""
        selectedCategory = nil
    }
    
    func resetButtonStyle(button: UIButton) {
        button.backgroundColor = UIColor.whiteColor()
        button.tintColor = UIColor.blueColor()
    }
}