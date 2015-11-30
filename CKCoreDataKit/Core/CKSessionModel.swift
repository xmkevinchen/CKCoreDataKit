//
//  CKSessionModel.swift
//  CKCoreDataKit
//
//  Created by Kevin Chen on 5/14/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

import Foundation
import CoreData

public class CKSessionModel {
    
    public var url: NSURL
    public var name: String
    public var bundle: NSBundle
    var directory: NSURL
    
    /**
     Initialize session model
     
     :param: name      The name of CoreData Model file without extension, default is the App's name
     :param: bundle    The bundle which includes the CoreData Model file, default is the main bundle
     :param: directory The directory to save the file, default is the Application Documents directory
     
     :returns:
     */
    public init(name: String = CKSessionModel.applicationName(),
        bundle: NSBundle = NSBundle.mainBundle(),
        directory:NSURL = CKSessionModel.applicationDocumentDirectory()) {
            self.name = name
            self.bundle = bundle
            self.directory = directory
            self.url = self.directory.URLByAppendingPathComponent("\(name).sqlite")
    }
    
    var managedObjectModel:NSManagedObjectModel {
        let model = NSManagedObjectModel(contentsOfURL: modelURL)
        assert(model != nil, "======> Loading managed object model from \(self.url) fail <======")
        
        return model!
    }
    
    var modelURL: NSURL {
        let url = bundle.URLForResource(name, withExtension: "momd")
        assert(url != nil, "======> Managed object model file not found <======")
        return url!
    }
    
    private class func applicationName() -> String {
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        let key = kCFBundleNameKey as String
        let value = infoDictionary[key] as! String
        return value
    }
    
    private class func applicationDocumentDirectory() -> NSURL {
        
        do {
            let url = try NSFileManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true)
            return url
        } catch let error {
            fatalError("======> Looking up Documents Directory error: \(error) <======")
        }
        
    }
    
}