//
//  PublisherTableViewCell.m
//  YalantisTask2ObjC
//
//  Created by typan on 8/26/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import "ASPublisherTableViewCell.h"

@implementation ASPublisherTableViewCell


- (void)awakeFromNib {
    //visual style for userImage

  self.publisherImage.layer.cornerRadius = 3;
  self.publisherImage.layer.borderWidth = 1;
  self.publisherImage.layer.borderColor = [UIColor grayColor].CGColor;

    //thin line on top of image for nice looking
  CALayer* flatShadowLine = [CALayer layer];
  flatShadowLine.backgroundColor = [UIColor grayColor].CGColor;
  flatShadowLine.frame = CGRectMake(0, 0, self.publisherImage.bounds.size.width, 2);
    [self.publisherImage.layer addSublayer:flatShadowLine];
}


@end
