# CKCoreDataKit
> This is a CoreData syntax wrapper, written in Swift.  
> Simplify the usage of CoreData

## Usage

pod 'CKCoreDataKit', '~> 0.5.2'

## Classes

### Core
* CKSession
* CKSessionModel
* CKFetchRequest
* CKFetchResult

### Extension
* NSMangedObjectExtentions


## Basic Usage  

### Initialize

    let session = CKSession()

### Write

    session.write {
        // ... transaction

    }

### Query

    let result: CKFetchResult<T> = session
                                  .objects(T)
                                  .filter("name = %@", "Kevin")
                                  .filter(NSPredicate(format: "title = %@", "Dr."))
                                  .sort("age", ascending: true)
                                  .sort(NSSortDescriptor(key: "salary", ascending: false))
                                  .fetch()



----

## Limitation

The **CKCoreDataKit** just comes out for simplifying the syntax of most regular usage of **CoreData**, hidden the repeat *initialize*, *fetch*, *execute* code.
In order to accomplish the concurrency programming, use should keep the session as short as possible
