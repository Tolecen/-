//
//  AlertCustomView.h
//  NPLApp
//
//  Created by xiefei on 13-7-3.
//  Copyright (c) 2013年 xiefei. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AlertCustomView : UIView
{
    
    @public
    UILabel* labelArriveDayTime;
    UITableView *aTimeTable;
    NSMutableArray *areaListArray;
    UILabel* labelArriveTime;
    NSMutableDictionary *dateDict;
    UIImageView *imageviewtable;
    id target;
    SEL alertSEL;
    SEL selectDate;
    SEL chooseTimeSEL;
    SEL cancelOrderSEL;
    
}
@property(nonatomic,retain)    NSMutableArray *areaListArray;
-(void)alertShowWith:(NSString *)alertString;

@end
