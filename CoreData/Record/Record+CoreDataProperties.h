//
//  Record+CoreDataProperties.h
//  大将军
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 SingYi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Record.h"

NS_ASSUME_NONNULL_BEGIN

@interface Record (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *coronavirus;      //冠状病毒
@property (nullable, nonatomic, retain) NSNumber *delivery;         //分娩
@property (nullable, nonatomic, retain) NSNumber *distemper;        //犬瘟热
@property (nullable, nonatomic, retain) NSNumber *ininsecticide;    //体内驱虫
@property (nullable, nonatomic, retain) NSNumber *neutering;        //绝育
@property (nullable, nonatomic, retain) NSString *other;            //其他
@property (nullable, nonatomic, retain) NSNumber *outinsecticide;   //体外驱虫
@property (nullable, nonatomic, retain) NSNumber *ppv;              //细小病毒
@property (nullable, nonatomic, retain) NSNumber *pregnant;         //怀孕
@property (nullable, nonatomic, retain) NSNumber *rabies;           //狂犬病
@property (nullable, nonatomic, retain) NSNumber *toxoplasma;       //弓形虫
@property (nullable, nonatomic, retain) NSDate *date;               //时间
@property (nullable, nonatomic, retain) Dog *dog;

@end

NS_ASSUME_NONNULL_END
