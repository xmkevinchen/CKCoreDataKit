//
//  CKSession.swift
//  CKCoreDataKit
//
//  Created by Kevin Chen on 5/14/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

import Foundation
import CoreData

public class CKSession {
    
    public let model: CKSessionModel
    public let context: NSManagedObjectContext
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    private var observer: NSObjectProtocol!
    
    public init(model: CKSessionModel = CKSessionModel(),
        storeType: String = NSSQLiteStoreType,
        mergePolicy: NSMergePolicyType = .MergeByPropertyObjectTrumpMergePolicyType,
        options: [NSObject: AnyObject]? = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true],
        concurrencyType: NSManagedObjectContextConcurrencyType = .MainQueueConcurrencyType)
    {
        self.model = model
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model.managedObjectModel)
        let url: NSURL? = (storeType == NSInMemoryStoreType) ? nil : model.url
        var error: NSError?
        self.persistentStoreCoordinator.addPersistentStoreWithType(storeType, configuration: nil, URL: url, options: options, error: &error);
        assert(error == nil, "======> Adding persistance store error: \(error) <======")
        
        self.context = NSManagedObjectContext(concurrencyType: concurrencyType)
        self.context.persistentStoreCoordinator = self.persistentStoreCoordinator
        self.context.mergePolicy = NSMergePolicy(mergeType: mergePolicy)
        
        observer = NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            if let managedObjectContext = notification.object as? NSManagedObjectContext {
                if managedObjectContext !== self.context {
                    self.context.mergeChangesFromContextDidSaveNotification(notification)
                }
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
    
    public func objects<T: NSManagedObject>(entity: T.Type) -> CKFetchRequest<T> {
        return CKFetchRequest<T>(entity, context: context)
    }
    
    public func write(transation: () -> Void) -> Bool {
        var success = false
        context.performBlockAndWait {
            
            transation()
            
            //            println("context.insertedObject = \(self.context.insertedObjects)")
            //            println("context.updatedObject = \(self.context.updatedObjects)")
            //            println("context.deletedObject = \(self.context.deletedObjects)")
            
            var error: NSError?
            success = self.context.save(&error)
            if !success {
                self.context.rollback()
                println("======> context transation error: \(error)")
            }
        }
        
        return success
    }
    
    public func delete<T: NSManagedObject>(object: T) {
        context.deleteObject(object)
    }
    
    public func insert<T: NSManagedObject>(object: T) {
        context.insertObject(object)
    }
    
    public func save<T: NSManagedObject>(object: T) {
        if let exist = context.objectRegisteredForID(object.objectID) {
            println("========> object \(object) exists")
        } else {
            insert(object)
        }
    }
            
}
