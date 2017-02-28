//
//  RTPerson.h
//  RuntimeDemo
//
//  Created by AAA on 16/3/10.
//  Copyright © 2016年 easywed.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTPerson : NSObject<NSCoding>
@property(nonatomic,strong) NSString  *name;
@property (nonatomic, assign) int age;
@property(nonatomic,assign) double   height;
@end
