//
//  CushionSittingInfo+CoreDataClass.swift
//  
//
//  Created by Arun Kumar on 24/04/18.
//
//

import Foundation
import CoreData

@objc(CushionSittingInfo)
public class CushionSittingInfo: NSManagedObject {
    @objc class func newSittingInfo(forContext context : NSManagedObjectContext) -> CushionSittingInfo
    {
        return newEntity(forContext: context) as CushionSittingInfo
    }
    
}
