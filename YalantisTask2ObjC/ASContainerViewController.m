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



@interface ASContainerViewController () <ASAddEditEntryViewControllerDelegate>


@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, strong) ASContainerTableViewController* firstVC;
@property (nonatomic, strong) ASContainerCollectionViewController* secondVC;
@property (nonatomic, assign, setter=setActiveViewCtrl:) BOOL isFirstVC;


@end





@implementation ASContainerViewController





#pragma mark LOADING

- (void)viewDidLoad {
    [super viewDidLoad];

    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.firstVC  = (ASContainerTableViewController *)[sb instantiateViewControllerWithIdentifier:@"TableView"];
    self.secondVC = (ASContainerCollectionViewController *)[sb instantiateViewControllerWithIdentifier:@"CollectionView"];
    [self displayVC:self.firstVC];

    if (self.managedObjectContext)
        self.firstVC.managedObjectContext = self.managedObjectContext,
        self.secondVC.managedObjectContext = self.managedObjectContext;

}







#pragma mark TARGET ACTION

- (IBAction)layoutButtonDidTouch:(UIBarButtonItem *)sender {
    _isFirstVC = !_isFirstVC;
    self.isFirstVC = _isFirstVC;//add synthesize var to param. and invoke method setter
}


- (IBAction)addNewEntryButonDidTouch:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"AddEditEntrySegue" sender:self];
}






#pragma mark CONTAINER LOGIC

    //toggle layout mode
- (void)setActiveViewCtrl:(BOOL)isFirstVC
{
    if (isFirstVC) {
        [self removeVC:self.firstVC];
        [self displayVC:self.secondVC];
    } else {
        [self removeVC:self.secondVC];
        [self displayVC:self.firstVC];
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








#pragma mark  NAVIGATION

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddEditEntrySegue"]) {
        ASAddEditEntryViewController* ctrl = segue.destinationViewController;
        ctrl.delegate = self;
    }
}






#pragma mark delegate

- (void)cancelAddNewEntryViewControllerWithAnimationCell:(ASAddEditEntryViewController *)ctrl
                                           cellIndexPath:(NSIndexPath *)path
{
    [ctrl dismissViewControllerAnimated:YES completion:nil];
}


@end
