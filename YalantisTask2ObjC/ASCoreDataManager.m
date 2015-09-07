
    //
//  ASCoreDataManager.m
//  YalantisTask2ObjC
//
//  Created by typan on 9/4/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import "ASCoreDataManager.h"

@implementation ASCoreDataManager


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize persistentStore = _persistentStore;






#pragma mark - FILE STORE

NSString *fileStore = @"Database.sqlite";




#pragma mark SETUP DATA

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) return _managedObjectContext;

    NSPersistentStoreCoordinator *coordinator = [self persistenStoreCoordinator];
    if (coordinator) _managedObjectContext = [[NSManagedObjectContext alloc] init],
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) return _managedObjectModel;

    NSURL *modelURLPath = [[NSBundle mainBundle] URLForResource:@"PublisherModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURLPath];

    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistenStoreCoordinator {
    if (_persistentStoreCoordinator) return _persistentStoreCoordinator;

        ///create url to file store
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationsDocumentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                                 inDomains:NSUserDomainMask] lastObject];
        ///create folder Store
    NSURL *applicationsStoreDirectory = [applicationsDocumentsDirectory URLByAppendingPathComponent:@"Store"];
    [fileManager createDirectoryAtURL:applicationsStoreDirectory withIntermediateDirectories:YES
                           attributes:nil error:nil];
    NSURL *applicationsStoreFile = [applicationsStoreDirectory URLByAppendingPathComponent:fileStore];


        ///init pesistenStoreCoordinator and persistentStore
    NSError *Error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    _persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                 configuration:nil
                                                                           URL:applicationsStoreFile
                                                                       options:nil
                                                                         error:&Error];
    if (!_persistentStore) NSLog(@"error %@, %@", Error, [Error userInfo]), abort();


    return _persistentStoreCoordinator;
}


#pragma mark SAVE DATA

#pragma mark -
#pragma mark Helper Methods
- (void)saveManagedObjectContext {
    NSError *error = nil;

    if (![self.managedObjectContext save:&error]) {

        if (error) NSLog(@"Unable to save changes."),
            NSLog(@"%@, %@", error, error.localizedDescription), abort();
        
    }
}


@end
