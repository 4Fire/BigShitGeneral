//
//  Dog+CoreDataProperties.h
//  大将军
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 SingYi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Dog.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dog (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *birthday;
@property (nullable, nonatomic, retain) NSData *iconImage;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *neutering;
@property (nullable, nonatomic, retain) NSNumber *sex;
@property (nullable, nonatomic, retain) NSString *variety;
@property (nullable, nonatomic, retain) Owner *owner;
@property (nullable, nonatomic, retain) NSSet<Record *> *record;

@end

@interface Dog (CoreDataGeneratedAccessors)

- (void)addRecordObject:(Record *)value;
- (void)removeRecordObject:(Record *)value;
- (void)addRecord:(NSSet<Record *> *)values;
- (void)removeRecord:(NSSet<Record *> *)values;

@end

NS_ASSUME_NONNULL_END
