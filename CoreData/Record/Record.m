//
//  Record.m
//  大将军
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 SingYi. All rights reserved.
//


#import "Record.h"
#import "Dog.h"

@implementation Record

+ (BOOL)insertRecordDogToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                        ppv:(NSNumber *)ppv
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
                                        Dog:(Dog *)dog {
    //传入上下文,创建Dog对象
    NSManagedObject *record = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:ctx];
    
    [record setValue:ppv forKey:@"ppv"];
    [record setValue:distemper forKey:@"distemper"];
    [record setValue:coronavirus forKey:@"coronavirus"];
    [record setValue:rabies forKey:@"rabies"];
    [record setValue:toxoplasma forKey:@"toxoplasma"];
    [record setValue:ininsecticide forKey:@"ininsecticide"];
    [record setValue:pregnant forKey:@"pregnant"];
    [record setValue:delivery forKey:@"delivery"];
    [record setValue:other forKey:@"other"];
    [record setValue:outinsecticide forKey:@"outinsecticide"];
    [record setValue:dog forKey:@"dog"];
    [record setValue:date forKey:@"date"];
    NSError *error = nil;
    BOOL success = [ctx save:&error];
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
    }else {
        return YES;
    }
    return YES;
}

+ (Record *)fetchRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                    DogName:(NSString *)dogName {
    //初始化查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:ctx];
    //设置条件过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", dogName];
    request.predicate = predicate;
    //执行请求
    NSError *error = nil;
    NSArray *objs = [ctx executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@",[error localizedDescription]];
    }
    return [objs firstObject];
}

@end
