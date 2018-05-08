//
//  Credential+CoreDataProperties.swift
//  
//
//  Created by Arun Kumar on 12/04/18.
//
//

import Foundation
import CoreData


extension Credential {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Credential> {
        return NSFetchRequest<Credential>(entityName: "Credential")
    }

    @NSManaged public var emailID: String?
    @NSManaged public var password: String?
    
    
    

}
