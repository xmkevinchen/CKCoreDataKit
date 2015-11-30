//
//  CKFetchResult.swift
//  CKCoreDataKit
//
//  Created by Kevin Chen on 5/14/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

import Foundation
import CoreData

public struct CKFetchResult <T: NSManagedObject> {
    public let success: Bool
    public let objects: [T]?
    public let error: ErrorType?
    
}