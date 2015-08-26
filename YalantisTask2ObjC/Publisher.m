  //
  //  Punlisher.m
  //  YalantisTask2ObjC
  //
  //  Created by typan on 8/26/15.
  //  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
  //

#import "Publisher.h"

@implementation Publisher


#pragma mark initialization

  //designated init
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title section:(NSString *)section
{
  self.image = image;
  self.title = title;
  self.section = section;
  return [super init];
}

  //convenience init
- (instancetype)initWithImage:(NSString*)imagePath title:(NSString*)title
{
  self = [self initWithImage:[UIImage imageNamed:imagePath] title:title section:@"New Added"];
  return self;
}




#pragma mark ARCHIVING NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
  NSData* imageData = [aDecoder decodeObjectForKey:@"image"];
  UIImage* image = [UIImage imageWithData:imageData];
  NSString* title = [aDecoder decodeObjectForKey:@"title"];
  NSString* section = [aDecoder decodeObjectForKey:@"section"];
  return [self initWithImage:image title:title section:section];
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:UIImagePNGRepresentation(self.image) forKey:@"image"];
  [aCoder encodeObject:self.title forKey:@"title"];
  [aCoder encodeObject:self.section forKey:@"section"];
}


@end
