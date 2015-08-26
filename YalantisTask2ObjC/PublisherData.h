//
//  PublisherData.h
//  YalantisTask2ObjC
//
//  Created by typan on 8/26/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class Publisher;


@interface PublisherData : NSObject



@property(nonatomic, strong) NSMutableArray* container;

+(instancetype)sharedInstance;
-(UIImage*)imageForCellAtIndex:(int)index;
-(NSString*)titleForCellAtIndex:(int)index;
-(void)addNewEntryInModel:(NSString*)title;
-(void)removeObjectAtIndex:(int)index;
-(void)editExistEntryInModel:(Publisher*)object changeTitle:(NSString*)title;


@end
