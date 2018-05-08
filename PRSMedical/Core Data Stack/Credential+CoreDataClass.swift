//
//  Credential+CoreDataClass.swift
//  
//
//  Created by Arun Kumar on 12/04/18.
//
//

import Foundation
import CoreData

@objc(Credential)
public class Credential: NSManagedObject {
    @objc class func newCredential(forContext context : NSManagedObjectContext) -> Credential
    {
        return newEntity(forContext: context) as Credential
    }
    
    class func getCredentialEntity() -> Credential? {
        let request : NSFetchRequest<Credential> = fetchRequest()
        do {
            let arr = try CoreDataStack.dataStack.manageObjectContext.fetch(request) as [Credential]
            return arr.first
            
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func saveCredential(withEmailID email : String , password : String) {
        
       
        
        self.emailID = email
        self.password = password
        CoreDataStack.dataStack.saveContext()
        
    }
    
   class func delete()  {
        if let currentCredential = Credential.getCredentialEntity()
        {
            CoreDataStack.dataStack.manageObjectContext.delete(currentCredential)
            CoreDataStack.dataStack.saveContext()
        }
       
    }
}
