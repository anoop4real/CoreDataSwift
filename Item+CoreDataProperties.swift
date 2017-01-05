//
//  Item+CoreDataProperties.swift
//  CoreDataSwift
//
//  Created by anoopm on 04/12/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

import Foundation
import CoreData
 

extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var completed: Bool
    @NSManaged public var createdDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var list: List?

}
