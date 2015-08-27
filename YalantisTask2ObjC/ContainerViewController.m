//
//  ViewController.m
//  YalantisTask2ObjC
//
//  Created by typan on 8/25/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import "ContainerViewController.h"
#import "AddEditEntryViewController.h"




@interface ContainerViewController () <AddEditEntryViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic) UIViewController* firsVC;
@property (nonatomic) UIViewController* secondVC;
@property (nonatomic, assign, setter=setActtiveViewCtrl:) BOOL isFirstVC;


@end





@implementation ContainerViewController





#pragma mark LOADING

- (void)viewDidLoad {
  [super viewDidLoad];

  UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  self.firsVC  = [sb instantiateViewControllerWithIdentifier:@"TableView"];
  self.secondVC = [sb instantiateViewControllerWithIdentifier:@"CollectionView"];
  [self displayVC:self.firsVC];
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
- (void)setActtiveViewCtrl:(BOOL)isFirstVC
{
  if (isFirstVC) {
    [self removeVC:self.firsVC];
    [self displayVC:self.secondVC];
  } else {
    [self removeVC:self.secondVC];
    [self displayVC:self.firsVC];
  }

}


-(void)removeVC:(UIViewController *)activeVC
{
  [activeVC willMoveToParentViewController:nil];
  [activeVC.view removeFromSuperview];
  [activeVC removeFromParentViewController];
}

-(void)displayVC:(UIViewController* )newVC
{
  CGFloat barHeight = CGRectGetHeight(self.navigationBar.frame);

  [self addChildViewController:newVC];
  newVC.view.frame = CGRectMake(0, barHeight, self.view.bounds.size.width,
                                        self.view.bounds.size.height - barHeight);
  [self.view addSubview:newVC.view];
  [newVC didMoveToParentViewController:self];
}








#pragma mark  NAVIGATION

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"AddEditEntrySegue"]) {
    AddEditEntryViewController* ctrl = segue.destinationViewController;
    ctrl.delegate = self;
  }
}






#pragma mark delegate

- (void)cancelAddNewEntryViewControllerWithAnimationCell:(AddEditEntryViewController *)ctrl
                                           cellIndexPath:(NSIndexPath *)path
{
  [ctrl dismissViewControllerAnimated:YES completion:nil];
}


@end