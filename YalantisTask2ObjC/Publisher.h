  //
  //  Punlisher.h
  //  YalantisTask2ObjC
  //
  //  Created by typan on 8/26/15.
  //  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
  //

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Publisher : NSObject <NSCoding>

@property(nonatomic, strong) UIImage* image;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* section;


  //designated init
-(instancetype)initWithImage:(UIImage*)image  title:(NSString*)title section:(NSString*)section         NS_DESIGNATED_INITIALIZER;//helper macros that tell compiller that it designated initializers

  //convenience initializers
-(instancetype)initWithImage:(NSString*)imagePath title:(NSString*)title;





@end
