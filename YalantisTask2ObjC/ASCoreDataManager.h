//
//  ASCoreDataManager.h
//  YalantisTask2ObjC
//
//  Created by typan on 9/4/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ASCoreDataManager : NSObject

@property(nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong, readonly) NSPersistentStore *persistentStore;

- (void)saveManagedObjectContext;

@end
