//
//  Dog.h
//  大将军
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Owner, Record;

NS_ASSUME_NONNULL_BEGIN

@interface Dog : NSManagedObject

+ (void)changeDogInfoWithNewName:(NSString *)newName
                         OldName:(NSString *)oldName
                            Icon:(NSData *)iconImage
                         Account:(NSString *)account;

+ (void)insertDogToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                 Name:(NSString *)name
                                 Icon:(NSData *)iconImage
                                  Sex:(NSNumber *)sex
                              Variety:(NSString *)variety
                            Neutering:(NSNumber *)neuterying
                             Birthday:(NSDate *)birthday
                                Owner:(Owner *)owner;

+ (Dog *)fetchDogFromSQLiterWithContext:(NSManagedObjectContext *)ctx Name:(NSString *)name owner:(Owner *)owner;

+ (void)deleteDogFromSQLiterWithContext:(NSManagedObjectContext *)ctx Name:(NSString *)name owner:(Owner *)owner;

+ (BOOL)duplicateCheckingDogWithContext:(NSManagedObjectContext *)ctx
                                   Name:(NSString *)name
                                  owner:(Owner *)owner;

+ (NSArray *)fetchAllDogsFromSQLiterWithContext:(NSManagedObjectContext *)ctx withOwner:(Owner *)owner;
@end

NS_ASSUME_NONNULL_END

#import "Dog+CoreDataProperties.h"
