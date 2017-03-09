//
//  GraphView.m
//  DynamicGraphView
//
//  Created by liujianan on 14/10/28.
//  Copyright (c) 2014年 liujianan. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor yellowColor];
        
        fillGraph = YES;
        
        spacing = 10;
        
        strokeColor = [UIColor redColor];
        
        fillColor = [UIColor orangeColor];
        
        zeroLineStrokeColor = [UIColor greenColor];
        
        lineWidth = 2;
        
        max = [[UILabel alloc] initWithFrame:CGRectMake(2, 15, 50, 16)];
        [max setAdjustsFontSizeToFitWidth:YES];
        [max setBackgroundColor:[UIColor clearColor]];
        [max setTextColor:[UIColor whiteColor]];
        [max setText:@"100KB/s"];
        [self addSubview:max];
        
        zero = [[UILabel alloc] initWithFrame:CGRectMake(2, CGRectGetMidY(self.frame) - 7.5, 25, 16)];
        [zero setAdjustsFontSizeToFitWidth:YES];
        [zero setBackgroundColor:[UIColor clearColor]];
        [zero setTextColor:[UIColor blackColor]];
        [self addSubview:zero];
        
        min = [[UILabel alloc] initWithFrame:CGRectMake(2, CGRectGetHeight(self.frame)-15, 50, 16)];
        [min setAdjustsFontSizeToFitWidth:YES];
        [min setBackgroundColor:[UIColor clearColor]];
        [min setTextColor:[UIColor whiteColor]];
        [min setText:@"0KB/s"];
        [self addSubview:min];
        
        current = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        current.text = @"实时流量:0KB/s";
        current.textAlignment = NSTextAlignmentCenter;
        [current setTextColor:[UIColor whiteColor]];
        [self addSubview:current];
        
        UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 1, self.frame.size.height-40)];
        labelLeft.backgroundColor = [UIColor colorWithRed:63./256. green:148./256. blue:229./256. alpha:1.];
        [self addSubview:labelLeft];
        
        UILabel *labelRight = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-1, 20, 1, self.frame.size.height-40)];
        labelRight.backgroundColor = [UIColor colorWithRed:63./256. green:148./256. blue:229./256. alpha:1.];
        [self addSubview:labelRight];
        
        UILabel *labelBottum = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 4)];
        labelBottum.backgroundColor = [UIColor colorWithRed:63./256. green:148./256. blue:229./256. alpha:1.];
        [self addSubview:labelBottum];
        
        float orign_x = (self.frame.size.width-40)/30.;
        float orign_y = self.frame.size.height/30.;
        
        for (int i = 0; i < 34; i++) {
            for (int j = 0; j < 26; j++) {
                UILabel *small = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
                small.backgroundColor = [UIColor whiteColor];
                small.center = CGPointMake(orign_x+orign_x*i, 20+j*orign_y+1);
                [self addSubview:small];
                [small release];
            }
        }

        
        
        
        
        
        
        dx = 50; // number of points shown in graph
        dy = 100; // default value for dy
        
        pointArray = [[NSMutableArray alloc]init]; //stores the energy values
        for (int i = 0; i < dx; i++) {
            [pointArray addObject:@0.0f];
        }
        
        
        trackLayer = [CAShapeLayer layer];
        trackLayer.frame = CGRectMake(0, 20, self.frame.size.width, self.frame.size.height-40);
        trackLayer.fillColor = [UIColor redColor].CGColor;
        trackLayer.opacity = 0.75f;
        trackLayer.lineCap = kCALineCapRound;
        trackLayer.lineWidth = 4;
        [self.layer addSublayer:trackLayer];


        gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 20, self.frame.size.width, self.frame.size.height-40);
        [gradientLayer setColors:[NSArray arrayWithObjects:
                                  (id)[[UIColor colorWithRed:63./256. green:148./256. blue:229./256. alpha:1.] CGColor],
                                  (id)[[UIColor colorWithRed:119./256. green:75./256. blue:230./256. alpha:1.] CGColor],
                                  (id)[[UIColor colorWithRed:214./256. green:123./256. blue:90./256. alpha:1.] CGColor],
                                  (id)[[UIColor colorWithRed:214./256. green:68./256. blue:48./256. alpha:1.] CGColor], nil]];
        [gradientLayer setLocations:@[@0.25,@0.45,@0.65,@0.85,@1.0 ]];
        [gradientLayer setStartPoint:CGPointMake(0.5, 1)];
        [gradientLayer setEndPoint:CGPointMake(0.5, 0)];
        gradientLayer.mask = trackLayer;
        gradientLayer.masksToBounds = YES;
        
        [self.layer addSublayer:gradientLayer];
        

        
        
        
        
    }
    
    return self;
}

-(void)setPoint:(float)point {
    
    [pointArray insertObject:@(point) atIndex:0];
    [pointArray removeObjectAtIndex:[pointArray count] - 1];
    
    [self setNeedsDisplay];
}

-(void)resetGraph {
        
    pointArray = [[NSMutableArray alloc]init]; //stores the energy values
    for (int i = 0; i < dx; i++) {
        [pointArray addObject:@0.0f];
    }
    
    [self setNeedsDisplay];
    
}

-(void)setArray:(NSArray*)array {
    
    pointArray = [[NSMutableArray alloc]initWithArray:array];
    
    dx = [pointArray count];
    
    [self setNeedsDisplay];
}

-(void)setSpacing:(int)space {
    
    spacing = space;
    
    [self setNeedsDisplay];
}

-(void)setFill:(BOOL)fill {
    
    fillGraph = fill;
    
    [self setNeedsDisplay];
}

-(void)setStrokeColor:(UIColor*)color {
    
    strokeColor = color;
    
    [self setNeedsDisplay];
}

-(void)setZeroLineStrokeColor:(UIColor*)color {
    
    zeroLineStrokeColor = color;
    
    [self setNeedsDisplay];
}

-(void)setFillColor:(UIColor*)color {
    
    fillColor = color;
    
    [self setNeedsDisplay];
}

-(void)setLineWidth:(int)width {
    
    lineWidth = width;
    
    [self setNeedsDisplay];
}

-(void)setNumberOfPointsInGraph:(int)numberOfPoints {
    
    dx = numberOfPoints;
    
    if ([pointArray count] < dx) {
        
        int dCount = dx - [pointArray count];
        
        for (int i = 0; i < dCount; i++) {
            [pointArray addObject:@(0.0f)];
        }
        
    }
    
    if ([pointArray count] > dx) {
        
        int dCount = [pointArray count] - dx;
        
        for (int i = 0; i < dCount; i++) {
            [pointArray removeLastObject];
        }
        
    }
    
    [self setNeedsDisplay];
    
}

-(void)setCurvedLines:(BOOL)curved {
    
    //the granularity value sets "curviness" of the graph depending on amount wanted and precission of the graph
    
    if (curved == YES) {
        granularity = 20;
    }else{
        granularity = 0;
    }
}

// here the graph is actually being drawn
- (void)drawRect:(CGRect)rect {

        [self calculateHeight];
        
        // draw null line in the middle
        if (setZero == 2) {
            
            [zeroLineStrokeColor setStroke];
            
            UIBezierPath *zeroLine = [UIBezierPath bezierPath];
            [zeroLine moveToPoint:CGPointMake(0, self.frame.size.height/2)];
            [zeroLine addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
            zeroLine.lineWidth = lineWidth; // line width
            [zeroLine stroke];
        }
        
        CGPoint leftBottom = CGPointMake(0, self.frame.size.height);
        CGPoint rightBottom = CGPointMake(self.frame.size.width, self.frame.size.height);
        
        NSMutableArray *points = [[self arrayOfPoints] mutableCopy];
        
        // Add control points to make the math make sense
        [points insertObject:points[0] atIndex:0];
        [points addObject:[points lastObject]];
        
        UIBezierPath *lineGraph = [UIBezierPath bezierPath];
        
        [lineGraph moveToPoint:[points[0] CGPointValue]];
        
        for (NSUInteger index = 1; index < points.count - 2; index++)
        {
            
            CGPoint p0 = [(NSValue *)points[index - 1] CGPointValue];
            CGPoint p1 = [(NSValue *)points[index] CGPointValue];
            CGPoint p2 = [(NSValue *)points[index + 1] CGPointValue];
            CGPoint p3 = [(NSValue *)points[index + 2] CGPointValue];
            
            // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
            for (int i = 1; i < granularity; i++)
            {
                float t = (float) i * (1.0f / (float) granularity);
                float tt = t * t;
                float ttt = tt * t;
                
                CGPoint pi; // intermediate point
                pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
                pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
                [lineGraph addLineToPoint:pi];
            }
            
            // Now add p2
            [lineGraph addLineToPoint:p2];
        }
        
        // finish by adding the last point
        [lineGraph addLineToPoint:[(NSValue *)points[(points.count - 1)] CGPointValue]];
    
        [points release];
    
        [fillColor setFill];
//        [strokeColor setStroke];

        if (fillGraph) {
            [lineGraph addLineToPoint:CGPointMake(leftBottom.x, leftBottom.y)];
            [lineGraph addLineToPoint:CGPointMake(rightBottom.x, rightBottom.y)];
            [lineGraph closePath];
            

            trackLayer.path = lineGraph.CGPath;

            
            
            
            /*渐变色填充*/
//            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//            CGContextRef context = UIGraphicsGetCurrentContext();
//            
//            UIColor *gradientColor = [UIColor colorWithRed:0.51 green:0.0 blue:0.49 alpha:1.0];
//            
//            NSArray *gradientColors = [NSArray arrayWithObjects:(id)[UIColor blueColor].CGColor,
//                                       (id)gradientColor,
//                                       (id)[UIColor redColor].CGColor,
//                                       nil];
//            CGFloat gradientLocations[] = {0,0.5,1};
//            CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocations);
//            CGContextSaveGState(context);
            
//            [lineGraph fill]; // fill color (if closed)
        
//            [lineGraph addClip];
//            CGContextDrawLinearGradient(context, gradient, CGPointMake(leftBottom.x, leftBottom.y), CGPointMake(rightBottom.x, 0), 0);
//            CGColorSpaceRelease(colorSpace);
//            CGGradientRelease(gradient);
        }
    
//        lineGraph.lineCapStyle = kCGLineCapRound;
//        lineGraph.lineJoinStyle = kCGLineJoinRound;
//        lineGraph.flatness = 0.5;
//        lineGraph.lineWidth = lineWidth; // line width
//        [lineGraph stroke];
    
        
        current.text = [NSString stringWithFormat:@"实时流量：%.2fKB/s",[pointArray[0] floatValue]];

    
}

- (NSArray*)arrayOfPoints {
    
    NSMutableArray *points = [NSMutableArray array];
    
    int viewWidth = CGRectGetWidth(self.frame);
    int viewHeight = CGRectGetHeight(self.frame);
    
    for (int i = 0; i < [pointArray count]; i++) {
        
        
        float point1x = viewWidth - (viewWidth / dx) * i; // start graph x on the right hand side
        float point1y = (viewHeight - (viewHeight / dy) * [pointArray[i] floatValue]) / setZero; //start graph y on the bottom
        
        float point2x = viewWidth - (viewWidth / dx) * i - (viewWidth / dx);
        float point2y = point1y;
        
        if (i != [pointArray count]-1) {
            point2y = (viewHeight - (viewHeight / dy) * [pointArray[i+1] floatValue]) / setZero;
        }

        CGPoint p;
        
        if (i == 0) {
            p = CGPointMake(point1x, point1y);
        }else{
            p = CGPointMake(point2x, point2y);
        }
        [points addObject:[NSValue valueWithCGPoint:p]];
    }
        
    return points;
        
}

// this is where the dynamic height of the graph is calculated
-(void)calculateHeight {
   
    int minValue = (int)[[pointArray valueForKeyPath:@"@min.self"] integerValue];
    int maxValue = (int)[[pointArray valueForKeyPath:@"@max.self"] integerValue];
    
    dy = maxValue + abs(minValue) + spacing;
    
    
    if (maxValue > spacing) {
        dy = maxValue;
    }
    else
    {
        dy = spacing;
    }
    
    // set maxValue and round the float
    [max setText:[NSString stringWithFormat:@"%iKB/s", (int)(dy + 0.0) ]];
    
    
    // set graphView for values below 0
    if (minValue < 0) {
        setZero = 2;
        [zero setText:@"0"];
        [min setText:[NSString stringWithFormat:@"-%iKB/s", (int)(dy + 0.0) ]];
    }else{
        setZero = 1;
        [zero setText:@""];
        [min setText:[NSString stringWithFormat:@"0KB/s"]];
    }
}

@end
