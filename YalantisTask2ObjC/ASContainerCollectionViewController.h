//
//  ContainerCollectionViewController.h
//  YalantisTask2ObjC
//
//  Created by typan on 8/25/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASCoreDataManager.h"

@interface ASContainerCollectionViewController : UICollectionViewController

@property(nonatomic, strong) ASCoreDataManager *coreDataManager;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultController;

@end
