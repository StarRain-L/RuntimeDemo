//
//  ViewController.m
//  RuntimeDemo
//
//  Created by AAA on 16/3/10.
//  Copyright © 2016年 easywed.cn. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "RTPerson.h"
#import "RTPerson+person.h"
#import "NSString+EOCMyAdditions.h"

@interface ViewController ()
@property (nonatomic, strong)NSDate    *date;
@property (nonatomic, strong)NSMutableDictionary    *backingDtore;
@end

@implementation ViewController

@dynamic date;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeMetod];
}
/**
 *  利用KVC修改私有属性
 */
-(void)text0{
    RTPerson *person = [[RTPerson alloc]init];
    [person setValue:@"banana" forKey:@"fruit"];
    NSString *fruit = [person valueForKey:@"fruit"];
    NSLog(@"水果: %@",fruit);
}
/**
 *  遍历一个类的所有成员变量(属性)\所有方法
 */
-(void)test1{
    unsigned int count = 0;
    /*
     第一个参数, 需要获取的类
     第二个参数, 获取到的个数
     */
    Method *methods = class_copyMethodList([RTPerson class], &count);
    for (int i = 0; i < count; i++) {
        // 1.获取遍历到得方法名称
        SEL sel = method_getName(methods[i]);
        // 2.将方法名称转换为字符串
        NSString *methodName = NSStringFromSelector(sel);
        NSLog(@"--%@--",methodName);
    }

}
/**
 *  获取Person中所有的成员变量
 */
-(void)test2{
    unsigned int count = 0;
    Ivar *vars = class_copyIvarList([RTPerson class], &count);
    for (int i = 0; i<count; i++) {
        //1.获取遍历得到成员变量的名字
        const char *varName = ivar_getName(vars[i]);
        //2.将变量名称转换为字符串
        NSString *memberName = [NSString stringWithUTF8String:varName];
        //3.获取成员变量的类型
        const char * varType = ivar_getTypeEncoding(vars[i]);
        //4.输出
        NSLog(@"%@ --- %s",memberName,varType);
        //5.改变属性值
        if ([memberName isEqualToString:@"_name"]) {
            Ivar m_name = vars[i];
            RTPerson *peason = [[RTPerson alloc]init];
            object_setIvar(peason, m_name, @"汤姆");
            NSString *name = [peason valueForKey:@"_name"];
            NSLog(@"修改后的名字:%@",name);
        }
    }
}
/**
 *  获取Person中所有的property属性
 */
-(void)test3{
    unsigned int count = 0;
    objc_property_t *propertes  = class_copyPropertyList([RTPerson class], &count);
    for (int i = 0; i < count; i++) {
        // 1.获取遍历到得属性名称
        const char *propertyName = property_getName(propertes[i]);
        // 2.将属性名称转换为字符串
        NSString *name = [NSString stringWithUTF8String:propertyName];
        // 3.输出
        NSLog(@"--%@",name);
    }
}
/**
 *  利用运行时归档和解档
 */
-(void)test4{
    RTPerson *p = [[RTPerson alloc]init];
    p.name = @"Tom";
    p.age = 26;
    p.height = 170;
    //创建文件夹
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"path"];
    [fileManage createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    //归档
    [NSKeyedArchiver archiveRootObject:p toFile:path];
    //解档
    RTPerson *pp = (RTPerson *)[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"%@",pp.name);
}
/**
 *  动态添加方法
 */

-(void)test5{
    RTPerson *p = [[RTPerson alloc]init];
    //默认RTPerson没有实现eat方法,通过performSelector调用,普通会报错,但是动态的加载方法就不会报错
    [p performSelector:@selector(eat)];
}
/**
 *  给分类添加属性
 */
-(void)test6{
    RTPerson *p = [[RTPerson alloc]init];
    p.gender = @"女";
    NSLog(@"%@",p.gender);
}
/**
 *  交换方法,完全不透明的黑盒方法增加日志记录功能
 */
- (void)changeMetod{
    Method originalMethod = class_getInstanceMethod([NSString class], @selector(lowercaseString));
    Method swappedMethod = class_getInstanceMethod([NSString class], @selector(eoc_myLowercaseString));
    method_exchangeImplementations(originalMethod, swappedMethod);
    NSString *string = @"This iS tHe StRiNg";
    NSString *lowerstring = [string lowercaseString];
}

/**
 *  动态方法解析
 */

//-(void)test7{
//    self.date = [NSDate dateWithTimeIntervalSince1970:475372800];
//    NSLog(@"%@",self.date);
//}
//
//+ (BOOL)resolveInstanceMethod:(SEL)selector {
//    NSString *selectorString = NSStringFromSelector(selector);
//    if ([selectorString hasPrefix:@"set"]) {
//        class_addMethod(self,
//                        selector,
//                        (IMP)autoDictionarySetter,
//                        "v@:@");
//    } else {
//        class_addMethod(self,
//                        selector,
//                        (IMP)autoDictionaryGetter,
//                        "@@:");
//    }
//    return YES;
//}
//
//void autoDictionarySetter(id self, SEL _cmd, id value) {
//    // Get the backing store from the object
//    ViewController *typedSelf = (ViewController*)self;
//    NSMutableDictionary *backingStore = typedSelf.backingDtore;
//    
//    /** The selector will be for example, "setOpaqueObject:".
//     *  We need to remove the "set", ":" and lowercase the first
//     *  letter of the remainder.
//     */
//    NSString *selectorString = NSStringFromSelector(_cmd);
//    NSMutableString *key = [selectorString mutableCopy];
//    
//    // Remove the ':' at the end
//    [key deleteCharactersInRange:NSMakeRange(key.length - 1, 1)];
//    
//    // Remove the 'set' prefix
//    [key deleteCharactersInRange:NSMakeRange(0, 3)];
//    
//    // Lowercase the first character
//    NSString *lowercaseFirstChar =
//    [[key substringToIndex:1] lowercaseString];
//    [key replaceCharactersInRange:NSMakeRange(0, 1)
//                       withString:lowercaseFirstChar];
//    
//    if (value) {
//        [backingStore setObject:value forKey:key];
//    } else {
//        [backingStore removeObjectForKey:key];
//    }
//}
//
//id autoDictionaryGetter(id self, SEL _cmd) {
//    // Get the backing store from the object
//    ViewController *typedSelf = (ViewController*)self;
//    NSMutableDictionary *backingStore = typedSelf.backingDtore;
//    
//    // The key is simply the selector name
//    NSString *key = NSStringFromSelector(_cmd);
//    
//    // Return the value
//    return [backingStore objectForKey:key];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
