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

@interface ASContainerCollectionViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDataSource,
UICollectionViewDelegate, ASAddEditEntryViewControllerDelegate>

    // I decide to put CollectionView in ViewController for many resons. Animate height constrain... etc.
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteViewHeightConstraint; //view that attempt when we delete cell item
@property (weak, nonatomic) IBOutlet UIButton *deleteItemsButton;//confirmation deleting items cell
@property (weak, nonatomic) IBOutlet UIImageView *deleteSuccedImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showDeleteSuccedImageConstraint;

@end


@implementation ASContainerCollectionViewController



#pragma mark -
#pragma mark LOADING

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupLongPressGestureForDeletingCell];
    self.deleteViewHeightConstraint.constant = 0;
    self.showDeleteSuccedImageConstraint.constant = -100;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.fetchedResultController.delegate = self;
    [self.collectionView reloadData];
    [self animationCollectionView];
}


- (void)setupLongPressGestureForDeletingCell {
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(didLongPressCellToDelete:)];
    lpgr.minimumPressDuration = 0.5;
    [self.collectionView addGestureRecognizer:lpgr];
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

    cell.publisherImage.image = [UIImage imageWithData:recordInDB.publisherImage];
    cell.publisherTitle.text = recordInDB.publisherName;
}




#pragma mark -
#pragma mark Target Action

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [self animateSelectedCell:cell withZoomX:1.2 zoomY:1.2];
    [self performSegueWithIdentifier:@"EditEntrySegue" sender:cell];
}


- (void)didLongPressCellToDelete:(UILongPressGestureRecognizer*)gesture {
        //get location cell
    CGPoint tapLocation = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];

    if (indexPath && gesture.state == UIGestureRecognizerStateBegan) {

            //delete item cell
        ASPublisherEntity *object = [self.fetchedResultController objectAtIndexPath:indexPath];
        [self.fetchedResultController.managedObjectContext deleteObject:object];

            //tell button how match item cell was deleted
        NSSet *objects = [self.fetchedResultController.managedObjectContext deletedObjects];
        NSString *buttonTitle = [NSString stringWithFormat:@"Deleted %lu Items", (unsigned long)objects.count];
        [self.deleteItemsButton setTitle:buttonTitle forState:UIControlStateNormal];

            //show deleting menu view for confirmation
        [self showDeletingViewMenuWithAnimatedHeight:44];
    }
}


- (IBAction)cancelDeletingItems:(id)sender {
    [self.fetchedResultController.managedObjectContext rollback];
    [self hideDeletingViewMenuWithAnimation];
}


- (IBAction)saveDeletingItems:(id)sender {
        //save deleted items cell
    [self.coreDataManager saveManagedObjectContext];
    [self hideDeletingViewMenuWithAnimation];
    [self showDeletingSucceedImageWithAnimation];
}




#pragma mark -
#pragma mark Cell Display

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self animateDisplayCell:cell atIndex:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.bounds.size.width/4, self.collectionView.bounds.size.height/5);
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
            [self.collectionView reloadData];
            //[self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
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


- (void)showDeletingViewMenuWithAnimatedHeight:(CGFloat)height {
    self.deleteViewHeightConstraint.constant = height;
    __block __weak ASContainerCollectionViewController* BlockSelf = self;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [BlockSelf.view layoutIfNeeded];
                     } completion:nil];
}


- (void)hideDeletingViewMenuWithAnimation {
    __block __weak ASContainerCollectionViewController* BlockSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
            BlockSelf.deleteViewHeightConstraint.constant = 0;
        [BlockSelf.view layoutIfNeeded];
    }];
}


- (void)showDeletingSucceedImageWithAnimation {
    self.deleteSuccedImage.alpha = 0;
    self.showDeleteSuccedImageConstraint.constant = self.view.bounds.size.height/2;
    __block __weak ASContainerCollectionViewController* BlockSelf = self;
    [UIView animateWithDuration:0.8
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         BlockSelf.deleteSuccedImage.alpha = 1;
                         [BlockSelf.view layoutIfNeeded];
                     } completion:^(BOOL finished) {

                         BlockSelf.showDeleteSuccedImageConstraint.constant = -100;
                         [UIView animateWithDuration:0.3 delay:0.3
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              BlockSelf.deleteSuccedImage.alpha = 0;
                                              [BlockSelf.view layoutIfNeeded];
                                          } completion:nil];
                     }];
}

@end
