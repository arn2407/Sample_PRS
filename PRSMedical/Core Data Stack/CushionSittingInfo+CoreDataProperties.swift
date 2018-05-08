//
//  CushionSittingInfo+CoreDataProperties.swift
//  
//
//  Created by Arun Kumar on 24/04/18.
//
//

import Foundation
import CoreData


extension CushionSittingInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CushionSittingInfo> {
        return NSFetchRequest<CushionSittingInfo>(entityName: "CushionSittingInfo")
    }

    @NSManaged public var updateTime: Date?
    @NSManaged public var sittingTimes: NSArray?
    @NSManaged public var cushion: Cushion?

    var timeIntervals : [Double]
    {
        get{return (sittingTimes as? [Double]) ?? []}
        set{
            sittingTimes = newValue as NSArray
        }
    }
    
}
