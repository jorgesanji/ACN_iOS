//
//  PageNewView.m
//  ACN
//
//  Created by Flamingo Partners on 15/2/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "PageNewView.h"
#import "NoticiaACN.h"
#import "UIColor+CustomColorsApp.h"
#import "UIView+Frame.h"
#import "UILabel+AppFunctions.h"
#import "Utils.h"
#import "Noticia.h"
#import "UIImageView+Load.h"

@interface PageNewView ()<UIScrollViewDelegate>

@property(nonatomic ,strong)id noticia;

@end

#define HelveticaNeueBold @"HelveticaNeue-Bold"


@implementation PageNewView

/*
 Get an instance of an ExampleCustomView, which will be loaded from a Nib file
 */
+(PageNewView *)getNewView{
    
    PageNewView *view;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *nib = [bundle loadNibNamed:@"PageNewView" owner:self options:nil];
    for (id item in nib)
    {
        if ([item isKindOfClass:[PageNewView class]])
        {
            view = (PageNewView *)item;
            break;
        }
    }
    return view;
}

- (void) initialize {
    CGRect frame = [UIScreen mainScreen].bounds;
    self.width = frame.size.width;
    self.height = frame.size.height;
    contentScrollNew.width = frame.size.width;
    contentScrollNew.height = frame.size.height;
    contentScrollNew.delegate = self;
    titleNew.textColor = [UIColor getPrimaryColor];
    subtitleNew.textColor = [UIColor getPrimaryColor];
    dateNew.textColor = [UIColor getgrayColor];
    [titleNew setTapWithTarget:self selector:@selector(gotoNew:)];
}


-(void)setDataSourse:(id)noticia{
    self.noticia = noticia;
    [self fillData];
}

-(void)fillData{
    
    [self initialize];
    
    NSString *title = nil;
    NSString *subtitle = nil;
    NSString *description = nil;
    NSDate *date = nil;
    NSString * image_url = nil;
    
    if ([_noticia isKindOfClass:[NoticiaACN class]]) {
        NoticiaACN *nt = (NoticiaACN *)_noticia;
        title = nt.title;
        subtitle = nt.subtitle;
        description = nt.description;
        date = nt.creation_date;
        image_url = nt.image;
    }else{
        Noticia *nt = (Noticia *)_noticia;
        title = nt.title;
        subtitle = nt.subtitle;
        description = nt.descriptionFeed;
        date = nt.creation_date;
        image_url = nt.image;
    }
    
    CGFloat top = 10.0f;
    
    if (image_url!=nil && [image_url length] > 1) {
        [image dowloadFromStringUrl:image_url saveInDisk:YES];
        image.left = 0.5f;
        image.width -= 0.5f;
        top = image.height;
    }else{
        [image setHidden:YES];
    }
    
    //customizing ui description
    description = [description stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    NSArray* foo = [description componentsSeparatedByString:@"<b>"];
    
    NSMutableArray *strings = [NSMutableArray arrayWithCapacity:0];
    for (NSString *st in foo) {
        NSArray *string = [st componentsSeparatedByString:@"</b>"];
        if ([string count] > 1) {
            [strings addObject:[string objectAtIndex:0]];
        }
    }
    
    description = [description stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
    description = [description stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    
    titleNew.top = top;
    titleNew.text = title;
    NSMutableAttributedString *str = [[titleNew attributedText] mutableCopy];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, str.length)];
    [titleNew setAttributedText:str];
    [titleNew sizeToFit];
    titleNew.width = [self width] - 30.0f;
    
    top = titleNew.top + titleNew.height + 10.0f;
    
    subtitleNew.text = subtitle;
    [subtitleNew sizeToFit];
    subtitleNew.width = [self width] - 30.0f;
    subtitleNew.top = top;
    
    top = subtitleNew.top + subtitleNew.height + 10.0f;
    
    dateNew.textColor = [UIColor getgrayColor];
    NSString *acn = ([Utils isACN])?@"ACN":@"CNA";
    acn = [acn stringByAppendingString:@" - "];
    dateNew.text = acn;
    dateNew.top = top;
    [dateNew sizeToFit];
    
    if (date) {
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormater setDateFormat:@"dd/MM/yyyy HH:mm"];
        NSString *strDate = [dateFormater stringFromDate:date];
        dateNew.text = [acn stringByAppendingString:strDate];
        [dateNew sizeToFit];
    }else dateNew.hidden = YES;
    
    if (![dateNew isHidden]) {
        top = dateNew.top + dateNew.height + 10.0f;
    }
    
    contentNew.text = description;
    for (NSString *name in strings){
        [contentNew boldSubstring:name withFontName:HelveticaNeueBold withUnderline:NO];
    }
    
    [contentNew sizeToFit];
    contentNew.width = [self width] - 30.0f;
    contentNew.top = top;
    
    CGFloat heightTotal = contentNew.top +contentNew.height + 80.0f;
    [contentScrollNew setContentSize:CGSizeMake(self.width, heightTotal)];
}

-(IBAction)gotoNew:(UITapGestureRecognizer *)sender{
    NSString *url = nil;
    if ([_noticia isKindOfClass:[NoticiaACN class]]) {
        NoticiaACN *nt = (NoticiaACN *)_noticia;
        url = nt.url;
    }else{
        Noticia *nt = (Noticia *)_noticia;
        url = nt.url;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)prepareForReuse{
    NSLog(@"UIReusableView");
}

- (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    if (self.delegate != nil && [self.delegate conformsToProtocol:@protocol(ScrollShowHideNavigationBarDelegate)] && [self.delegate respondsToSelector:@selector(scrollOffset:scrollView:)]) {
        [self.delegate scrollOffset:offset scrollView:scrollView];
    }
}

@end
