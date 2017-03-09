//
//  ViewController.m
//  getDataCounters
//
//  Created by liujianan on 14/10/28.
//  Copyright (c) 2014年 liujianan. All rights reserved.
//

#import "ViewController.h"
#import <ifaddrs.h>
#import <sys/socket.h>
#import <net/if.h>
#import "dataCounters.h"
#import "setView.h"
#import "GraphView.h"
#import "AdwoAdSDK.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

#define SHOW_BEGIN_X 15.0f
#define SHOW_BEGIN_Y 35.0f
#define SHOW_SPACING 10.0f
#define ADJUST_BEGIN 150.0f
#define TEXTFIELD1TAG 1000
#define TEXTFIELD2TAG 2000
#define TEXTFIELD3TAG 3000
#define SHOWVIEWTAG 4000
#define SHOWTEMPTAG 5000
#define SHOWTOTALTAG 6000
#define SHOWUSINGTAG 7000
#define FRAME (self.view.frame.size)
#define RGBColor(r,g,b,a)     [UIColor colorWithRed:r/256. green:g/256. blue:b/256. alpha:a]
#define ALL_VIEW_WIDTH  (1180./1242.*FRAME.width)
#define RESET_VIEW_HEIGHT (130/2208.*FRAME.height)
#define LABEL_VIEW_HEIGHT (300./2208.*FRAME.height)
#define SHOW_VIEW_HEIGHT (1160./2208.*FRAME.height)
#define SPACE_HEIGHT (30./2208.*FRAME.height)
#define LINE_HEIGHT (4./2208.*FRAME.height)
#define TEXT_HEIGHT (50./2208.*FRAME.height)

@interface ViewController ()
{
    dataCounters *saveDate;
    GraphView *graphView;
    UIView *ad;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = RGBColor(35, 61, 90, 1);
    self.title = @"网络助手";
    
    UINavigationBar *bar = self.navigationController.navigationBar;
    [bar setBarTintColor:RGBColor(47, 77, 115, 1)];
    UIFont *font = [UIFont systemFontOfSize:25.];
    NSDictionary *dic = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
    [bar setTitleTextAttributes:dic];
    
    
    float origin_y = bar.frame.size.height+20.+SPACE_HEIGHT;
    float origin_x = (FRAME.width-ALL_VIEW_WIDTH)/2.;
    
    
    graphView = [[GraphView alloc]initWithFrame:CGRectMake(origin_x, origin_y, ALL_VIEW_WIDTH, SHOW_VIEW_HEIGHT)];
    [graphView setBackgroundColor:[UIColor clearColor]];
    [graphView setSpacing:100];
    [graphView setFill:YES];
    [graphView setStrokeColor:[UIColor redColor]];
    [graphView setZeroLineStrokeColor:[UIColor greenColor]];
    [graphView setFillColor:[UIColor orangeColor]];
    [graphView setLineWidth:2];
    [graphView setCurvedLines:YES];
    [self.view addSubview:graphView];
    
    
    origin_y += SPACE_HEIGHT+graphView.frame.size.height;
    
    
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    NSNumber *cache = [def objectForKey:@"cache"];
//    if (!cache) {
//        
//        UIView *tempGrayView = [[UIView alloc] initWithFrame:self.view.frame];
//        tempGrayView.tag = SHOWTEMPTAG;
//        tempGrayView.backgroundColor = [UIColor blackColor];
//        [self.view addSubview:tempGrayView];
//        [tempGrayView release];
//        
//        
//        setView *view = [[setView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)*0.5f, 110.0f, 300.0f, 270.0f)];
//        view.tag = SHOWVIEWTAG;
//        view.backgroundColor = [UIColor whiteColor];
//        view.delegate = self;
//        [self.view addSubview:view];
//        [view release];
//        
//    }
//    else
//    {
    
    
        NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.adwo.wangluozhushou"];
        double total = [[shared objectForKey:@"totalCounters"] doubleValue];
        double using = [[shared objectForKey:@"usingCounters"] doubleValue];
        NSString *nextStr = [shared objectForKey:@"clearDate"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *next = [formatter dateFromString:nextStr];
    
    
        saveDate = [[dataCounters alloc] initTotal:total withUsing:using withDate:next];
        [saveDate showAllCount];
        [saveDate startDataCounters];
        [saveDate addObserver:self forKeyPath:@"usingCounters" options:NSKeyValueObservingOptionNew context:NULL];
        [saveDate addObserver:self forKeyPath:@"currentCounters" options:NSKeyValueObservingOptionNew context:NULL];
    
    
        UILabel *totalFlows = [[UILabel alloc] initWithFrame:CGRectMake(origin_x, origin_y, ALL_VIEW_WIDTH, TEXT_HEIGHT)];
        totalFlows.tag =SHOWTOTALTAG;
        totalFlows.text = [NSString stringWithFormat:@"本月总流量：           %@",[self bytesToAvaiUnit:total ]];
        totalFlows.textColor = [UIColor whiteColor];
        totalFlows.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:totalFlows];
    
    
        origin_y += SPACE_HEIGHT+totalFlows.frame.size.height;
    
    
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(origin_x, origin_y, ALL_VIEW_WIDTH, LINE_HEIGHT)];
        line.backgroundColor = RGBColor(47, 77, 115, 1);
        [self.view addSubview:line];
        
        origin_y += SPACE_HEIGHT+line.frame.size.height;
        
        UILabel *usingFlows = [[UILabel alloc] initWithFrame:CGRectMake(origin_x, origin_y, ALL_VIEW_WIDTH, TEXT_HEIGHT)];
        usingFlows.tag =SHOWUSINGTAG;
        usingFlows.text = [NSString stringWithFormat:@"本月已用流量：         %@",[self bytesToAvaiUnit:using ]];
        usingFlows.textColor = [UIColor whiteColor];
        usingFlows.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:usingFlows];
        
        origin_y += SPACE_HEIGHT+usingFlows.frame.size.height;
        
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(origin_x, origin_y, ALL_VIEW_WIDTH, RESET_VIEW_HEIGHT);
        button.backgroundColor = RGBColor(63, 114, 228, 1);
        [button setTitle:@"重置校准" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIFont *buttonFont = [UIFont systemFontOfSize:25.];
        button.titleLabel.font = buttonFont;
        [button addTarget:self action:@selector(resetButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    
    
    origin_y += SPACE_HEIGHT+button.frame.size.height;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(origin_x, origin_y, ALL_VIEW_WIDTH, LABEL_VIEW_HEIGHT)];
    imageView.image = [UIImage imageNamed:@"shuoming.png"];
    imageView.layer.cornerRadius = 5.;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSNumber *cache = [def objectForKey:@"cache"];
    if (!cache) {

        [self resetButton];
        
    }
    
}

- (void)resetButton
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    CIImage *outPutCIImage;
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, ciImage, @"inputRadius", @1.5, nil];
    outPutCIImage = [filter outputImage];
    UIImage *blurImage = [UIImage imageWithCIImage:outPutCIImage];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = blurImage;
    
    
    UIView *tempGrayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tempGrayView.tag = SHOWTEMPTAG;
    [tempGrayView addSubview:imageView];
    tempGrayView.alpha = 0.0f;
    tempGrayView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:tempGrayView];
    
    [imageView release];
    
    
    setView *view = [[setView alloc] initWithFrame:CGRectMake(15.0f*FRAME.width/320., 160.0f*FRAME.height/568., 290.0f*FRAME.width/320., 220.0f*FRAME.height/568.)];
    view.tag = SHOWVIEWTAG;
    view.backgroundColor = [UIColor whiteColor];
    view.delegate = self;
    view.alpha = 0.0f;
    [self.view addSubview:view];
    
    
    [UIView animateWithDuration:1.0f animations:^{
        view.alpha = 1.0f;
        tempGrayView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [view release];
        [tempGrayView release];
    }];

    
}

- (void)buttonPressedTotal:(double)total WithUsing:(double)using WithOK:(BOOL)ok;
{
    UIView *tempView = [self.view viewWithTag:SHOWTEMPTAG];
    [tempView removeFromSuperview];
    
    setView *view = (setView *)[self.view viewWithTag:SHOWVIEWTAG];
    [view removeFromSuperview];
    
    if (!ok) {
        return;
    }
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:now];
    NSInteger month= [components month]+1;
    NSInteger year= [components year];
    
    if (month > 12) {
        month = 1;
        year++;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *next = [formatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 00:00:00",year,month,1]];
    
    if (saveDate) {
        [saveDate removeObserver:self forKeyPath:@"usingCounters"];
        [saveDate removeObserver:self forKeyPath:@"currentCounters"];
        [saveDate release];
        saveDate = nil;
    }
    
    
    saveDate = [[dataCounters alloc] initTotal:total*1024*1024 withUsing:using*1024*1024 withDate:next];
    [saveDate showAllCount];
    [saveDate startDataCounters];
    [saveDate addObserver:self forKeyPath:@"usingCounters" options:NSKeyValueObservingOptionNew context:NULL];
    [saveDate addObserver:self forKeyPath:@"currentCounters" options:NSKeyValueObservingOptionNew context:NULL];
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.adwo.wangluozhushou"];
    [shared setObject:[NSNumber numberWithDouble:total*1024*1024]  forKey:@"totalCounters"];
    [shared setObject:[NSNumber numberWithDouble:using*1024*1024]  forKey:@"usingCounters"];
    [shared setObject:[formatter stringFromDate:next]  forKey:@"clearDate"];
    [shared synchronize];
    
    [formatter release];
    [shared release];
    
    
    float origin_y = 30.0f;
    origin_y += 280;
    
    UILabel *totalFlows = (UILabel *)[self.view viewWithTag:SHOWTOTALTAG];
    if (!totalFlows) {
        UILabel *totalFlows = [[UILabel alloc] initWithFrame:CGRectMake(10, origin_y+20, self.view.frame.size.width-20, 25)];
        totalFlows.tag =SHOWTOTALTAG;
        totalFlows.text = [NSString stringWithFormat:@"本月总流量：           %@",[self bytesToAvaiUnit:total*1024*1024 ]];
        totalFlows.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:totalFlows];
        [totalFlows release];
    }
    else
    {
        totalFlows.text = [NSString stringWithFormat:@"本月总流量：           %@",[self bytesToAvaiUnit:total*1024*1024 ]];
    }
    
    origin_y += 25;
    
    UILabel *usingFlows = (UILabel *)[self.view viewWithTag:SHOWUSINGTAG];
    if (!usingFlows) {
        UILabel *usingFlows = [[UILabel alloc] initWithFrame:CGRectMake(10, origin_y+20, self.view.frame.size.width-20, 25)];
        usingFlows.tag =SHOWUSINGTAG;
        usingFlows.text = [NSString stringWithFormat:@"本月已用流量：         %@",[self bytesToAvaiUnit:using*1024*1024 ]];
        usingFlows.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:usingFlows];
        [usingFlows release];
    }
    else
    {
        usingFlows.text = [NSString stringWithFormat:@"本月已用流量：         %@",[self bytesToAvaiUnit:using*1024*1024 ]];
    }
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    
    if (!ad) {
        ad = AdwoAdCreateBanner(@"500b45dbfe234cc0adef9995704375ca", YES, self);
        if (ad) {
            AdwoAdLoadBannerAd(ad, ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_320x50, nil);
        }
    }
    
    
//    ad = [[UIView alloc] init];
//    ad.hidden = YES;
    
    
    NSLog(@"%@ change is %@",keyPath,change);
    if ([keyPath isEqualToString:@"usingCounters"]) {
        
        NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.adwo.wangluozhushou"];
        [shared setObject:[change objectForKey:@"new"]  forKey:@"usingCounters"];
        [shared synchronize];
        [shared release];
        
        UILabel *label = (UILabel *)[self.view viewWithTag:SHOWUSINGTAG];
        label.text = [NSString stringWithFormat:@"本月已用流量：         %@",[self bytesToAvaiUnit:[[change objectForKey:@"new"] doubleValue] ]];
        
    }
    else
    {
        [graphView setPoint:[[change objectForKey:@"new"] doubleValue]/1024];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (NSString *)bytesToAvaiUnit:(double)bytes
{
    if(bytes < 1024)  // B
    {
        return  [NSString stringWithFormat:@"%.0fB", bytes];
    }
    
    else if(bytes >= 1024 && bytes < 1024 * 1024) // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024) // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    
    else // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
    
}

- (UIViewController*)adwoGetBaseViewController
{
    return self;
}
- (void)adwoAdViewDidLoadAd:(UIView*)adView
{
    adView.frame = CGRectMake((self.view.frame.size.width-320)*0.5f,self.view.frame.size.height-50, 320, 50);
    AdwoAdAddBannerToSuperView(adView, self.view);
}
- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView
{
    NSLog(@"%d",AdwoAdGetLatestErrorCode());
    ad = nil;
}
@end
