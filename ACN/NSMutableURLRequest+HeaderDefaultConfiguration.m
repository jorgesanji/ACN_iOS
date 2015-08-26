//
//  NSMutableURLRequest+HeaderDefaultConfiguration.m
//  ACN
//
//  Created by jorge Sanmartin on 24/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSMutableURLRequest+HeaderDefaultConfiguration.h"

static NSString *const AcceptHeader = @"Accept";
static NSString *const ContentTypeHeader = @"Content-Type";
static NSString *const ContentLengthHeader = @"Content-Length";
static NSString *const ContentType = @"application/json";

@implementation NSMutableURLRequest (HeaderDefaultConfiguration)

+(instancetype)requestWithURL:(NSURL *)url method:(NSString *)method bodyData:(NSData *)data defaultHeader:(BOOL)header timeOut:(CGFloat)timeOut{
    
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeOut];
    [request setHTTPMethod:method];
    if (header) {
        [request setValue:ContentType forHTTPHeaderField:ContentTypeHeader];
        [request setValue:ContentType forHTTPHeaderField:AcceptHeader];
    }
    
    if (data) {
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:ContentLengthHeader];
        //TODO: set parameters by body
        [request setHTTPBody:data];
    }
    
    return request;
}

@end
