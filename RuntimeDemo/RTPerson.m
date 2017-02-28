//
//  RTPerson.m
//  RuntimeDemo
//
//  Created by AAA on 16/3/10.
//  Copyright © 2016年 easywed.cn. All rights reserved.
//

#import "RTPerson.h"
#import <objc/runtime.h>

@interface RTPerson(){
  
    NSString *fruit;
    
 
}

@end

@implementation RTPerson


//-(void)encodeWithCoder:(NSCoder *)encoder
//{
//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList([RTPerson class], &count);
//    
//    for (int i = 0; i<count; i++) {
//        
//        // 取出i位置对应的成员变量
//        Ivar ivar = ivars[i];
//        
//        // 查看成员变量
//        const char *name = ivar_getName(ivar);
//        
//        // 归档
//        NSString *key = [NSString stringWithUTF8String:name];
//        id value = [self valueForKey:key];
//        [encoder encodeObject:value forKey:key];
//    }
//    
//    free(ivars); 
//}
////解档
//-(id)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init]) {
//        
//        unsigned int count = 0;
//        Ivar *ivars = class_copyIvarList([RTPerson class], &count);
//        
//        for (int i = 0; i<count; i++) {
//            // 取出i位置对应的成员变量
//            Ivar ivar = ivars[i];
//            
//            // 查看成员变量
//            const char *name = ivar_getName(ivar);
//            
//            // 归档
//            NSString *key = [NSString stringWithUTF8String:name];
//            id value = [decoder decodeObjectForKey:key];
//            
//            // 设置到成员变量身上
//            [self setValue:value forKey:key];
//        }
//        
//    } 
//    return self; 
//}
//
//归档
- (void)encodeWithCoder:(NSCoder *)encoder
{
    unsigned int count = 0;
    // 1.取出所有的属性
    objc_property_t *propertes = class_copyPropertyList([self class], &count);
    // 2.遍历所有的属性
    for (int i = 0; i < count; i++) {
        // 获取当前遍历到的属性名称
        const char *propertyName = property_getName(propertes[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        // 利用KVC取出对应属性的值
        id value = [self valueForKey:name];
        // 归档到文件中
        [encoder encodeObject:value forKey:name];
    }
}
//解档
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        unsigned int count = 0;
        // 1.取出所有的属性
        objc_property_t *propertes = class_copyPropertyList([self class], &count);
        // 2.遍历所有的属性
        for (int i = 0; i < count; i++) {
            // 获取当前遍历到的属性名称
            const char *propertyName = property_getName(propertes[i]);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            // 解归档当前遍历到得属性的值
            id value = [decoder decodeObjectForKey:name];
            //            self.className = [decoder decodeObjectForKey:@"className"];
            // 利用KVC给属性设值
            [self setValue:value forKey:name];
        }
    }
    return self;
}

@end
