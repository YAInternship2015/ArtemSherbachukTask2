//
//  ContainerTableViewController.h
//  YalantisTask2ObjC
//
//  Created by typan on 8/25/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ASContainerTableViewController : UITableViewController

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@end
