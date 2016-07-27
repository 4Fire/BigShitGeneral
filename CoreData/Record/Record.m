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
    Record *record = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:ctx];
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
    [record setValue:date forKey:@"date"];
    record.dog = dog;
    [dog addRecordObject:record];
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
                                 RecordDate:(NSDate *)date
                                        Dog:(Dog *)dog {
    //初始化查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:ctx];
    //设置条件过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"dog.name == %@ and date == %@ " , [dog valueForKey:@"name"], date];
    request.predicate = predicate;
    //执行请求
    NSError *error = nil;
    NSArray *objs = [ctx executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@",[error localizedDescription]];
    }
    return [objs firstObject];
}

+ (Record *)fetchLastRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                        Dog:(Dog *)dog {
    //初始化查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:ctx];
    //设置条件过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"dog.name == %@", [dog valueForKey:@"name"]];
    request.predicate = predicate;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];

    //执行请求
    NSError *error = nil;
    NSArray<Record *> *objs = [ctx executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@",[error localizedDescription]];
    }
    [objs enumerateObjectsUsingBlock:^(Record * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"=================%@", obj.date);
    }];
    return [objs firstObject];
}

//细小
+ (Record *)fetchPPVRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                            Dog:(Dog *)dog {
    //初始化查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:ctx];
    //设置条件过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"dog.name == %@ and ppv == 1", [dog valueForKey:@"name"]];
    request.predicate = predicate;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    //执行请求
    NSError *error = nil;
    NSArray<Record *> *objs = [ctx executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@",[error localizedDescription]];
    }
    [objs enumerateObjectsUsingBlock:^(Record * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"=================%@", obj.date);
    }];
    return [objs firstObject];
}

//犬瘟热
+ (Record *)fetchDistemperRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                           Dog:(Dog *)dog {
    //初始化查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:ctx];
    //设置条件过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"dog.name == %@ and distemper == 1", [dog valueForKey:@"name"]];
    request.predicate = predicate;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    //执行请求
    NSError *error = nil;
    NSArray<Record *> *objs = [ctx executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@",[error localizedDescription]];
    }
    [objs enumerateObjectsUsingBlock:^(Record * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        NSLog(@"=================%@", obj.date);
    }];
    return [objs firstObject];
}

//冠状病毒
+ (Record *)fetchCoronavirusRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                                 Dog:(Dog *)dog {
    //初始化查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:ctx];
    //设置条件过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"dog.name == %@ and coronavirus == 1", [dog valueForKey:@"name"]];
    request.predicate = predicate;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    //执行请求
    NSError *error = nil;
    NSArray<Record *> *objs = [ctx executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@",[error localizedDescription]];
    }
    [objs enumerateObjectsUsingBlock:^(Record * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        NSLog(@"=================%@", obj.date);
    }];
    return [objs firstObject];
}

//狂犬病
+ (Record *)fetchRabiesRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                                   Dog:(Dog *)dog {
    //初始化查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:ctx];
    //设置条件过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"dog.name == %@ and rabies == 1", [dog valueForKey:@"name"]];
    request.predicate = predicate;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    //执行请求
    NSError *error = nil;
    NSArray<Record *> *objs = [ctx executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@",[error localizedDescription]];
    }
    [objs enumerateObjectsUsingBlock:^(Record * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        NSLog(@"=================%@", obj.date);
    }];
    return [objs firstObject];
}

//弓形虫
+ (Record *)fetchToxoplasmaRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                                   Dog:(Dog *)dog {
    //初始化查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:ctx];
    //设置条件过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"dog.name == %@ and toxoplasma == 1", [dog valueForKey:@"name"]];
    request.predicate = predicate;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    //执行请求
    NSError *error = nil;
    NSArray<Record *> *objs = [ctx executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@",[error localizedDescription]];
    }
    [objs enumerateObjectsUsingBlock:^(Record * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        NSLog(@"=================%@", obj.date);
    }];
    return [objs firstObject];
}

//体内驱虫
+ (Record *)fetchIninsecticideRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                                     Dog:(Dog *)dog {
    //初始化查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:ctx];
    //设置条件过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"dog.name == %@ and ininsecticide == 1", [dog valueForKey:@"name"]];
    request.predicate = predicate;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    //执行请求
    NSError *error = nil;
    NSArray<Record *> *objs = [ctx executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@",[error localizedDescription]];
    }
    [objs enumerateObjectsUsingBlock:^(Record * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        NSLog(@"=================%@", obj.date);
    }];
    return [objs firstObject];
}

//体外驱虫
+ (Record *)fetchOutinsecticideRecordToSQLiterWithContext:(NSManagedObjectContext *)ctx
                                                   Dog:(Dog *)dog {
    //初始化查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:ctx];
    //设置条件过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"dog.name == %@ and outinsecticide == 1", [dog valueForKey:@"name"]];
    request.predicate = predicate;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    //执行请求
    NSError *error = nil;
    NSArray<Record *> *objs = [ctx executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@",[error localizedDescription]];
    }
    [objs enumerateObjectsUsingBlock:^(Record * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        NSLog(@"=================%@", obj.date);
    }];
    return [objs firstObject];
}


@end
