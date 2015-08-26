//
//  NSMutableURLRequest+HeaderDefaultConfiguration.h
//  ACN
//
//  Created by jorge Sanmartin on 24/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (HeaderDefaultConfiguration)

+(instancetype)requestWithURL:(NSURL *)url method:(NSString *)method bodyData:(NSData *)data defaultHeader:(BOOL)header timeOut:(CGFloat)timeOut;

@end
