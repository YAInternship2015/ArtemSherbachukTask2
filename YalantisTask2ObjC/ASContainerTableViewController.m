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
#import "ASPublisherData.h"



@implementation UIColor (Extentions)

+ (UIColor *)lightGreenColorCell {
    return [UIColor colorWithRed:0.204 green:0.737 blue:0.6 alpha:1];
}

@end

const NSTimeInterval kCellActionAnimationTime = 0.4;





@interface ASContainerTableViewController ()  <NSFetchedResultsControllerDelegate, ASAddEditEntryViewControllerDelegate>

@property(nonatomic, strong) NSFetchedResultsController *fettchedResultController;

@end


@implementation ASContainerTableViewController


#pragma mark - LOADING

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataChangedNotifiaction:)
                                                 name:ASDataWasChangedNotification
                                               object:nil];
    self.tableView.delaysContentTouches = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self animationTableViewFadeIn];
}






#pragma mark DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ASPublisherData sharedInstance].container.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASPublisherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTable" forIndexPath:indexPath];

    cell.backgroundColor = indexPath.row % 2 ? [UIColor whiteColor] : [[UIColor lightGrayColor]
                                                                       colorWithAlphaComponent:0.2];

    cell.publisherImage.image = [[ASPublisherData sharedInstance] imageForCellAtIndex:indexPath.row];
    cell.publisherTitle.text = [[ASPublisherData sharedInstance] titleForCellAtIndex:indexPath.row];

    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyl forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[ASPublisherData sharedInstance]removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
}







#pragma mark CELL STYLE


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];

    cell.contentView.backgroundColor = [UIColor lightGreenColorCell];

    [self animationSelectedCell:cell withZoomX:0.4 zoomY:0.4];

    [self performSegueWithIdentifier:@"EditEntrySegue" sender:cell];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {

    [self animationDisplayCell:cell atIndexPath:indexPath];

}




#pragma mark NOTIFIACTION

-(void)dataChangedNotifiaction:(NSNotification*)message {
    [self.tableView reloadData];
}



#pragma mark NAVIGATION

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"EditEntrySegue"]) {

        ASAddEditEntryViewController* ctrl = [segue destinationViewController];
        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        ctrl.editEntry = [ASPublisherData sharedInstance].container[indexPath.row];
        ctrl.delegate = self;
        ctrl.indexPathForCellAnimation = indexPath;
    }
}




#pragma mark Delegate Methods

- (void)cancelAddNewEntryViewControllerWithAnimationCell:(ASAddEditEntryViewController *)ctrl
                                           cellIndexPath:(NSIndexPath *)path {
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:path];

    [ctrl dismissViewControllerAnimated:YES completion:^{

        [self animationSelectedCell:cell withZoomX:1 zoomY:1];
        
    }];
    
    [self.tableView deselectRowAtIndexPath:path animated:YES];
    
}





#pragma mark - Animation

- (void)animationTableViewFadeIn {
    self.tableView.alpha = 0;
    self.tableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    __block __weak ASContainerTableViewController* blocSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        blocSelf.tableView.alpha = 1;
        blocSelf.tableView.transform = CGAffineTransformMakeScale(1, 0.1);
    }];
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        blocSelf.tableView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

- (void)animationSelectedCell:(UITableViewCell *)cell withZoomX:(CGFloat)x zoomY:(CGFloat)y {
    [UIView animateWithDuration:kCellActionAnimationTime delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        cell.transform = CGAffineTransformMakeScale(x, y);
    } completion:nil];
}

- (void)animationDisplayCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0;
    cell.transform = CGAffineTransformMakeScale(0, 0);

    double eachRow = indexPath.row;
    double sizeOfContainerWithData = [ASPublisherData sharedInstance].container.count;
    NSTimeInterval time = eachRow / sizeOfContainerWithData;

    [UIView animateWithDuration:time animations:^{
        cell.alpha = 1;
        cell.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

@end
