//
//  AddEditEntryViewController.h
//  YalantisTask2ObjC
//
//  Created by typan on 8/26/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASCoreDataManager.h"

#import "ASPublisherEntity.h"
@class ASAddEditEntryViewController;



@protocol ASAddEditEntryViewControllerDelegate <NSObject>

@optional
- (void)cancelButtonDidTouchForAddingNewPublisherIn:(ASAddEditEntryViewController *)ctrl;
- (void)cancelButtonDidTouchForEditingPublisherIn:(ASAddEditEntryViewController *)ctrl withIndexPathCell:(NSIndexPath*)indexPath;
//- (void)addNewASPublisherEntityIn:(ASAddEditEntryViewController *)controller  publisherEntity:(NSManagedObject *)object;
- (void)editASPublisherEntityDoneIn:(ASAddEditEntryViewController *)controller endWithChanged:(NSManagedObject *)record  withAnimatedCell:(NSIndexPath *)indePathCell;

@end


@interface ASAddEditEntryViewController : UIViewController


@property (nonatomic, weak) IBOutlet UITextField *textField;

@property (nonatomic, strong) ASCoreDataManager *coreDataManager;
@property (nonatomic, strong) ASPublisherEntity *editASPublisherEntity;
@property (nonatomic, weak)  id <ASAddEditEntryViewControllerDelegate> delegate;
@property (nonatomic, strong) NSIndexPath* indexPathForCellAnimation;


@end
