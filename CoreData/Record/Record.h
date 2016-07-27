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

+ (Record *)fetchLastRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                            Dog:(Dog *)dog;

+ (Record *)fetchPPVRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                           Dog:(Dog *)dog; //查找上次细小
+ (Record *)fetchDistemperRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                                 Dog:(Dog *)dog; //查找上次犬瘟热
+ (Record *)fetchCoronavirusRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                                   Dog:(Dog *)dog; //查找上次冠状病毒
+ (Record *)fetchRabiesRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                              Dog:(Dog *)dog; //查找上次狂犬病
+ (Record *)fetchToxoplasmaRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                                  Dog:(Dog *)dog; //查找上次弓形虫
+ (Record *)fetchIninsecticideRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                                     Dog:(Dog *)dog; //查找上次体内驱虫
+ (Record *)fetchOutinsecticideRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                                      Dog:(Dog *)dog; //查找上次体外驱虫

@end

NS_ASSUME_NONNULL_END

#import "Record+CoreDataProperties.h"
