//
//  CCProgressView.m
//  ACN
//
//  Created by jorge Sanmartin on 15/08/14.
//  Copyright (c) 2014 JP Simard. All rights reserved.
//

#import "CCProgressView.h"

@implementation CCProgressView

+(instancetype)getProgressView{
    
    CCProgressView * pr = [[CCProgressView alloc] init];
    return pr;
}


#pragma mark - Lifecycle

- (id)init {
    return [self initWithFrame:CGRectMake(0.f, 0.f, 37.f, 37.f)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        _progress = 0.0f;
        _progressTintColor = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
        _backgroundTintColor = [[UIColor alloc] initWithWhite:1.f alpha:.1f];
        [self registerForKVO];
    }
    return self;
}

-(void)removeFromSuperview{
    [self unregisterFromKVO];
    [super removeFromSuperview];
}

-(void)updateinMainThread:(NSNumber *)pr{
    self.progress = [pr floatValue];
}

-(void)updateprogress:(CGFloat)prg{
    
    NSNumber * pr = [NSNumber numberWithFloat:prg];
    //Update in main thread
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateinMainThread:) withObject:pr waitUntilDone:NO];
    } else {
        [self updateinMainThread:pr];
    }
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    
    CGRect allRect = self.bounds;
    CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw background
    [_progressTintColor setStroke];
    [_backgroundTintColor setFill];
    CGContextSetLineWidth(context, 2.0f);
    CGContextFillEllipseInRect(context, circleRect);
    CGContextStrokeEllipseInRect(context, circleRect);
    // Draw progress
    CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
    CGFloat radius = (allRect.size.width - 4) / 2;
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

#pragma mark - KVO

- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    
    for (NSString *keyPath in [self observableKeypaths]) {
        @try {
            [self removeObserver:self forKeyPath:keyPath];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",[exception description]);
        }
        @finally {
        }
    }
}

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"progressTintColor", @"backgroundTintColor", @"progress", @"annular", nil]; //progressTintColor
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay];
}

@end
