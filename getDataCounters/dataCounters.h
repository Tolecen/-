//
//  dataCounters.h
//  getDataCounters
//
//  Created by 刘佳男 on 14/10/29.
//  Copyright (c) 2014年 liujianan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataCounters : NSObject

@property (nonatomic) double totalCounters;
@property (nonatomic) double usingCounters;
@property (nonatomic) double currentCounters;
@property (nonatomic,strong) NSDate *nextClearDate;

-(dataCounters *)initTotal:(double)total withUsing:(double)using withDate:(NSDate *)clearDate;
-(void)showAllCount;
-(void)startDataCounters;
@end
