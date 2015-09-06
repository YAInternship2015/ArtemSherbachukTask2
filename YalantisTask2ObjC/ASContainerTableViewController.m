    //
    //  ContainerTableViewController.m
    //  YalantisTask2ObjC
    //
    //  Created by typan on 8/25/15.
    //  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
    //

    //controller clases
#import "ASContainerTableViewController.h"
#import "ASPublisherTableViewCell.h"
#import "ASAddEditEntryViewController.h"

    //data model clases
#import "ASPublisherEntity.h"



@implementation UIColor (Extentions)

+ (UIColor *)lightGreenCellCollorOnSelect {
    return [UIColor colorWithRed:0.204 green:0.737 blue:0.6 alpha:1];
}

@end

const NSTimeInterval kCellActionAnimationTime = 0.4;





@interface ASContainerTableViewController ()  <NSFetchedResultsControllerDelegate, ASAddEditEntryViewControllerDelegate>


@end


@implementation ASContainerTableViewController

#pragma mark -
#pragma mark LOADING

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delaysContentTouches = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

        //toggle delegate when vc is change each time
    self.fetchedResultController.delegate = self;
//    [self animationTableViewFadeIn];
    [self.tableView reloadData];
}



#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASPublisherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTable" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(ASPublisherTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    ASPublisherEntity *recordInDB = [self.fetchedResultController objectAtIndexPath:indexPath];

        //    cell.publisherImage.image = [[ASPublisherData sharedInstance] imageForCellAtIndex:indexPath.row];
    cell.publisherTitle.text = recordInDB.publisherName;

    cell.backgroundColor = indexPath.row % 2 ? [UIColor whiteColor] : [[UIColor lightGrayColor]
                                                                       colorWithAlphaComponent:0.2];
}



#pragma mark -
#pragma mark TableView Action

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyl forRowAtIndexPath:(NSIndexPath *)indexPath {
    ASPublisherEntity *recordInDB = [self.fetchedResultController objectAtIndexPath:indexPath];
    if (recordInDB) {
        [self.fetchedResultController.managedObjectContext deleteObject:recordInDB];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];

    cell.contentView.backgroundColor = [UIColor lightGreenCellCollorOnSelect];

    [self animateSelectedCell:cell withZoomX:0.4 zoomY:0.4];

    [self performSegueWithIdentifier:@"EditEntrySegue" sender:cell];
}





#pragma mark -
#pragma mark Cell Display

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self animateCellThatWillDisplay:cell atIndexPath:indexPath];

}




#pragma mark -
#pragma mark Segue Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"EditEntrySegue"]) {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        ASAddEditEntryViewController* ctrl = [segue destinationViewController];
        ctrl.coreDataManager = self.coreDataManager;
        ctrl.editASPublisherEntity = [self.fetchedResultController objectAtIndexPath:indexPath];
        ctrl.indexPathForCellAnimation = indexPath;
        ctrl.delegate = self;
    }
}




#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)
indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath  {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
           [self configureCell:(ASPublisherTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}




#pragma mark -
#pragma mark ASAddEditEntryViewControllerDelegate

- (void)cancelButtonDidTouchForEditingPublisherIn:(ASAddEditEntryViewController *)ctrl withIndexPathCell:(NSIndexPath *)indexPath {

        //dismiss with animation cell
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    __block __weak ASContainerTableViewController *BlockSelf = self;
    [ctrl dismissViewControllerAnimated:YES completion:^{

        [BlockSelf animateSelectedCell:cell withZoomX:1 zoomY:1];

    }];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)editASPublisherEntityDoneIn:(ASAddEditEntryViewController *)controller endWithChanged:(NSManagedObject *)record
                   withAnimatedCell:(NSIndexPath *)indexPathCell {
        //save context
    [self.coreDataManager saveManagedObjectContext];

        //dismiss with animation cell
        //dismiss with animation cell
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPathCell];
    __block __weak ASContainerTableViewController *BlockSelf = self;
    [controller dismissViewControllerAnimated:YES completion:^{

        [BlockSelf animateSelectedCell:cell withZoomX:1 zoomY:1];

    }];

    [self.tableView deselectRowAtIndexPath:indexPathCell animated:YES];

}




#pragma mark -
#pragma mark Animation

- (void)animationTableViewFadeIn {
    self.tableView.alpha = 0;
    self.tableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    __block __weak ASContainerTableViewController* blocSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        blocSelf.tableView.alpha = 1;
        blocSelf.tableView.transform = CGAffineTransformMakeScale(1, 0.1);
    }];
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        blocSelf.tableView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

- (void)animateCellThatWillDisplay:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0;
    cell.transform = CGAffineTransformMakeScale(0, 0);


    double sizeOfContainerWithData = self.fetchedResultController.fetchedObjects.count;
    double eachRow = indexPath.row;
    NSTimeInterval time = eachRow / sizeOfContainerWithData;

    [UIView animateWithDuration:time animations:^{
        cell.alpha = 1;
        cell.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animateSelectedCell:(UITableViewCell *)cell withZoomX:(CGFloat)x zoomY:(CGFloat)y {
    [UIView animateWithDuration:kCellActionAnimationTime delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        cell.transform = CGAffineTransformMakeScale(x, y);
    } completion:nil];
}


@end
