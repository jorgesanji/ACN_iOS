//
//  UIReusableView.h
//  ACN
//
//  Created by Flamingo Partners on 15/06/14.
//  Copyright (c) 2014 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIReusableView <NSObject>

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

- (void)prepareForReuse;

@end
