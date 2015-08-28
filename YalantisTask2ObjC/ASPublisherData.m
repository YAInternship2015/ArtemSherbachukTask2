//
//  PublisherData.m
//  YalantisTask2ObjC
//
//  Created by typan on 8/26/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import "ASPublisherData.h"
#import "ASPublisher.h"



@interface ASPublisherData() {

}

@property(nonatomic, strong, getter=randomImagePath) NSString* path;
@property(nonatomic, strong) ASPublisher* publisher;

@end




@implementation ASPublisherData



- (instancetype)init
{
  self = [super init];
  if (self) {
    self.container = [[NSMutableArray alloc] initWithObjects:self.publisher, nil];
    [self loadDataFromPlist];
  }
  return self;
}


+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  static ASPublisherData* instance;
  dispatch_once(&onceToken, ^{
    instance = [[ASPublisherData alloc] init];
  });
  return instance;
}


#pragma mark - PRIVATE API
/*
 ...................
 .     PRIVATE     .
 ...................
 */

  // Construct file path
-(NSString* )documentDirectory {
  NSArray* docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  return docDir[0];
}

-(NSString* )dataFilePath {
  return [[self documentDirectory] stringByAppendingPathComponent:@"dataBase.plist"];
}

-(void)loadDataFromPlist {
  NSString* path = [self dataFilePath];
  if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    self.container = [unarchiver decodeObjectForKey:@"Publisher"];
    [unarchiver finishDecoding];
  }
}

-(void)saveDataToPlist {
  NSMutableData* data = [NSMutableData new];
  NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:self.container forKey:@"Publisher"];
  [archiver finishEncoding];
  [data writeToFile:[self dataFilePath] atomically:YES];
}

-(void)postNotification:(NSDictionary* )userInfo {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"DataChange" object:self userInfo:userInfo];
}

- (NSString *)randomImagePath
{
  switch (arc4random_uniform(7)) {
    case 1:
      return _path = @"TIME";
      break;
    case 2:
      return _path = @"The New York Times";
      break;
    case 3:
      return _path = @"TED";
      break;
    case 4:
      return _path = @"MIT Technology Review";
      break;
    case 5:
      return _path = @"The Atlantic";
      break;
    case 6:
      return _path = @"Daily Intelligencer";
      break;
    case 7:
      return _path = @"Quartz";
      break;
    default:
      return _path = @"Recode";
      break;
  }

}






#pragma mark - PUBLIC API
/*
 ...................
 .      PUBLIC     .
 ...................
 */
  //get data

-(UIImage*)imageForCellAtIndex:(int)index {
  ASPublisher* publisher = self.container[index];
  return publisher.image;
}


-(NSString*)titleForCellAtIndex:(int)index {
  ASPublisher* publisher = self.container[index];
  return publisher.title;
}


  //change data

-(void)addNewEntryInModel:(NSString*)title {
  ASPublisher* newObj = [[ASPublisher alloc] initWithImage:self.randomImagePath title:title];
  [self.container addObject:newObj];
  [self postNotification:nil];
  [self saveDataToPlist];
}


-(void)removeObjectAtIndex:(int)index {
  [self.container removeObjectAtIndex:index];
  [self saveDataToPlist];
}


-(void)editExistEntryInModel:(ASPublisher*)object changeTitle:(NSString*)title {
  object.title = title;
  [self postNotification:nil];
  [self saveDataToPlist];
}



@end
