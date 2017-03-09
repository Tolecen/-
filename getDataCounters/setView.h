//
//  setView.h
//  getDataCounters
//
//  Created by 刘佳男 on 14/11/1.
//  Copyright (c) 2014年 liujianan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setViewDelegate <NSObject>

- (void)buttonPressedTotal:(double)total WithUsing:(double)using WithOK:(BOOL)ok;

@end


@interface setView : UIView<UITextFieldDelegate>

@property(nonatomic,strong)id<setViewDelegate> delegate;

@end
