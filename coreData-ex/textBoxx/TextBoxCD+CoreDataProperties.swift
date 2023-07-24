//
//  TextBoxCD+CoreDataProperties.swift
//  coreData-ex
//
//  Created by Ali Esmaeili on 7/23/23.
//
//

import Foundation
import CoreData


extension TextBoxCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextBoxCD> {
        return NSFetchRequest<TextBoxCD>(entityName: "TextBoxCD")
    }

    @NSManaged public var userNameCD: String?
    @NSManaged public var passwordCD: String?
    @NSManaged public var numberCD: Int64

}

extension TextBoxCD : Identifiable {

}
