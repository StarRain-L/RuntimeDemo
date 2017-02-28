//
//  RTPerson+person.m
//  RuntimeDemo
//
//  Created by AAA on 16/3/12.
//  Copyright © 2016年 easywed.cn. All rights reserved.
//

#import "RTPerson+person.h"
#import <objc/runtime.h>

static const char *key = "gender";

@implementation RTPerson (person)

-(NSString *)gender{
    return objc_getAssociatedObject(self, key);
}

-(void)setGender:(NSString *)gender{
    objc_setAssociatedObject(self, key, gender, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
