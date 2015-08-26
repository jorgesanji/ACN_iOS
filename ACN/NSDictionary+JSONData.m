//
//  NSDictionary+JSONData.m
//  ACN
//
//  Created by jorge Sanmartin on 25/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "NSDictionary+JSONData.h"

@implementation NSDictionary (JSONData)

-(NSData *)toData{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    return jsonData;
}

@end
