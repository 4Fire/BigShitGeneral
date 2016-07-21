//
//  Record+CoreDataProperties.h
//  大将军
//
//  Created by 石燚 on 16/7/21.
//  Copyright © 2016年 SingYi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Record.h"

NS_ASSUME_NONNULL_BEGIN

@interface Record (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *coronavirus;
@property (nullable, nonatomic, retain) NSNumber *delivery;
@property (nullable, nonatomic, retain) NSNumber *distemper;
@property (nullable, nonatomic, retain) NSNumber *ininsecticide;
@property (nullable, nonatomic, retain) NSNumber *neutering;
@property (nullable, nonatomic, retain) NSString *other;
@property (nullable, nonatomic, retain) NSNumber *outinsecticide;
@property (nullable, nonatomic, retain) NSNumber *ppv;
@property (nullable, nonatomic, retain) NSNumber *pregnant;
@property (nullable, nonatomic, retain) NSNumber *rabies;
@property (nullable, nonatomic, retain) NSNumber *toxoplasma;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) Dog *dog;

@end

NS_ASSUME_NONNULL_END
