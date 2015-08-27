  //
  //  ContainerCollectionViewController.m
  //  YalantisTask2ObjC
  //
  //  Created by typan on 8/25/15.
  //  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
  //

  //controller
#import "ContainerCollectionViewController.h"
#import "AddEditEntryViewController.h"

  //view
#import "PublisherCollectionViewCell.h"

  //data model classes
#import "PublisherData.h"


const NSTimeInterval cellActionAnimation = 0.4;

@interface ContainerCollectionViewController () <AddEditEntryViewControllerDelegate>


@end




@implementation ContainerCollectionViewController






#pragma mark LOADING

- (void)viewDidLoad {
  [super viewDidLoad];

  [self gridForCollectionView3xItem];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(dataChange:)
                                               name:NSLocalizedString(@"DataChange", "this is name of notification message no more magic string")
                                             object:nil];
  
  self.collectionView.delaysContentTouches = true;
}



- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.collectionView.alpha = 0;
  __block ContainerCollectionViewController* blockSelf = self;
  [UIView animateWithDuration:0.5 animations:^{
    blockSelf.collectionView.alpha = 1;
  }];

}



  //setup grid for collection views
-(void)gridForCollectionView3xItem {
  CGFloat leftAndRightPadding = 32.0;
  CGFloat numberOfItemPerRow = 3.0;
  CGFloat heightAdjustment = 40.0;
  CGFloat widthOneItemForGrid3x = (CGRectGetWidth(self.collectionView.frame)-leftAndRightPadding)/numberOfItemPerRow;

  UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
  layout.itemSize = CGSizeMake(widthOneItemForGrid3x, widthOneItemForGrid3x + heightAdjustment);
  [self.collectionView setCollectionViewLayout:layout];
}







#pragma mark - DATASOURCE
/*
 .........................
 .        101010001      .
 .........................
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [PublisherData sharedInstance].container.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

  PublisherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellCollection"
                                                                                forIndexPath:indexPath];
  cell.publisherImage.image = [[PublisherData sharedInstance] imageForCellAtIndex:indexPath.row];
  cell.publisherTitle.text = [[PublisherData sharedInstance] titleForCellAtIndex:indexPath.row];

  return cell;
}






#pragma CELL STYLE
/*
 .........................
 .        STYLE          .
 .........................
 */
  //animate cell on tap
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

  UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];

  [UIView animateWithDuration:cellActionAnimation delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
    cell.transform = CGAffineTransformMakeScale(1.2, 1.2);
  } completion:nil];

  [self performSegueWithIdentifier:NSLocalizedString(@"EditEntrySegue",
                                                     "invoke segue to action for edit exist entry") sender:cell];
}


  //animation cell on scroll
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

  cell.alpha = 0;
  cell.transform = CGAffineTransformMakeScale(0.1, 0.1);

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
  [self.collectionView reloadData];
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

    AddEditEntryViewController* controller = [segue destinationViewController];

    NSIndexPath* indexPath = [self.collectionView indexPathForCell:sender];

    controller.delegate = self;
    controller.editEntry = [PublisherData sharedInstance].container[indexPath.row];
    controller.indexPathForCellAnimation = indexPath;
  }
}




#pragma makr Delegate methods

- (void)cancelAddNewEntryViewControllerWithAnimationCell:(AddEditEntryViewController *)ctrl
                                           cellIndexPath:(NSIndexPath *)path {

  UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:path];

  [ctrl dismissViewControllerAnimated:true completion:^{

    [UIView animateWithDuration:cellActionAnimation delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
      cell.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];

  }];

}

@end
