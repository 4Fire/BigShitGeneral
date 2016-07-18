//
//  DoggyModel.m
//  大将军
//
//  Created by 石燚 on 16/7/18.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "DoggyModel.h"


@implementation DoggyModel

+ (Owner *)getOwnerInfo {
    NSManagedObjectContext *context = [Context context];
    NSString *ownerAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"];
    Owner *owner = [Owner fetchOwnerToSQLiterWithContext:context Account:ownerAccount];
    if (owner != nil) {
        return owner;
    } else {
        return nil;
    }
}

+ (NSArray<Dog *> *)getAllDogsWithCurrentOwner {
    NSArray<Dog *> *array = [Dog fetchAllDogsFromSQLiterWithContext:[Context context] withOwner:[DoggyModel getOwnerInfo]];
    return array;
}

+ (Dog *)getDogWithName:(NSString *)name {
    return [Dog fetchDogFromSQLiterWithContext:[Context context] Name:name owner:[DoggyModel getOwnerInfo]];
}

//有点问题:
+ (NSArray<Owner *> *)getAllOwners {
    return [Owner fetchAllOwnerSToSQLiterWithContext:[Context context]];
}



@end
