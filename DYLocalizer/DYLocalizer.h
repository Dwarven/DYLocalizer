//
//  DYLocalizer.h
//  DYLocalizer
//
//  Created by Dwarven on 16/4/11.
//  Copyright © 2016年 Dwarven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYLocalizer : NSObject

+ (void)mergeWithStandardFileURL:(NSURL *)StandardFileURL translateFileURL:(NSURL *)translateFileURL;

@end
