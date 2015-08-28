//
//  AddEditEntryViewController.h
//  YalantisTask2ObjC
//
//  Created by typan on 8/26/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASPublisher;
@class ASAddEditEntryViewController;



@protocol ASAddEditEntryViewControllerDelegate <NSObject>

-(void)cancelAddNewEntryViewControllerWithAnimationCell:(ASAddEditEntryViewController *)ctrl
                                          cellIndexPath:(NSIndexPath*)path;

@end


@interface ASAddEditEntryViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) ASPublisher* editEntry;
@property (nonatomic, weak)  id <ASAddEditEntryViewControllerDelegate> delegate;
@property (nonatomic) NSIndexPath* indexPathForCellAnimation;


@end
