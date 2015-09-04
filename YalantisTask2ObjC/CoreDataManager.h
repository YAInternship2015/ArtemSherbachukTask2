//
//  CoreDataManager.h
//  Done
//
//  Created by typan on 9/1/15.
//  Copyright (c) 2015 Tuts+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

    //Entity Name
const NSString *ItemEntityName = @"Item";

    //Entity Attribute Name
const NSString *ItemAttributeName = @"name";
const NSString *ItemAttributeCreatedAt = @"createdAt";
const NSString *ItemAttributeDone = @"done";

@interface CoreDataManager : NSObject

@property(nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong, readonly) NSPersistentStore *persistentStore;

- (void)saveManagedObjectContext;

@end
