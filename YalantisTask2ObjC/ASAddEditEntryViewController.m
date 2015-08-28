  //
  //  AddEditEntryViewController.m
  //  YalantisTask2ObjC
  //
  //  Created by typan on 8/26/15.
  //  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
  //

#import "ASAddEditEntryViewController.h"

  //data model classes
#import "ASPublisherData.h"
#import "ASPublisher.h"



@interface ASAddEditEntryViewController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end





@implementation ASAddEditEntryViewController





#pragma mark LOADING

- (void)viewDidLoad {
  [super viewDidLoad];

  self.textField.delegate = self;

  if (self.editEntry != nil) {
    self.title = @"Edit Entry";
    self.textField.text = self.editEntry.title;
    self.doneButton.enabled = true;
  } else {
    self.title = @"Add New Entry";
    self.doneButton.enabled = false;
  }

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.textField becomeFirstResponder];
}





#pragma mark TARGET ACTION

- (IBAction)cancelButtonDidTouch:(UIBarButtonItem *)sender {
  [self.delegate cancelAddNewEntryViewControllerWithAnimationCell:self cellIndexPath:self.indexPathForCellAnimation];
}


- (IBAction)doneButtonDidTouch:(UIBarButtonItem *)sender {

  if (self.editEntry) {
    [[ASPublisherData sharedInstance] editExistEntryInModel:self.editEntry changeTitle:self.textField.text];
  } else {
    [[ASPublisherData sharedInstance] addNewEntryInModel:self.textField.text];
  }

  [self dismissViewControllerAnimated:YES completion:nil];

}






#pragma mark Delegate mehtod

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {

  NSString* oldText = self.textField.text;
  NSString* newText = [oldText stringByReplacingCharactersInRange:range withString:string];

  self.doneButton.enabled = newText.length > 2;

  return true;
}







@end
