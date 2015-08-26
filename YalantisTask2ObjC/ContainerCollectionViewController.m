  //
  //  ContainerCollectionViewController.m
  //  YalantisTask2ObjC
  //
  //  Created by typan on 8/25/15.
  //  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
  //

#import "ContainerCollectionViewController.h"
#import "PublisherCollectionViewCell.h"
#import "PublisherData.h"



@interface ContainerCollectionViewController ()


@end




@implementation ContainerCollectionViewController






#pragma mark LOADING

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(dataChange:)
                                               name:@"DataChange"
                                             object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
}




#pragma mark - DATASOURCE

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





#pragma mark NOTIFIACTION

-(void)dataChange:(NSNotification*)message {
  [self.collectionView reloadData];
}

@end
