//
//  Owner.h
//  大将军
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dog, WalkingDog;

NS_ASSUME_NONNULL_BEGIN

@interface Owner : NSManagedObject

+ (Owner *)fetchOwnerToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                  Account:(NSString *)account;
+ (BOOL)insertOwnerToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                Account:(NSString *)account
                               Password:(NSString *)Password;

+ (BOOL)duplicateCheckingOwnerWithContext:(NSManagedObjectContext *)ctx
                                  Account:(NSString *)account;

+ (NSArray<Owner*> *)fetchAllOwnerSToSQLiterWithContext:(NSManagedObjectContext *)ctx;

@end

NS_ASSUME_NONNULL_END

#import "Owner+CoreDataProperties.h"
