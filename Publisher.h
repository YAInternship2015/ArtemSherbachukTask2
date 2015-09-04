//
//  Publisher.h
//  YalantisTask2ObjC
//
//  Created by typan on 9/4/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Publisher : NSManagedObject

@property (nonatomic, retain) NSData * publisherImage;
@property (nonatomic, retain) NSString * publisherName;

@end
