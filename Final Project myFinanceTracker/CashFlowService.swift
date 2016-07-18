//
//  CashFlowService.swift
//  Final Project myFinanceTracker
//
//  Created by Haibei Wu on 2016-07-15.
//  Copyright © 2016 cs2680. All rights reserved.
//

import Foundation
import CoreData

class CashFlowService{
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    // Creates a new Person
    func create(category: String, amount: NSNumber, type: NSNumber, date: String) -> CashFlow {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName(CashFlow.entityName, inManagedObjectContext: context) as! CashFlow
        
        newItem.amount = amount
        newItem.category = category
        newItem.type = type
        newItem.date = date
        
        return newItem
    }
    
    // Gets a cashflow by id
    func getById(id: NSManagedObjectID) -> CashFlow? {
        return context.objectWithID(id) as? CashFlow
    }
    
    // Gets all.
    func getAll() -> [CashFlow]{
        return get(withPredicate: NSPredicate(value:true))
    }
    
    // Gets all that fulfill the specified predicate.
    // Predicates examples:
    // - NSPredicate(format: "category == %@", "Income")
    // - NSPredicate(format: "category contains %@", "Income")
    func get(withPredicate queryPredicate: NSPredicate) -> [CashFlow]{
        let fetchRequest = NSFetchRequest(entityName: CashFlow.entityName)
        
        fetchRequest.predicate = queryPredicate
        
        do {
            let response = try context.executeFetchRequest(fetchRequest)
            return response as! [CashFlow]
            
        } catch let error as NSError {
            // failure
            print(error)
            return [CashFlow]()
        }
    }
    
    // Sort all that fulfill the specified sortDescriptor.
    // sortDescriptor examples:
    // - NSSortDescriptor(key: "timeStamp", ascending: true)
    func getWithSort(withPredicate queryPredicate: NSPredicate, withSortDescriptor sortDescriptor: NSSortDescriptor) -> [CashFlow]{
        let fetchRequest = NSFetchRequest(entityName: CashFlow.entityName)
        fetchRequest.predicate = queryPredicate
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let response = try context.executeFetchRequest(fetchRequest)
            return response as! [CashFlow]
            
        } catch let error as NSError {
            // failure
            print(error)
            return [CashFlow]()
        }
    }
    
    // Updates cashflow
    func update(updatedCashFlow: CashFlow){
        if let cashflow = getById(updatedCashFlow.objectID){
            cashflow.amount = updatedCashFlow.amount
            cashflow.category = updatedCashFlow.category
            cashflow.date = updatedCashFlow.date
            cashflow.type = updatedCashFlow.type
        }
    }
    
    // Deletes cashflow
    func delete(id: NSManagedObjectID){
        if let cashflowToDelete = getById(id){
            context.deleteObject(cashflowToDelete)
        }
    }
    
    // Saves all changes
    func saveChanges(){
        do{
            try context.save()
        } catch let error as NSError {
            // failure
            print(error)
        }
    }
}
