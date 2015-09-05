  //
  //  AddEditEntryViewController.m
  //  YalantisTask2ObjC
  //
  //  Created by typan on 8/26/15.
  //  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
  //

#import "ASAddEditEntryViewController.h"


@interface ASAddEditEntryViewController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItemBar;


@end





@implementation ASAddEditEntryViewController




#pragma mark -
#pragma mark LOADING

- (void)viewDidLoad {
  [super viewDidLoad];

  self.textField.delegate = self;

  if (self.editASPublisherEntity != nil) {
      [self configEditEntryScreen];
  } else {
      [self configAddNewEntryScreen];
  }

}

- (void)configEditEntryScreen {
    self.navigationItemBar.title = @"Edit Entry";
    self.textField.text = self.editASPublisherEntity.publisherName;
    self.doneButton.enabled = true;
}

- (void)configAddNewEntryScreen {
    self.navigationItemBar.title = @"Add New Entry";
    self.doneButton.enabled = false;
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
//  [self.textField becomeFirstResponder];
}




#pragma mark -
#pragma mark TARGET ACTION

- (IBAction)cancelButtonDidTouch:(UIBarButtonItem *)sender {
    
    if (self.editASPublisherEntity) {
        [self.delegate cancelButtonDidTouchForEditingPublisherIn:self withIndexPathCell:self.indexPathForCellAnimation];
    } else {
        [self.delegate cancelButtonDidTouchForAddingNewPublisherIn:self];
    }

}


- (IBAction)doneButtonDidTouch:(UIBarButtonItem *)sender {
    NSString *name = self.textField.text;
  if (self.editASPublisherEntity) {
      [self doneEditASPublisherEntityWithChangedName:name];
  } else {
      [self doneAddNewASPublisherEntityWithName:name];
  }

}

- (void)doneEditASPublisherEntityWithChangedName:(NSString *)name {
    self.editASPublisherEntity.publisherName = name;
    [self.delegate editASPublisherEntityDoneIn:self
                                endWithChanged:self.editASPublisherEntity
                              withAnimatedCell:self.indexPathForCellAnimation];
}

- (void)doneAddNewASPublisherEntityWithName:(NSString *)name {
        /// Create Entity
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ASPublisherEntity"
                                                         inManagedObjectContext:self.coreDataManager.managedObjectContext];
        /// Initialize Record
    ASPublisherEntity *newRecord = [[ASPublisherEntity alloc]
                                    initWithEntity:entityDescription
                                    insertIntoManagedObjectContext:self.coreDataManager.managedObjectContext];

        /// Populate Record
    newRecord.publisherName = name;
    newRecord.created = [NSDate date];

    [self.coreDataManager saveManagedObjectContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {

  NSString* oldText = self.textField.text;
  NSString* newText = [oldText stringByReplacingCharactersInRange:range withString:string];

  self.doneButton.enabled = newText.length > 2;

  return true;
}







@end
