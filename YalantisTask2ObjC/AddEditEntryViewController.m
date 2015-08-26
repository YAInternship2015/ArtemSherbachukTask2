  //
  //  AddEditEntryViewController.m
  //  YalantisTask2ObjC
  //
  //  Created by typan on 8/26/15.
  //  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
  //

#import "AddEditEntryViewController.h"
#import "PublisherData.h"



@interface AddEditEntryViewController ()


@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end





@implementation AddEditEntryViewController





- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.textField becomeFirstResponder];
}





- (IBAction)cancelButtonDidTouch:(UIBarButtonItem *)sender {
  [self.delegate cancelAddNewEntryViewControllerWithAnimationCell:self cellIndexPath:self.indexPathForCellAnimation];
}


- (IBAction)doneButtonDidTouch:(UIBarButtonItem *)sender {
  [[PublisherData sharedInstance]addNewEntryInModel:self.textField.text];
  [self dismissViewControllerAnimated:YES completion:nil];
}



@end
