//
//  Cushion+CoreDataProperties.swift
//  
//
//  Created by Arun Kumar on 24/04/18.
//
//

import Foundation
import CoreData


extension Cushion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cushion> {
        return NSFetchRequest<Cushion>(entityName: "Cushion")
    }

    @NSManaged public var cushionUUID: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneAlert: Bool
    @NSManaged public var sittingInfo: [CushionSittingInfo]?

}

// MARK: Generated accessors for sittingInfo
extension Cushion {

    @objc(addSittingInfoObject:)
    @NSManaged public func addToSittingInfo(_ value: CushionSittingInfo)

    @objc(removeSittingInfoObject:)
    @NSManaged public func removeFromSittingInfo(_ value: CushionSittingInfo)

    @objc(addSittingInfo:)
    @NSManaged public func addToSittingInfo(_ values: [CushionSittingInfo])

    @objc(removeSittingInfo:)
    @NSManaged public func removeFromSittingInfo(_ values: [CushionSittingInfo])
    
    func getSittingInfo(of day : Date) -> CushionSittingInfo? {
        guard let sittingInfo = sittingInfo else { return nil }
        return sittingInfo.first(where: {Calendar.current.isDate($0.updateTime!, inSameDayAs: day)})
    }
    
    func addSittingTime(for time : Date , sittingTime : Double) {
        if let sittiingInfo = getSittingInfo(of: time)
        {
         sittiingInfo.timeIntervals =  sittiingInfo.timeIntervals + [sittingTime]
        }
        else
        {
            let timeObject = createSittingInfo(for: time, sittingTime: sittingTime)
            addToSittingInfo(timeObject)
        }
        
        CoreDataStack.dataStack.saveContext()
        
    }
    
    private func createSittingInfo(for time : Date , sittingTime : Double) -> CushionSittingInfo
    {
        let timeObject = CushionSittingInfo.newSittingInfo(forContext: CoreDataStack.dataStack.manageObjectContext)
        timeObject.updateTime = time
        timeObject.timeIntervals = [sittingTime]
        return timeObject
    }
    

}
