//
//  CoreDataStack.swift
//  Learnet
//
//  Created by Arun Kumar on 31/07/17.
//  Copyright © 2017 Arun Kumar. All rights reserved.
//

import UIKit
import CoreData
import EncryptedCoreData

import GoogleSignIn
import FacebookCore
import FacebookLogin
import FBSDKLoginKit


class CoreDataStack: NSObject {
    
  private  let key = EncryptionKey.argNvJsbKoBhkdgYo_YukakdjOIOOHJK.rawValue
    
    enum EncryptionKey : String
    {
        case argNvJsbKoBhkdgYo_YukakdjOIOOHJK
    }
    
    // MARK: - Core Data stack
    static let dataStack = CoreDataStack()
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */

        let container = NSPersistentContainer.init(name: "PRSMedical")
        
        let options : [String : Any] = [EncryptedStorePassphraseKey : key , EncryptedStoreFileManagerOption : EncryptedStoreFileManager.default()]
        
        do {
             let description = try  EncryptedStore.makeDescription(options: options, configuration: nil)
            container.persistentStoreDescriptions = [description]
            
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            
             return container
        }
        catch
        {
            
            fatalError("Unresolved error \(error)")
        }
       
        
        
       
    }()
    
    // MARK: - Core Data Saving support
    
    lazy var manageObjectContext : NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    func saveContext () {
        let context = manageObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func resetDB(_ completion : @escaping(Bool)->())
    {
        isGoogleSignIn = false
        isFacebookSignIn = false
        if  GIDSignIn.sharedInstance().hasAuthInKeychain()
        {
            GIDSignIn.sharedInstance().signOut()
        }
        if (FBSDKAccessToken.current()) != nil {
            LoginManager().logOut()
        }
        let context = self.manageObjectContext
        DispatchQueue.init(label: "resetingDB").async {
            self.persistentContainer.performBackgroundTask { (_) in
                
                for manageObject in self.persistentContainer.managedObjectModel.entities
                {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: manageObject.name!)
                    do {
                        let entities = try self.manageObjectContext.fetch(fetchRequest) as! [NSManagedObject]
                        for entity in entities
                        {
                            context.delete(entity)
                        }
                        
                    }
                    catch{
                        
                        print("error in enity \(manageObject.name!) & error \(error.localizedDescription)")
                         DispatchQueue.main.async {
                        completion(false)
                        }
                        return
                    }
                    
                }
                do {
                    try context.save()
                    
                    DispatchQueue.main.async {
                        CoreDataStack.dataStack.saveContext()
                        completion(true)
                    }
                    
                }
                catch {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
                
                
            }
            
        }
       

    }
   
}


