//
//  CCReachability.m
//  eFitness
//
//  Created by Flamingo Partners on 26/09/14.
//  Copyright (c) 2014 Mubiquo. All rights reserved.
//

#import "CCReachability.h"
#import "Reachability.h"

@implementation CCReachability

#pragma mark -
#pragma mark Default Manager
+ (CCReachability *)sharedManager {
    static CCReachability *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark -
#pragma mark Memory Management
- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable {
    return [[[CCReachability sharedManager] reachability] isReachable];
}

+ (BOOL)isUnreachable {
    return ![[[CCReachability sharedManager] reachability] isReachable];
}

+ (BOOL)isReachableViaWWAN {
    return [[[CCReachability sharedManager] reachability] isReachableViaWWAN];
}

+ (BOOL)isReachableViaWiFi {
    return [[[CCReachability sharedManager] reachability] isReachableViaWiFi];
}

#pragma mark -
#pragma mark Private Initialization

- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        // Start Monitoring
        [self.reachability startNotifier];
    }
    
    return self;
}

-(BOOL)isRecheableFromCurrentStatus{

    
    NetworkStatus siteNetworkStatus = [_reachability currentReachabilityStatus];
    
    return  (siteNetworkStatus != NotReachable);
        
}

-(void)test{

    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}



@end
