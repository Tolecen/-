//
//  AlertCustomView.m
//  NPLApp
//
//  Created by xiefei on 13-7-3.
//  Copyright (c) 2013年 xiefei. All rights reserved.
//

#import "AlertCustomView.h"
@implementation AlertCustomView
@synthesize areaListArray;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        dateDict=[[NSMutableDictionary alloc] init];
        
        // Initialization code
    }
    return self;
}

-(void)alertShowWith:(NSString *)alertString
{
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    if ([UIScreen mainScreen].bounds.size.height>530.0f) {
        
        UIImageView *backImageViewTotal=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 548.0f)];
        [backImageViewTotal setBackgroundColor:[UIColor clearColor]];
        [backImageViewTotal setImage:[UIImage imageNamed:@"alertbackground.png"]];
        [self addSubview:backImageViewTotal];
        [backImageViewTotal release];
        
        
    }else
    {
        
        UIImageView *backImageViewTotal=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 460.0f)];
        [backImageViewTotal setBackgroundColor:[UIColor clearColor]];
        [backImageViewTotal setImage:[UIImage imageNamed:@"alertbackground.png"]];
        [self addSubview:backImageViewTotal];
        [backImageViewTotal release];
        
    }
    
    
    UIImageView *backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(28.50f, 120.0f, 263.0f,164.0f)];
    [backImageView setBackgroundColor:[UIColor clearColor]];
    [backImageView setImage:[UIImage imageNamed:@"alertbackimage.png"]];
    [self addSubview:backImageView];
    [backImageView release];
    
    
    UITextView* labelArea=[[UITextView alloc] initWithFrame:CGRectMake(25.0f, 155.0f, self.frame.size.width-50.0f, 70)];
    [labelArea setText:alertString];
    labelArea.userInteractionEnabled=NO;
    labelArea.textAlignment=1;
    labelArea.font=[UIFont boldSystemFontOfSize:16];
    [labelArea setBackgroundColor:[UIColor clearColor]];
    [self addSubview:labelArea];
    [labelArea release];
    
    
    UIButton* submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setImage:[UIImage imageNamed:@"confirmalert.png"] forState:UIControlStateNormal];
    [submitBtn setFrame:CGRectMake((self.frame.size.width-86.0f)/2.0f, 230.0f, 172.0f/2.0f, 75.0f/2.0f)];
    [submitBtn setBackgroundColor:[UIColor clearColor]];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitBtn];
    
    
}

-(void)alertShowWithConfirmAndCancel:(NSString *)alertString
{
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    if ([UIScreen mainScreen].bounds.size.height>530.0f) {
        
        UIImageView *backImageViewTotal=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 548.0f)];
        [backImageViewTotal setBackgroundColor:[UIColor clearColor]];
        [backImageViewTotal setImage:[UIImage imageNamed:@"alertbackground.png"]];
        [self addSubview:backImageViewTotal];
        [backImageViewTotal release];
        
        
    }else
    {
        
        UIImageView *backImageViewTotal=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 460.0f)];
        [backImageViewTotal setBackgroundColor:[UIColor clearColor]];
        [backImageViewTotal setImage:[UIImage imageNamed:@"alertbackground.png"]];
        [self addSubview:backImageViewTotal];
        [backImageViewTotal release];
        
    }
    
    
    UIImageView *backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(28.50f, 120.0f, 263.0f,164.0f)];
    [backImageView setBackgroundColor:[UIColor clearColor]];
    [backImageView setImage:[UIImage imageNamed:@"alertbackimage.png"]];
    [self addSubview:backImageView];
    [backImageView release];
    
    
    
    UITextView* labelArea=[[UITextView alloc] initWithFrame:CGRectMake(25.0f, 155.0f, self.frame.size.width-50.0f, 70)];
    [labelArea setText:alertString];
    labelArea.userInteractionEnabled=NO;
    labelArea.textAlignment=1;
    labelArea.font=[UIFont boldSystemFontOfSize:16];
    [labelArea setBackgroundColor:[UIColor clearColor]];
    [self addSubview:labelArea];
    [labelArea release];
    
    
    
    UIButton* confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setImage:[UIImage imageNamed:@"emptyConfirmBtn.png"] forState:UIControlStateNormal];
    [confirmBtn setFrame:CGRectMake(75.0f, 230.0f, 118.0f/2.0f, 44.0f/2.0f)];
    [confirmBtn setBackgroundColor:[UIColor clearColor]];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
    
    
    UIButton* cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage imageNamed:@"emptyCancelBtn.png"] forState:UIControlStateNormal];
    [cancelBtn setFrame:CGRectMake(confirmBtn.frame.origin.x+confirmBtn.frame.size.width+40.0f, confirmBtn.frame.origin.y, 118.0f/2.0f, 44.0f/2.0f)];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    [cancelBtn addTarget:self action:@selector(cancelConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
}

-(void)confirmBtnClick
{
    
    self.hidden=YES;

    if (target!=nil&&alertSEL!=nil&&[target respondsToSelector:alertSEL]) {
        [target performSelector:alertSEL withObject:nil];
    }

    
}
-(void)cancelConfirmBtnClick
{
    self.hidden=YES;

    if (target!=nil&&cancelOrderSEL!=nil&&[target respondsToSelector:cancelOrderSEL]) {
        [target performSelector:cancelOrderSEL withObject:nil];
    }
    
}
-(void)submitBtnClick
{
    if (target!=nil&&alertSEL!=nil&&[target respondsToSelector:alertSEL]) {
        [target performSelector:alertSEL];
    }
    self.hidden=YES;
}

-(void)cancelOrderBtnClick
{
    
    
    NSNumber *numberObj=[NSNumber numberWithInt:self.tag];
    if (target!=nil&&cancelOrderSEL!=nil&&[target respondsToSelector:cancelOrderSEL]) {
        [target performSelector:cancelOrderSEL withObject:numberObj];
    }
    
    self.hidden=YES;
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
