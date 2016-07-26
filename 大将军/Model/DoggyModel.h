//
//  DoggyModel.h
//  大将军
//
//  Created by 石燚 on 16/7/18.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Context.h"
#import "Owner.h"
#import "Dog.h"
#import "Record.h"


@interface DoggyModel : NSObject

//获取到当前用户信息
+ (Owner *)getOwnerInfo;

//获取用户下的所有狗
+ (NSArray<Dog *> *)getAllDogsWithCurrentOwner;;

//获取当前用户的某只狗
+ (Dog *)getDogWithName:(NSString *)name;

//根据狗狗的名字获取记录
+ (Record *)getRecordWithDoggyName:(NSString *)doggname;

+ (BOOL)insertRecordDogWithppv:(NSNumber *)ppv
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
                           Dog:(NSManagedObject *)dog;

+ (NSArray<Owner *> *)getAllOwners;

@end
