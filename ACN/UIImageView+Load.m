//
//  UIImageView+Load.m
//  ACN
//
//  Created by Flamingo Partners on 17/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "UIImageView+Load.h"
#import "UIImageView+WebCache.h"
#import "CCProgressView.h"
#import "UIView+Frame.h"
#import "UIColor+CustomColorsApp.h"


@implementation UIImageView (Load)

-(void)dowloadFromStringUrl:(NSString *)url saveInDisk:(BOOL)saveInDisk{
    
    if (!url) {
        return;
    }
    
    //Get image from disk or cache
    UIImage *image = nil;
    if (saveInDisk) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
    }else{
        image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:url];
    }
    
    if (image) {
        [self setImage:image];
        return;
    }
    
    __block CCProgressView * progressView = [CCProgressView getProgressView];
    progressView.width = 40.0f;
    progressView.height = 40.0f;
    progressView.left = self.width/2 - progressView.width/2;
    progressView.top = self.height/2 - progressView.height/2;
    progressView.progressTintColor = [UIColor getPrimaryColor];
    progressView.backgroundTintColor = [UIColor getPrimaryColor];

    
    [self addSubview:progressView];
    
    //Download image
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:url]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         if (receivedSize > 0  && expectedSize > 0) {
             CGFloat per = (CGFloat)receivedSize / expectedSize;
             [progressView updateprogress:per];
         }
     }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         
         [UIView animateWithDuration:1.0f animations:^{
             progressView.alpha = 0.0f;
         } completion:^(BOOL finished) {
             [progressView removeFromSuperview];
             progressView = nil;
         }];
         
         if (image && finished)
         {
             [[SDImageCache sharedImageCache] storeImage:image forKey:url toDisk:saveInDisk];
             [self setImage:image];
         }
     }];
}

@end
