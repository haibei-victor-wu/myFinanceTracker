//
//  CashFlow+CoreDataProperties.swift
//  Final Project myFinanceTracker
//
//  Created by Haibei Wu on 2016-07-15.
//  Copyright © 2016 cs2680. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CashFlow {

    @NSManaged var date: String?
    @NSManaged var amount: NSNumber?
    @NSManaged var type: NSNumber?
    @NSManaged var category: String?

}
