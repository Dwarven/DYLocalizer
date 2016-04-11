//
//  DYLocalizer.m
//  DYLocalizer
//
//  Created by Dwarven on 16/4/11.
//  Copyright © 2016年 Dwarven. All rights reserved.
//

#import "DYLocalizer.h"

@implementation DYLocalizer

+ (void)saveFile:(NSString *)path withString:(NSString *)str{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //查找文件，如果不存在，就创建一个文件
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    
    [[str dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
}

+ (NSDictionary *)getDicWithFile:(NSString *)path{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    NSMutableData * data = [NSMutableData dataWithContentsOfFile:path];
    
    NSMutableString * str = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    str = [NSMutableString stringWithFormat:@"\n%@",str];
    
    int smailNumber = 0;
    int biggerNumber = 0;
    for (int i = 0; i < [str length]; i ++ ) {
        if ([[str substringWithRange:NSMakeRange(i , 1)] isEqualToString:@"\n"]) {
            smailNumber = biggerNumber;
            biggerNumber = i;
            if (smailNumber != biggerNumber) {
                //如果是需要处理的一行
                if ([[str substringWithRange:NSMakeRange(smailNumber + 1 , 1)] isEqualToString:@"\""]) {
                    int a[4] = {1,1,1,1};
                    for (int j = 1; j < biggerNumber - smailNumber; j++) {
                        //发现双引号
                        if ([[str substringWithRange:NSMakeRange(smailNumber + j , 1)] isEqualToString:@"\""]) {
                            //检测双引号前边紧挨着有几个斜杠
                            for ( int k = 1; k <= j ; k++ ) {
                                NSMutableString * lineStr = [[NSMutableString alloc] init];
                                for (int l = 0 ; l < k  ; l++ ) {
                                    [lineStr appendString:@"\\"];
                                }
                                
                                if (![[str substringWithRange:NSMakeRange(smailNumber + j - k , k)] isEqualToString:lineStr]) {
                                    //如果k为奇数说明斜杠有偶数个,需要记录位置
                                    if (k % 2 == 1) {
                                        if (a[1] == 1) {
                                            a[1] = j;
                                        }else if (a[2] == 1) {
                                            a[2] = j;
                                        }else if (a[3] == 1) {
                                            a[3] = j;
                                        }
                                    }
                                    break;
                                }
                            }
                        }
                    }
                    
                    NSString * key = [str substringWithRange:NSMakeRange(smailNumber+a[0]+1, a[1]-a[0]-1)];
                    NSString * value = [str substringWithRange:NSMakeRange(smailNumber+a[2]+1, a[3]-a[2]-1)];
                    
                    [dic setObject:value forKey:key];
                    
                }
            }
        }
    }
    
    return [dic copy];
}

+ (void)mergeWithStandardFileURL:(NSURL *)standardFileURL translateFileURL:(NSURL *)translateFileURL {
    NSDictionary * dic = [self getDicWithFile:[translateFileURL path]];
    
    NSString *standardFilePath = [standardFileURL path];
    NSString *newFilePath = [NSString stringWithFormat:@"%@-new",standardFilePath];
    NSString *todoFilePath = [NSString stringWithFormat:@"%@-todo",standardFilePath];
    
#pragma mark - load standard file
    NSMutableData * data = [NSMutableData dataWithContentsOfFile:standardFilePath];
    NSMutableString * str = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    str = [NSMutableString stringWithFormat:@"\n%@",str];
    NSMutableString * todoStr = [[NSMutableString alloc] init];
    
#pragma mark - compare text
    int smailNumber = 0;
    int biggerNumber = 0;
    for (int i = 0; i < [str length]; i ++ ) {
        if ([[str substringWithRange:NSMakeRange(i , 1)] isEqualToString:@"\n"]) {
            smailNumber = biggerNumber;
            biggerNumber = i;
            if (smailNumber != biggerNumber) {
                
                //如果是需要处理的一行
                if ([[str substringWithRange:NSMakeRange(smailNumber + 1 , 1)] isEqualToString:@"\""]) {
                    
                    int a[4] = {1,1,1,1};
                    
                    for (int j = 1; j < biggerNumber - smailNumber; j++) {
                        
                        //发现双引号
                        if ([[str substringWithRange:NSMakeRange(smailNumber + j , 1)] isEqualToString:@"\""]) {
                            
                            //检测双引号前边紧挨着有几个斜杠
                            for ( int k = 1; k <= j ; k++ ) {
                                
                                NSMutableString * lineStr = [[NSMutableString alloc] init];
                                
                                for (int l = 0 ; l < k  ; l++ ) {
                                    [lineStr appendString:@"\\"];
                                }
                                
                                if (![[str substringWithRange:NSMakeRange(smailNumber + j - k , k)] isEqualToString:lineStr]) {
                                    //如果k为奇数说明斜杠有偶数个,需要记录位置
                                    if (k % 2 == 1) {
                                        if (a[1] == 1) {
                                            a[1] = j;
                                        }else if (a[2] == 1) {
                                            a[2] = j;
                                        }else if (a[3] == 1) {
                                            a[3] = j;
                                        }
                                    }
                                    break;
                                }
                            }
                        }
                    }
                    
                    NSString * key = [str substringWithRange:NSMakeRange(smailNumber+a[0]+1, a[1]-a[0]-1)];
                    NSString * value = [str substringWithRange:NSMakeRange(smailNumber+a[2]+1, a[3]-a[2]-1)];
                    NSString * string = [dic valueForKey:key];
                    
                    if (string && ![value isEqualTo:string]) {
                        [str replaceCharactersInRange:NSMakeRange(smailNumber+1+a[2], a[3] - a[2] -1) withString:string];
                        i += [string length] - (a[3] - a[2] - 1);
                        biggerNumber += [string length] - (a[3] - a[2] - 1);
                    }else{
                        [todoStr appendString:[str substringWithRange:NSMakeRange(smailNumber+1, biggerNumber - smailNumber - 1)]];
                        [todoStr appendString:@"\n"];
                    }
                }
            }
        }
    }
    
    if (standardFilePath) {
        [self saveFile:newFilePath withString:str];
        [self saveFile:todoFilePath withString:todoStr];
    }
}

@end
