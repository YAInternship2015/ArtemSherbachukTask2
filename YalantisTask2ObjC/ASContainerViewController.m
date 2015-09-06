    //
    //  ViewController.m
    //  YalantisTask2ObjC
    //
    //  Created by typan on 8/25/15.
    //  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
    //

#import "ASContainerViewController.h"
#import "ASAddEditEntryViewController.h"
#import "ASContainerTableViewController.h"
#import "ASContainerCollectionViewController.h"


@implementation UIColor (Extentions)

+ (UIColor *)navigationBarGreenColor {
    return [UIColor colorWithRed:0.204 green:0.737 blue:0.6 alpha:1];
}

+ (UIColor *)navigationBarBlueColor {
    return [UIColor colorWithRed:0.238 green:0.589 blue:0.881 alpha:1];
}

@end



@interface ASContainerViewController () <ASAddEditEntryViewControllerDelegate>


@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, strong) ASContainerTableViewController* firstVC;
@property (nonatomic, strong) ASContainerCollectionViewController* secondVC;
@property (nonatomic, assign, setter=setActiveViewCtrl:) BOOL isFirstVC;


@end





@implementation ASContainerViewController




#pragma mark -
#pragma mark LOADING

- (void)viewDidLoad {
    [super viewDidLoad];

    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.firstVC  = [sb instantiateViewControllerWithIdentifier:@"TableView"];
    self.secondVC = [sb instantiateViewControllerWithIdentifier:@"CollectionView"];
    [self displayVC:self.firstVC];

    if (self.coreDataManager) {
            //I decide to create one NSFetchedResultsController object and pass it to parameters first and second vc. And CoreDataManager obj to;
        NSFetchedResultsController *frc = [self setupFetchResultController];
        self.firstVC.fetchedResultController = frc;
        self.secondVC.fetchedResultController = frc;
        self.firstVC.coreDataManager = self.coreDataManager;
        self.secondVC.coreDataManager = self.coreDataManager;

    }
}


- (NSFetchedResultsController *)setupFetchResultController {

    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"ASPublisherEntity"];
    [fr setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES]]];

    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                       initWithFetchRequest:fr
                                       managedObjectContext:self.coreDataManager.managedObjectContext
                                       sectionNameKeyPath:nil
                                       cacheName:nil];
        //perform fetch 
    NSError *error = nil;
    [frc performFetch:&error];
    if (error) NSLog(@"Unable to perform fetch."), NSLog(@"%@, %@", error, error.localizedDescription);

    return frc;
}




#pragma mark -
#pragma mark TARGET ACTION

- (IBAction)layoutButtonDidTouch:(UIBarButtonItem *)sender {
    _isFirstVC = !_isFirstVC;
    self.isFirstVC = _isFirstVC;//add synthesize var to param. and invoke method setter
}


- (IBAction)addNewEntryButonDidTouch:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"AddEditEntrySegue" sender:self];
}





#pragma mark -
#pragma mark CONTAINER LOGIC

    //toggle layout mode
- (void)setActiveViewCtrl:(BOOL)isFirstVC
{
    if (isFirstVC) {
        [self removeVC:self.firstVC];
        [self displayVC:self.secondVC];
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationBar.barTintColor = [UIColor navigationBarBlueColor];
        }];
    } else {
        [self removeVC:self.secondVC];
        [self displayVC:self.firstVC];
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationBar.barTintColor = [UIColor navigationBarGreenColor];
        }];
    }

}


- (void)removeVC:(UIViewController *)activeVC {
    [activeVC willMoveToParentViewController:nil];
    [activeVC.view removeFromSuperview];
    [activeVC removeFromParentViewController];
}

- (void)displayVC:(UIViewController* )newVC {
    CGFloat barHeight = CGRectGetHeight(self.navigationBar.frame);

    [self addChildViewController:newVC];
    newVC.view.frame = CGRectMake(0, barHeight, self.view.bounds.size.width,
                                  self.view.bounds.size.height - barHeight);
    [self.view addSubview:newVC.view];
    [newVC didMoveToParentViewController:self];
}







#pragma mark -
#pragma mark SEGUE NAVIGATION

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddEditEntrySegue"]) {
        ASAddEditEntryViewController* ctrl = segue.destinationViewController;
        ctrl.coreDataManager = self.coreDataManager;
        ctrl.delegate = self;
    }
}





#pragma mark -
#pragma mark ASAddEditEntryViewControllerDelegate

- (void)cancelButtonDidTouchForAddingNewPublisherIn:(ASAddEditEntryViewController *)ctrl {
    [ctrl dismissViewControllerAnimated:YES completion:nil];
}


@end
