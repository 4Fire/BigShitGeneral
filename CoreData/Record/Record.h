//
//  Record.h
//  大将军
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dog;

NS_ASSUME_NONNULL_BEGIN

@interface Record : NSManagedObject

+ (Record *)fetchRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                    DogName:(NSString *)dogName;

+ (BOOL)insertRecordDogToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                        ppv:(NSNumber *)ppv
                                  distemper:(NSNumber *)distemper
                                coronavirus:(NSNumber *)coronavirus
                                     rabies:(NSNumber *)rabies
                                 toxoplasma:(NSNumber *)toxoplasma
                              ininsecticide:(NSNumber *)ininsecticide
                             outinsecticide:(NSNumber *)outinsecticide
                                   pregnant:(NSNumber *)pregnant
                                   delivery:(NSNumber *)delivery
                                  neutering:(NSNumber *)neutering
                                       date:(NSDate *)date
                                      other:(NSString *)other
                                        Dog:(Dog *)dog;

+ (Record *)fetchRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                 RecordDate:(NSDate *)date
                                        Dog:(Dog *)dog;
@end

NS_ASSUME_NONNULL_END

#import "Record+CoreDataProperties.h"
