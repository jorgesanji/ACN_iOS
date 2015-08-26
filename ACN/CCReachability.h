//
//  CCReachability.h
//  eFitness
//
//  Created by Flamingo Partners on 26/09/14.
//  Copyright (c) 2014 Mubiquo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;
@interface CCReachability : NSObject

@property (strong, nonatomic) Reachability *reachability;

#pragma mark -
#pragma mark Shared Manager
+ (CCReachability *)sharedManager;

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

-(BOOL)isRecheableFromCurrentStatus;

@end
