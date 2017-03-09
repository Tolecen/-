//
//  setView.m
//  getDataCounters
//
//  Created by 刘佳男 on 14/11/1.
//  Copyright (c) 2014年 liujianan. All rights reserved.
//

#import "setView.h"

#define TOP_MARGIN                  0
#define BUTTOM_MARGIN               8
#define LEFT_MARGIN                 15
#define WIDGET_MARGIN               30
#define RIGHT_MARGIN                15





@interface setView()
{
    UILabel *titleLabel;
    UILabel *setTotalLabel;
    UILabel *setUsingLabel;
    UITextField *setTotalField;
    UITextField *setUsinField;
    UIButton *button;
    UIButton *cancelButton;
}
@end

@implementation setView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        titleLabel = [[UILabel alloc] init];
        setTotalLabel = [[UILabel alloc] init];
        setUsingLabel = [[UILabel alloc] init];
        setTotalField = [[UITextField alloc] init];
        setUsinField = [[UITextField alloc] init];
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [self setShowFrame:frame];
        [self setShowAttribute];
        
        [self addSubview:titleLabel];
        [self addSubview:setTotalField];
        [self addSubview:setTotalLabel];
        [self addSubview:setUsinField];
        [self addSubview:setUsingLabel];
        [self addSubview:button];
        [self addSubview:cancelButton];
    }
    
    return self;
}

- (void)setShowFrame:(CGRect)frame
{
    float height = self.frame.size.height*0.25;
    titleLabel.frame = CGRectMake(0.0f, TOP_MARGIN, frame.size.width, height);
    
    setTotalLabel.frame = CGRectMake(LEFT_MARGIN, height, self.frame.size.width/2.0f, height);
    setTotalField.frame = CGRectMake(0.0f+self.frame.size.width/2.0f, height, self.frame.size.width/2.0f-LEFT_MARGIN, 20.0f);
    setTotalField.center = CGPointMake(setTotalField.center.x, setTotalLabel.center.y);
    
    setUsingLabel.frame = CGRectMake(LEFT_MARGIN, height*2, self.frame.size.width/2.0f, height);
    setUsinField.frame = CGRectMake(0.0f+self.frame.size.width/2.0f, height*2, self.frame.size.width/2.0f-LEFT_MARGIN, 20.0f);
    setUsinField.center = CGPointMake(setUsinField.center.x, setUsingLabel.center.y);
    

    button.frame = CGRectMake(LEFT_MARGIN, height*3+BUTTOM_MARGIN, (self.frame.size.width-LEFT_MARGIN*2)/2.-LEFT_MARGIN, height-BUTTOM_MARGIN*2);
    cancelButton.frame = CGRectMake(LEFT_MARGIN*2+(self.frame.size.width-LEFT_MARGIN*2)/2., height*3+BUTTOM_MARGIN, (self.frame.size.width-LEFT_MARGIN*2)/2.-LEFT_MARGIN, height-BUTTOM_MARGIN*2);
}

- (void)setShowAttribute
{
    titleLabel.text = @"请设置流量信息";
    titleLabel.backgroundColor = [UIColor colorWithRed:240./256. green:240./256. blue:240./256. alpha:1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    setTotalLabel.text = @"本月总流量";
    setTotalLabel.textAlignment = NSTextAlignmentLeft;
    
    
    setTotalField.placeholder = @"MB";
    setTotalField.textColor = [UIColor whiteColor];
    setTotalField.keyboardType = UIKeyboardTypeDefault;
    setTotalField.borderStyle = UITextBorderStyleRoundedRect;
    setTotalField.backgroundColor = [UIColor colorWithRed:110/256. green:145/256. blue:188/256. alpha:1];
    setTotalField.delegate = self;
    
    setUsingLabel.text = @"本月已用流量";
    setUsingLabel.textAlignment = NSTextAlignmentLeft;
    
    
    
    setUsinField.placeholder = @"MB";
    setUsinField.textColor = [UIColor whiteColor];
    setUsinField.keyboardType = UIKeyboardTypeDefault;
    setUsinField.borderStyle = UITextBorderStyleRoundedRect;
    setUsinField.backgroundColor = [UIColor colorWithRed:110/256. green:145/256. blue:188/256. alpha:1];
    setUsinField.delegate = self;
    
    [button setTitle:@"确认" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:63/256. green:147/256. blue:229/256. alpha:1]];
    [button addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor colorWithRed:63/256. green:147/256. blue:229/256. alpha:1]];
    [cancelButton addTarget:self action:@selector(cancelButtonPress) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 5;
}

- (void)buttonPress
{
    if (([[setTotalField text] isEqual:@""]) || ([[setUsinField text] isEqual:@""])) {
        [self showAlert:@"请输入有效的流量信息!!"];
        return;
    }
    double inputTotal = [[setTotalField text] doubleValue];
    double inputUsing = [[setUsinField text] doubleValue];
    

    
    [self.delegate buttonPressedTotal:inputTotal WithUsing:inputUsing WithOK:YES];
}

- (void)cancelButtonPress
{
    [self.delegate buttonPressedTotal:0 WithUsing:0 WithOK:NO];
}

- (void)showAlert:(NSString *)string
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
