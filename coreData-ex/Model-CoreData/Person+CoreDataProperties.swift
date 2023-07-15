//
//  Person+CoreDataProperties.swift
//  coreData-ex
//
//  Created by Ali Esmaeili on 7/15/23.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int16
    @NSManaged public var name: String?
    @NSManaged public var sex: String?

}

extension Person : Identifiable {

}
