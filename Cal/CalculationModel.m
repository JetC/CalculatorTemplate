//
//  CalculationModel.m
//  Cal
//
//  Created by 孙培峰 on 12/5/14.
//  Copyright (c) 2014 mac. All rights reserved.
//

#import "CalculationModel.h"

@interface CalculationModel()

@property (nonatomic, strong) NSMutableArray *numbersArray;
@property (nonatomic, strong) NSMutableArray *operatorArray;

@end

@implementation CalculationModel

- (double)calculateResultWithString:(NSString *)string
{
    //存放数字的Array
    NSMutableArray *numberArray = [[NSMutableArray alloc]init];
    //声明字符集，用来在下面的步骤中为系统指明要用什么字符进行分割
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"+-*/"];
    //用 characterSet 分割 string, 存到 numberArray 中,其中 mutableCopy 是把 NSArray 类型转换为 NSMutableArray 类型
    numberArray = [[string componentsSeparatedByCharactersInSet:characterSet] mutableCopy];
    //把 numberArray 存到类的实例变量里
    self.numbersArray = numberArray;
    
    //存放运算符的Array
    NSMutableArray *operatorsArray = [[NSMutableArray alloc]init];
    //循环 string.length 次,保证把 string 遍历一遍
    for (NSInteger i = 0; i < string.length; i++) {
        //类似 char 的东西, 本质是unsigned short. 因为characterAtIndex返回的只能是 unichar, 所以我们要适应这个,用一个 unichar 类型的 tempChar 来存储它
        unichar tempChar = [string characterAtIndex:i];
        if (tempChar == '+' || tempChar == '-' || tempChar == '*'|| tempChar == '/') {
            [operatorsArray addObject:[NSString stringWithFormat:@"%c",tempChar]] ;
        }
    }
    //存到类的实例变量里
    self.operatorArray = operatorsArray;
    for (NSInteger i = 0; i < self.operatorArray.count; i++) {
        
        double tempResult = 0.0;
        
        if ([self.operatorArray[i] isEqualToString:@"*"]) {
            
                if ([self.operatorArray[i+1] isEqualToString:@"*"]||[self.operatorArray[i+1] isEqualToString:@"/"]){
                    for (NSInteger n = 0;[self.operatorArray[i+1] isEqualToString:@"*"]||[self.operatorArray[i+1] isEqualToString:@"/"] ; n++) {
                        

                    tempResult = [self.numbersArray[i] doubleValue]*[self.numbersArray[i+1] doubleValue];
                    self.numbersArray[i] = [NSString stringWithFormat:@"%lf",tempResult];
                    [self.numbersArray removeObjectAtIndex:i+1];
                    }
                }
            
                else if ([self.operatorArray[i+1] isEqualToString:@"+"] || [self.operatorArray[i+1] isEqualToString:@"-"]) {
                    tempResult = [self.numbersArray[i] doubleValue]*[self.numbersArray[i+1] doubleValue];
                    self.numbersArray[i] = [NSString stringWithFormat:@"%lf",tempResult];
                    [self.numbersArray removeObjectAtIndex:i+1];
                    [self.operatorArray removeObjectAtIndex:i];
                    
                }

            
        
        
        else if ([self.operatorArray[i] isEqualToString:@"/"]) {
            for (NSInteger n = 0;[self.operatorArray[i+1] isEqualToString:@"*"]||[self.operatorArray[i+1] isEqualToString:@"/"] ; n++) {
                
                
                if ([self.operatorArray[i+1] isEqualToString:@"+"] || [self.operatorArray[i+1] isEqualToString:@"-"]) {
                    tempResult = [self.numbersArray[i] doubleValue]/[self.numbersArray[i+1] doubleValue];
                    self.numbersArray[i] = [NSString stringWithFormat:@"%lf",tempResult];
                    [self.numbersArray removeObjectAtIndex:i+1];
                    [self.operatorArray removeObjectAtIndex:i+n];
                    
                }
                else if ([self.operatorArray[i+1] isEqualToString:@"*"]||[self.operatorArray[i+1] isEqualToString:@"/"]){
                    tempResult = [self.numbersArray[i] doubleValue]/[self.numbersArray[i+1] doubleValue];
                    self.numbersArray[i] = [NSString stringWithFormat:@"%lf",tempResult];
                    [self.numbersArray removeObjectAtIndex:i+1];
                }
                tempResult = [self.numbersArray[i] doubleValue]*[self.numbersArray[i+1] doubleValue];
                self.numbersArray[i] = [NSString stringWithFormat:@"%lf",tempResult];
                [self.numbersArray removeObjectAtIndex:i+1];
            }
        }
        
        
    }
    }
    for (NSInteger i = 0; i < self.operatorArray.count; i++) {
        
        double tempResult = 0.0;
        
        if ([self.operatorArray[i] isEqualToString:@"+"]) {
            tempResult = [self.numbersArray[i] doubleValue]+[self.numbersArray[i+1] doubleValue];
            self.numbersArray[i] = [NSString stringWithFormat:@"%lf",tempResult];
            [self.numbersArray removeObjectAtIndex:i+1];
            [self.operatorArray removeObjectAtIndex:i];
        }
        for (NSInteger i = 0; i < self.operatorArray.count; i++) {
            
            double tempResult = 0.0;
            
            if ([self.operatorArray[i] isEqualToString:@"-"]) {
                tempResult = [self.numbersArray[i] doubleValue]-[self.numbersArray[i+1] doubleValue];
                self.numbersArray[i] = [NSString stringWithFormat:@"%lf",tempResult];
                [self.numbersArray removeObjectAtIndex:i+1];
                [self.operatorArray removeObjectAtIndex:i];
            }
            
        
    }
    }
    
    /**
     
     至此,我们在@property内部拥有了两个 MutableArray, 一个存储了全部的数字,另一个存储了全部的运算符
     在下一步的计算中,加减和乘除,推荐先做乘除,再做加减.其中乘除里要考虑多个数字连乘时要怎么处理
     不会的就在纸上画一下可能的处理过程,相信各位的逻辑能力能够驾驭得住╰(￣▽￣)╮
     
     
     提供一个连乘的处理思路是:遍历运算符 Array 时,找到第一个乘或除号时,视为一次连乘(除)操作的开始,一次这样的操作中要做的有:
     
     声明使用一个变量记录本次连乘中包含了多少个乘或除号,直到遇到加号或减号时视为本次连乘(除)操作结束,从@property的数字和运算符Array中删除本次操作中用过的数字和操作符,再将本次操作结果加入到数字Array中的合适位置,将+操作符插入到运算符Array的合适位置
     
     之后再在运算符 Array 中搜索下一个乘或除号,再开始下一次连乘(除)操作
     
     */
    
    
    return 0.0;
}
- (void)example
{
    //示例代码
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    double i = 100;
    //其中[NSNumber numberWithDouble:i]即为生成一个 NSNumber 类型的量,使得我将数字加入 Array 中
    [array addObject:[NSNumber numberWithDouble:i]];
    //在 array 的第3位加入一个对象
    [array insertObject:[NSNumber numberWithDouble:i] atIndex:2];
    
    double i2 = 0;
    //取array里的第1个元素,就是我们刚才存入的NSNumber类型的量,对其使用floatValue方法即得到 double 类型的值
    i2 = [[array objectAtIndex:0] doubleValue];
}
@end



