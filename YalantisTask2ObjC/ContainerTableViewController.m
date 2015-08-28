  //
  //  ContainerTableViewController.m
  //  YalantisTask2ObjC
  //
  //  Created by typan on 8/25/15.
  //  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
  //

  //controller clases
#import "ContainerTableViewController.h"
#import "PublisherTableViewCell.h"
#import "AddEditEntryViewController.h"

  //data model clases
#import "PublisherData.h"



const NSTimeInterval kCellActionAnimationTime = 0.4;

@interface ContainerTableViewController ()  <AddEditEntryViewControllerDelegate>


@end




@implementation ContainerTableViewController






#pragma mark LOADING

- (void)viewDidLoad {
  [super viewDidLoad];
#warning это лучше задать в сториборде
  self.tableView.rowHeight = 80;
#warning имена нотификейшнов не стоит локализировать, их же не видно в интерфейсе. Их обычно выносят в отдельный файл либо структуру, где объявляют имена всех нотификейшнов, что есть в приложении. Например,
    // static NSString *const YMODataWasChangedNotification = @"YMODataWasChangedNotification";
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(dataChange:)
                                               name:NSLocalizedString(@"DataChange", "this is name of notification message no more magic string")
                                             object:nil];

  self.tableView.delaysContentTouches = YES;
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.tableView.alpha = 0;
  self.tableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
#warning опечатка в имени переменной, неправильно отформатированное объявление переменной, и опять этот странный сдвиг на два символа - он должен быть на четыре символа
    
#warning все эти плюшки с анимациями выглядят неплохо, но по коду их нужно выносить в отдельные методы, с "говорящими" именами
  __block __weak ContainerTableViewController* blocSelf = self;
  [UIView animateWithDuration:0.5 animations:^{
    blocSelf.tableView.alpha = 1;
    blocSelf.tableView.transform = CGAffineTransformMakeScale(1, 0.1);
  }];
  [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
    blocSelf.tableView.transform = CGAffineTransformMakeScale(1, 1);
  } completion:nil];
}






#pragma mark - DATASOURCE
/*
 .........................
 .        101010001      .
 .........................
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [PublisherData sharedInstance].container.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PublisherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTable" forIndexPath:indexPath];

  cell.backgroundColor = indexPath.row % 2 ? [UIColor whiteColor] : [[UIColor lightGrayColor]
                                                                     colorWithAlphaComponent:0.2];//zebra style:)

  cell.publisherImage.image = [[PublisherData sharedInstance] imageForCellAtIndex:indexPath.row];
  cell.publisherTitle.text = [[PublisherData sharedInstance] titleForCellAtIndex:indexPath.row];

  return cell;
}

  //delete action
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyl forRowAtIndexPath:(NSIndexPath *)indexPath
{
  [[PublisherData sharedInstance]removeObjectAtIndex:indexPath.row];
  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
}







#pragma mark CELL STYLE
/*
 .........................
 .        STYLE          .
 .........................
 */
  //cell interaction animation and action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];

  cell.contentView.backgroundColor = [UIColor colorWithRed:0.204 green:0.737 blue:0.6 alpha:1];

  [UIView animateWithDuration:kCellActionAnimationTime delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
    cell.transform = CGAffineTransformMakeScale(0.4, 0.4);
  } completion:nil];

  [self performSegueWithIdentifier:NSLocalizedString(@"EditEntrySegue",
                                                      "invoke segue to action for edit exist entry") sender:cell];
}

  //cell displaying animation
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {

  cell.alpha = 0;
  cell.transform = CGAffineTransformMakeScale(0, 0);

  double eachRow = indexPath.row;
  double sizeOfContainerWithData = [PublisherData sharedInstance].container.count;
  NSTimeInterval time = eachRow / sizeOfContainerWithData;

  [UIView animateWithDuration:time animations:^{
    cell.alpha = 1;
    cell.transform = CGAffineTransformMakeScale(1, 1);
  }];
}







#pragma mark NOTIFIACTION
/*
 .........................
 .     SOS! SOS!...      .
 .........................
 */


-(void)dataChange:(NSNotification*)message {
  [self.tableView reloadData];
}








#pragma mark NAVIGATION
/*
 .........................
 .       FROM -> TO      .
 .........................
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSString* segueIdent = NSLocalizedString(@"EditEntrySegue",
                                           "invoke segue to action for edit exist entry");
  if ([segue.identifier isEqualToString:segueIdent]) {

    AddEditEntryViewController* ctrl = [segue destinationViewController];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    ctrl.editEntry = [PublisherData sharedInstance].container[indexPath.row];
    ctrl.delegate = self;
    ctrl.indexPathForCellAnimation = indexPath;
  }
}







#pragma mark Delegate Methods

- (void)cancelAddNewEntryViewControllerWithAnimationCell:(AddEditEntryViewController *)ctrl
                                           cellIndexPath:(NSIndexPath *)path {
  UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:path];

  [ctrl dismissViewControllerAnimated:YES completion:^{

    [UIView animateWithDuration:kCellActionAnimationTime delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
      cell.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];

  }];

  [self.tableView deselectRowAtIndexPath:path animated:YES];

}


@end
