    //
    //  ContainerCollectionViewController.m
    //  YalantisTask2ObjC
    //
    //  Created by typan on 8/25/15.
    //  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
    //

    //controller
#import "ASContainerCollectionViewController.h"
#import "ASPublisherCollectionViewCell.h"
#import "ASAddEditEntryViewController.h"

#import "ASPublisherEntity.h"


const NSTimeInterval cellActionAnimation = 0.4;

@interface ASContainerCollectionViewController () <NSFetchedResultsControllerDelegate, ASAddEditEntryViewControllerDelegate>



@end




@implementation ASContainerCollectionViewController



#pragma mark -
#pragma mark LOADING

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupGridForCollectionView];
    self.collectionView.delaysContentTouches = true;
    [self setupLongPressGestureToDeleteCell];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.fetchedResultController.delegate = self;
    [self.collectionView reloadData];
    [self animationCollectionView];
}


- (void)setupLongPressGestureToDeleteCell {
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(didLongPressCellToDelete:)];
    lpgr.minimumPressDuration = 0.5;
    [self.collectionView addGestureRecognizer:lpgr];
}


- (void)setupGridForCollectionView {
    CGFloat leftAndRightPadding = 36.0;
    CGFloat numberOfItemPerRow = 3.0;
    CGFloat heightAdjustment = 40.0;
    CGFloat widthOneItem =
    (CGRectGetWidth(self.collectionView.frame) - leftAndRightPadding) / numberOfItemPerRow;

    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(widthOneItem, widthOneItem + heightAdjustment);
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    [self.collectionView setCollectionViewLayout:layout];
}





#pragma mark -
#pragma mark - DATASOURCE

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ASPublisherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellCollection"
                                                                                    forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(ASPublisherCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    ASPublisherEntity *recordInDB = [self.fetchedResultController objectAtIndexPath:indexPath];

//    cell.publisherImage.image = [[ASPublisherData sharedInstance] imageForCellAtIndex:indexPath.row];
    cell.publisherTitle.text = recordInDB.publisherName;
}




#pragma mark -
#pragma Cell Target Action

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [self animateSelectedCell:cell withZoomX:1.2 zoomY:1.2];
    [self performSegueWithIdentifier:@"EditEntrySegue" sender:cell];
}



- (void)didLongPressCellToDelete:(UILongPressGestureRecognizer*)gesture {
    CGPoint tapLocation = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];

    if (indexPath && gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long press");

        
    }
}



/*
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(deletePublisher:));
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)deletePublisher:(UIMenuController *)menuController {
    NSLog(@"Menu");
}


- (BOOL)collectionView:(UICollectionView *)collectionView
      canPerformAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender {

    if (action == @selector(deletePublisher:)) {
            UIAlertView *alertview = [[UIAlertView alloc]
                                      initWithTitle:@"warning.."
                                      message:@"Do you really want to delete this?"
                                      delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertview show];
            return YES;
        }

    return NO;
}


- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSLog(@"Delete");
}
*/







#pragma mark -
#pragma mark Cell Display

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self animateDisplayCell:cell atIndex:indexPath];
}




#pragma mark -
#pragma mark Segue Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"EditEntrySegue"]) {
        NSIndexPath* indexPath = [self.collectionView indexPathForCell:sender];
        ASAddEditEntryViewController* controller = [segue destinationViewController];
        controller.coreDataManager = self.coreDataManager;
        controller.editASPublisherEntity = [self.fetchedResultController objectAtIndexPath:indexPath];
        controller.indexPathForCellAnimation = indexPath;
        controller.delegate = self;
    }
}



#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            break;
        case NSFetchedResultsChangeDelete:
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(ASPublisherCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            break;
    }

}



#pragma mark -
#pragma mark ASAddEditEntryViewControllerDelegate

- (void)cancelButtonDidTouchForEditingPublisherIn:(ASAddEditEntryViewController *)ctrl
                                           withIndexPathCell:(NSIndexPath *)path {

    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:path];

    __block __weak ASContainerCollectionViewController *BlockSelf = self;
    [ctrl dismissViewControllerAnimated:true completion:^{

        [BlockSelf animateSelectedCell:cell withZoomX:1 zoomY:1];

    }];

}

- (void)editASPublisherEntityDoneIn:(ASAddEditEntryViewController *)controller endWithChanged:(NSManagedObject *)record
                   withAnimatedCell:(NSIndexPath *)indePathCell {
        //save context
    [self.coreDataManager saveManagedObjectContext];

        //dismiss with animation cell
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indePathCell];
    __block __weak ASContainerCollectionViewController *BlockSelf = self;
    [controller dismissViewControllerAnimated:YES completion:^{
        [BlockSelf animateSelectedCell:cell withZoomX:1 zoomY:1];
    }];
}



#pragma mark - Animation

- (void)animationCollectionView {
    self.collectionView.alpha = 0;
    __block __weak ASContainerCollectionViewController* blockSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        blockSelf.collectionView.alpha = 1;
    }];
}

- (void)animateSelectedCell:(UICollectionViewCell *)cell withZoomX:(CGFloat)x zoomY:(CGFloat)y {
    [UIView animateWithDuration:cellActionAnimation delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        cell.transform = CGAffineTransformMakeScale(x, y);
    } completion:nil];
}

- (void)animateDisplayCell:(UICollectionViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    cell.alpha = 0;
    cell.transform = CGAffineTransformMakeScale(0.1, 0.1);

    double eachRow = indexPath.row;
    double sizeOfContainerWithData = self.fetchedResultController.fetchedObjects.count;
    NSTimeInterval time = eachRow / sizeOfContainerWithData;

    [UIView animateWithDuration:time animations:^{
        cell.alpha = 1;
        cell.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

@end
