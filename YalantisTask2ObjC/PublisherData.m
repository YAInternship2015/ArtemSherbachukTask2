//
//  PublisherData.m
//  YalantisTask2ObjC
//
//  Created by typan on 8/26/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

#import "PublisherData.h"
#import "Publisher.h"


#warning тут фигурные скобки не нужны
@interface PublisherData() {

}

@property(nonatomic, strong, getter=randomImagePath) NSString* path;
@property(nonatomic, strong) Publisher* publisher;

@end




@implementation PublisherData



- (instancetype)init
{
  self = [super init];
  if (self) {
    self.container = [[NSMutableArray alloc] initWithObjects:self.publisher, nil];
    [self loadDataFromPlist];
  }
  return self;
}

#warning по поводу синглтона. Его использовать можно, но в крайне редких случаях, когда без него никак не обойтись. В нашей же ситуации можно создать столько датасорсов, сколько необходимо приложению. То есть у табличного контроллера будет свой объект-датасорс, у коллекшн вью контроллера будет свой, у контроллера, который добавляет новый айтем - свой. Синхронизация данных в них достигается тем, что файл с данными один, и с помощью NSNotification все датасорсы узнают о том, что данные нужно "перевытянуть" из файла (этот механизм я расписывал в описании задания)
+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  static PublisherData* instance;
  dispatch_once(&onceToken, ^{
    instance = [[PublisherData alloc] init];
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
  Publisher* publisher = self.container[index];
  return publisher.image;
}


-(NSString*)titleForCellAtIndex:(int)index {
  Publisher* publisher = self.container[index];
  return publisher.title;
}


  //change data

-(void)addNewEntryInModel:(NSString*)title {
  Publisher* newObj = [[Publisher alloc] initWithImage:self.randomImagePath title:title];
  [self.container addObject:newObj];
  [self postNotification:nil];
  [self saveDataToPlist];
}


-(void)removeObjectAtIndex:(int)index {
  [self.container removeObjectAtIndex:index];
  [self saveDataToPlist];
}


-(void)editExistEntryInModel:(Publisher*)object changeTitle:(NSString*)title {
  object.title = title;
  [self postNotification:nil];
  [self saveDataToPlist];
}



@end
