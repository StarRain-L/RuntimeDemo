//
//  NSString+EOCMyAdditions.m
//  RuntimeDemo
//
//  Created by jr on 16/11/7.
//  Copyright © 2016年 easywed.cn. All rights reserved.
//

#import "NSString+EOCMyAdditions.h"

@implementation NSString (EOCMyAdditions)
- (NSString *)eoc_myLowercaseString{
    NSString *lowercase = [self eoc_myLowercaseString];
    NSLog(@"%@ => %@",self,lowercase);
    return lowercase;
}
@end
