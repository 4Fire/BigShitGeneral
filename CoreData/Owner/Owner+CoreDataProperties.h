//
//  Owner+CoreDataProperties.h
//  大将军
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 SingYi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Owner.h"

NS_ASSUME_NONNULL_BEGIN

@interface Owner (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *account;
@property (nullable, nonatomic, retain) NSData *iconImage;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSNumber *sex;
@property (nullable, nonatomic, retain) NSSet<Dog *> *dog;
@property (nullable, nonatomic, retain) NSSet<WalkingDog *> *workingDog;

@end

@interface Owner (CoreDataGeneratedAccessors)

- (void)addDogObject:(Dog *)value;
- (void)removeDogObject:(Dog *)value;
- (void)addDog:(NSSet<Dog *> *)values;
- (void)removeDog:(NSSet<Dog *> *)values;

- (void)addWorkingDogObject:(WalkingDog *)value;
- (void)removeWorkingDogObject:(WalkingDog *)value;
- (void)addWorkingDog:(NSSet<WalkingDog *> *)values;
- (void)removeWorkingDog:(NSSet<WalkingDog *> *)values;

@end

NS_ASSUME_NONNULL_END
