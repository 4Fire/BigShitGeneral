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
    return owner;
}

+ (NSArray<Dog *> *)getAllDogsWithCurrentOwner {
    NSManagedObjectContext *ctx = [Context context];
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"];
    Owner *owner = [Owner fetchOwnerToSQLiterWithContext:ctx Account:account];
    NSArray<Dog *> *dogs = [Dog fetchAllDogsFromSQLiterWithContext:ctx withOwner:owner];
    NSLog(@"#######%@",dogs);
    return dogs;
}

+ (Dog *)getDogWithName:(NSString *)name {
    return [Dog fetchDogFromSQLiterWithContext:[Context context] Name:name owner:[DoggyModel getOwnerInfo]];
}

//有点问题:
+ (NSArray<Owner *> *)getAllOwners {
    return [Owner fetchAllOwnerSToSQLiterWithContext:[Context context]];
}



@end
