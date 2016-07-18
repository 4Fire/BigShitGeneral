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
+ (NSArray<Dog *> *)getAllDogsWithCurrentOwner:(Owner *)owner;

//获取当前用户的某只狗
+ (Dog *)getDogWithName:(NSString *)name;

+ (NSArray<Owner *> *)getAllOwners;

@end
