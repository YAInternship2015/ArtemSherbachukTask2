//
//  PublisherCollectionViewCell.m
//  YalantisTask2ObjC
//
//  Created by typan on 8/26/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import "PublisherCollectionViewCell.h"

@implementation PublisherCollectionViewCell


- (void)awakeFromNib {
    //visual stile cell
  self.layer.cornerRadius = 3;
  self.layer.borderWidth = 1;
  self.layer.borderColor = [UIColor grayColor].CGColor;

    //add a little thin line in a top of cell.
  CALayer* flatShadowLayer = [CALayer layer];
  flatShadowLayer.frame = CGRectMake(0, 0, self.publisherImage.frame.size.width, 2);
  flatShadowLayer.backgroundColor = [UIColor grayColor].CGColor;
  [self.layer addSublayer:flatShadowLayer];

}

@end
