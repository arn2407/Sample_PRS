//
//  Cushion+CoreDataClass.swift
//  
//
//  Created by Ashish Kumar on 18/04/18.
//
//

import Foundation
import CoreData

@objc(Cushion)
public class Cushion: NSManagedObject {
    @objc class func newCushion(forContext context : NSManagedObjectContext) -> Cushion
    {
        return newEntity(forContext: context) as Cushion
    }
    
    class func getAllCushions() -> [Cushion] {
        let request : NSFetchRequest<Cushion> = fetchRequest()
        do {
            let arr = try CoreDataStack.dataStack.manageObjectContext.fetch(request) as [Cushion]
            return arr
            
        }
        catch {
            print(error)
            return []
        }
    }
    
    func saveCushionDetail(withUUID uuid : String , name : String , phoneAlert : Bool) {
        
        
        self.cushionUUID = uuid
        self.name = name
        self.phoneAlert = phoneAlert
        CoreDataStack.dataStack.saveContext()
        
    }
    
    static func getCushion(for identifer : String) -> Cushion?
    {
        let query:NSFetchRequest<Cushion> = Cushion.fetchRequest()
        
        let predicate = NSPredicate(format: "cushionUUID == %@", identifer)
        query.predicate = predicate
        
        do{
           let  cushions = try CoreDataStack.dataStack.manageObjectContext.fetch(query)
            return cushions.last
            
        }catch{
            return nil
        }
    }
}
