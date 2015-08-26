  //
  //  ContainerTableViewController.m
  //  YalantisTask2ObjC
  //
  //  Created by typan on 8/25/15.
  //  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
  //

#import "ContainerTableViewController.h"
#import "PublisherTableViewCell.h"
#import "PublisherData.h"




@interface ContainerTableViewController ()


@end




@implementation ContainerTableViewController






#pragma mark LOADING

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.rowHeight = 80;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(dataChange:)
                                               name:@"DataChange"
                                             object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}





#pragma mark - DATASOURCE


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [PublisherData sharedInstance].container.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PublisherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTable" forIndexPath:indexPath];

  cell.backgroundColor = indexPath.row % 2 ? [UIColor whiteColor] : [[UIColor grayColor] colorWithAlphaComponent:0.3];

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




#pragma mark NOTIFIACTION

-(void)dataChange:(NSNotification*)message {
  [self.tableView reloadData];
}


@end
