//
//  ScanOverlayView.m
//  OEatApp
//
//  Created by apstnetmgr on 15/1/12.
//  Copyright (c) 2015年 APST. All rights reserved.
//

#import "ScanOverlayView.h"

@implementation ScanOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawCenterPlus
{
    CGRect _frame = self.frame;
    _frame.origin.x += 20;
    _frame.origin.y += 84;
    _frame.size.width -= 40;
    _frame.size.height -= 164;//60 px for under label
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_frame cornerRadius:16] ;
    
    CGPoint center = CGPointMake(CGRectGetMidX(_frame), CGRectGetMidY(_frame));
    
    // Draw the circle
//    [bezierPath addArcWithCenter:center radius:self.frame.size.width/3 startAngle:0 endAngle:360 clockwise:YES];
    
    // Draw the lines
    [bezierPath moveToPoint:CGPointMake(center.x - _frame.size.width/3 + 20, center.y)];
    [bezierPath addLineToPoint:CGPointMake(center.x + _frame.size.width/3 - 20, center.y)];
    
    [bezierPath moveToPoint:CGPointMake(center.x, center.y - _frame.size.width/3 + 20)];
    [bezierPath addLineToPoint:CGPointMake(center.x, center.y + _frame.size.width/3 - 20)];
    
    // Stroke path
    [bezierPath setLineWidth:8];
    [[UIColor lightGrayColor] setStroke];
    [bezierPath stroke];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_frame.origin.x, _frame.origin.y+_frame.size.height+15, 0, 28)];
    [label setText:@"Point camera at an O-Eat QR Code"];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    [self addSubview:label];
    [label setCenter:CGPointMake(self.frame.size.width/2, label.frame.origin.y+14)];
}

- (void)drawRect:(CGRect)rect
{
    
    [self drawCenterPlus];
    
}


@end
