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
    return [Dog fetchAllDogsFromSQLiterWithContext:ctx withOwner:owner];
}

+ (Dog *)getDogWithName:(NSString *)name {
    return [Dog fetchDogFromSQLiterWithContext:[Context context] Name:name owner:[DoggyModel getOwnerInfo]];
}

//有点问题:
+ (NSArray<Owner *> *)getAllOwners {
    return [Owner fetchAllOwnerSToSQLiterWithContext:[Context context]];
}

+ (Record *)getRecordWithDoggyName:(Dog *)dog date:(NSDate *)date{
    return [Record fetchRecordToSQLiterWithContext:[Context context] RecordDate:date Dog:dog];
}

+ (NSMutableDictionary *)DictionartFromRecord:(Record *)record WithDog:(Dog *)dog {
    NSMutableDictionary *dogDic = nil;
    if (dog.sex.integerValue == 1) {
        dogDic = [@{@"体内驱虫":record.ininsecticide,@"体外驱虫":record.outinsecticide,@"细小病毒免疫":record.ppv,@"犬瘟热病毒免疫":record.distemper,@"冠状病毒免疫":record.coronavirus,@"狂犬病疫苗":record.rabies,@"弓形虫疫苗":record.toxoplasma} mutableCopy];
        if (dog.neutering == 0) {
            [dogDic setObject:record.neutering forKey:@"绝育"];
        }
    } else {
        dogDic = [@{@"体内驱虫":record.ininsecticide,@"体外驱虫":record.outinsecticide,@"细小病毒免疫":record.ppv,@"犬瘟热病毒免疫":record.distemper,@"冠状病毒免疫":record.coronavirus,@"狂犬病疫苗":record.rabies,@"弓形虫疫苗":record.toxoplasma,@"怀孕":record.pregnant,@"分娩":record.delivery} mutableCopy];
        if (dog.neutering == 0) {
            [dogDic setObject:record.neutering forKey:@"绝育"];
        }
    }
    
    return [dogDic mutableCopy];
}

+ (BOOL)insertRecordDogWithppv:(NSNumber *)ppv distemper:(NSNumber *)distemper coronavirus:(NSNumber *)coronavirus rabies:(NSNumber *)rabies toxoplasma:(NSNumber *)toxoplasma ininsecticide:(NSNumber *)ininsecticide outinsecticide:(NSNumber *)outinsecticide pregnant:(NSNumber *)pregnant delivery:(NSNumber *)delivery neutering:(NSNumber *)neutering date:(NSDate *)date other:(NSString *)other Dog:(Dog *)dog {
    
    return [Record insertRecordDogToSQLiterWithContext:[Context context] ppv:ppv distemper:distemper coronavirus:coronavirus rabies:rabies toxoplasma:toxoplasma ininsecticide:ininsecticide outinsecticide:outinsecticide pregnant:pregnant delivery:delivery neutering:neutering date:date other:other Dog:dog];
}


@end
