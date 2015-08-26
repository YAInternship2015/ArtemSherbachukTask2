//
//  AddEditEntryViewController.h
//  YalantisTask2ObjC
//
//  Created by typan on 8/26/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Publisher;
@class AddEditEntryViewController;



@protocol AddEditEntryViewControllerDelegate <NSObject>

-(void)cancelAddNewEntryViewControllerWithAnimationCell:(AddEditEntryViewController *)ctrl
                                          cellIndexPath:(NSIndexPath*)path;

@end


@interface AddEditEntryViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) Publisher* editEntry;
@property (nonatomic, weak)  id <AddEditEntryViewControllerDelegate> delegate;
@property (nonatomic) NSIndexPath* indexPathForCellAnimation;


@end
