//
//  CKFetchRequest.swift
//  CKCoreDataKit
//
//  Created by Kevin Chen on 5/14/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

import Foundation
import CoreData

public class CKFetchRequest<T: NSManagedObject> {
    
    var fetchRequest: NSFetchRequest
    var context: NSManagedObjectContext
    
    private var predicates: [NSPredicate]
    private var sortDescriptors: [NSSortDescriptor]
    private var fetchLimit: Int?
    private var fetchOffset: Int?
    
    init(_ entity: T.Type, context: NSManagedObjectContext) {
        self.fetchRequest = NSFetchRequest(entityName: entity.entityName())
        self.context = context
        self.predicates = [NSPredicate]()
        self.sortDescriptors = [NSSortDescriptor]()
    }
    
    public func filter(predicateFormat: String, _ args: CVarArgType...) -> CKFetchRequest<T> {
        let predicate = NSPredicate(format: predicateFormat, arguments: getVaList(args))
        
        return filter(predicate)
    }
    
    public func filter(predicate: NSPredicate) -> CKFetchRequest<T> {
        predicates.append(predicate)
        
        return self
    }
    
    public func sort(property: String, ascending: Bool = true) -> CKFetchRequest<T> {
        let sortDescriptor = NSSortDescriptor(key: property, ascending: ascending)
        
        return sort(sortDescriptor)
    }
    
    public func sort(sortDescriptor: NSSortDescriptor) -> CKFetchRequest<T> {
        sortDescriptors.append(sortDescriptor)
        return self
    }
    
    public func limit(limit: Int) -> CKFetchRequest<T> {
        fetchLimit = limit
        return self
    }
    
    public func offset(offset: Int) -> CKFetchRequest<T> {
        fetchOffset = offset
        return self
    }
    
    public func fetch() -> CKFetchResult<T> {
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        if let fetchLimt = fetchLimit {
            fetchRequest.fetchLimit = fetchLimt
        }
        
        if let fetchOffset = fetchOffset {
            fetchRequest.fetchOffset = fetchOffset
        }
        
        var fetchResult: CKFetchResult<T>!
        
        self.context.performBlockAndWait {
            
            do {
                
                if let results = try self.context.executeFetchRequest(self.fetchRequest) as? [T] {
                    fetchResult = CKFetchResult<T>(success: true, objects: results, error: nil)
                } else {
                    fetchResult = CKFetchResult<T>(success: false, objects: nil, error: nil)
                }
                
            } catch let error {
                print("======> Fetched with request \(self.fetchRequest) failed : \(error) <======")
                fetchResult = CKFetchResult<T>(success: false, objects: nil, error: error)
            }
            
            
        }
        
        return fetchResult
    }
    
    public func count() -> Int {
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = predicate
        
        if let fetchLimt = fetchLimit {
            fetchRequest.fetchLimit = fetchLimt
        }
        
        if let fetchOffset = fetchOffset {
            fetchRequest.fetchOffset = fetchOffset
        }
        
        var error: NSError?
        
        
        let count = self.context.countForFetchRequest(self.fetchRequest, error: &error)
        if let exists = error {
            print("======> Count with request \(fetchRequest) failed : \(exists) <======")
        }
        
        return count
    }
    
}