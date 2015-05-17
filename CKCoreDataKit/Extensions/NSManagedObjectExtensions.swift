//
//  NSManagedObjectExtensions.swift
//  CKCoreDataKit
//
//  Created by Kevin Chen on 5/14/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    public class func entityName() -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
    convenience public init(context: NSManagedObjectContext) {
        let name = self.dynamicType.entityName()
        let entity = NSEntityDescription.entityForName(self.dynamicType.entityName(), inManagedObjectContext: context)
        assert(entity != nil, "======> Initialize entity \(name) fail <======")
        self.init(entity: entity!, insertIntoManagedObjectContext:context)
    }
}