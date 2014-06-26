//
//  MDNotificationView.m
//  MDCustomNotificationsManager
//
//  Created by noughts on 2014/06/26.
//  Copyright (c) 2014年 Magic Dealers. All rights reserved.
//

#import "MDNotificationView.h"
#import "MDCustomNotificationsManager.h"

static float kNotificationBackgroundAlpha = 0.9;

@interface MDNotificationView ()

@property (nonatomic, strong) UIImageView *notificationTypeIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIView *notificationView;

@property (nonatomic, copy) ButtonActionBlock buttonActionBlock;

@end


@implementation MDNotificationView

#pragma mark Actions.

- (void)handleButtonAction:(UIButton *)actionButton {
    if (self.buttonActionBlock) self.buttonActionBlock();
}


- (UIColor *)appropriateColourForNotificationMessage:(MDNotificationMessage *)notificationMessage {
    
    NSMutableDictionary *coloursDictionary = [@{@(MDCustomNotificationTypeError): [UIColor colorWithRed:0.826 green:0.154 blue:0.188 alpha:kNotificationBackgroundAlpha],
                                                @(MDCustomNotificationTypeSuccess): [UIColor colorWithRed:0.207 green:0.785 blue:0.289 alpha:kNotificationBackgroundAlpha],
                                                @(MDCustomNotificationTypeInfo): [UIColor colorWithWhite:0 alpha:kNotificationBackgroundAlpha],
                                                @(MDCustomNotificationTypeWarning): [UIColor colorWithRed:1.000 green:0.404 blue:0.141 alpha:kNotificationBackgroundAlpha],
                                                @(MDCustomNotificationTypeCustom): [UIColor colorWithWhite:0 alpha:kNotificationBackgroundAlpha]} mutableCopy];
    
    if (notificationMessage.backgroundColour) {
        [coloursDictionary setObject:notificationMessage.backgroundColour forKey:@(MDCustomNotificationTypeCustom)];
    }
    
    return [coloursDictionary objectForKey:@(notificationMessage.notificationType)];
}


- (UIImage *)appropriateImageForNotificationMessage:(MDNotificationMessage *)notificationMessage {
    
    NSMutableDictionary *iconsDictionary = [@{@(MDCustomNotificationTypeError): [UIImage imageNamed:@"icon-error.png"],
                                              @(MDCustomNotificationTypeSuccess): [UIImage imageNamed:@"icon-success.png"],
                                              @(MDCustomNotificationTypeInfo): [UIImage imageNamed:@"icon-info.png"],
                                              @(MDCustomNotificationTypeWarning): [UIImage imageNamed:@"icon-warning.png"],
                                              @(MDCustomNotificationTypeCustom): [UIImage imageNamed:@"icon-info.png"]} mutableCopy];
    
    if (notificationMessage.iconImage) {
        [iconsDictionary setObject:notificationMessage.iconImage forKey:MDCustomNotificationTypeCustom];
    }
    
    return [iconsDictionary objectForKey:@(notificationMessage.notificationType)];
}


#pragma mark Utilities.

- (CGFloat)heightForText:(NSString *)text withFont:(UIFont *)font forWidth:(CGFloat)width {
    
    CGSize boundaries = CGSizeMake(width, CGFLOAT_MAX);
    return [self sizeForText:text withFont:font forBoundaries:boundaries].height + 20;
}


- (CGFloat)widthForText:(NSString *)text withFont:(UIFont *)font forHeight:(CGFloat)height {
    
    CGSize boundaries = CGSizeMake(CGFLOAT_MAX, height);
    return [self sizeForText:text withFont:font forBoundaries:boundaries].width;
}


- (CGSize)sizeForText:(NSString *)text withFont:(UIFont *)font forBoundaries:(CGSize)boundaries {
    
    NSDictionary *stringAttributesDictionary = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:boundaries options:NSStringDrawingUsesLineFragmentOrigin attributes:stringAttributesDictionary context:nil].size;
}


#pragma mark UIView's LifeCycle.
/*
- (id)initWithNotificationMessage:(MDNotificationMessage *)notificationMessage {
    
    float notificationViewWidth = [[UIApplication sharedApplication] keyWindow].frame.size.width;
    float titleHeight = [self heightForText:notificationMessage.message withFont:kMessageFont forWidth:notificationViewWidth - 10 - 36 - 10];
    
    float notificationViewHeight = 10 + titleHeight + 10;
    
    if (notificationMessage.buttonTitle) notificationViewHeight = notificationViewHeight + 10 + 10;
    
    self = [super initWithFrame:CGRectMake(0, -notificationViewHeight, notificationViewWidth, notificationViewHeight)];
    
    if (self) {
        
        self.backgroundColor = [self appropriateColourForNotificationMessage:notificationMessage];
        
        
        self.notificationTypeIcon = [[UIImageView alloc] init];
        self.notificationTypeIcon.image = [self appropriateImageForNotificationMessage:notificationMessage];
        self.notificationTypeIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.notificationTypeIcon.frame = CGRectMake(10, notificationViewHeight * 0.5 - 36 * 0.5, 36, 36);
        
        [self addSubview:self.notificationTypeIcon];
        
        
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.notificationTypeIcon.frame) + 10,
                                                                      (notificationViewHeight * 0.5) - (titleHeight * 0.5),
                                                                      notificationViewWidth - (10 + CGRectGetMaxX(self.notificationTypeIcon.frame) + 10),
                                                                      titleHeight)];
        
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textColor = kMessageTextColour;
        self.messageLabel.font = kMessageFont;
        self.messageLabel.text = notificationMessage.message;
        
        [self addSubview:self.messageLabel];
        
        
        
        if (notificationMessage.buttonTitle) {
            
            self.buttonActionBlock = notificationMessage.buttonActionBlock;
            
            UIFont *buttonFont = [UIFont boldSystemFontOfSize:13];
            float titleHeight = 20;
            float titleWidth = [self widthForText:notificationMessage.buttonTitle withFont:buttonFont forHeight:titleHeight];
            
            self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
            self.actionButton.frame = CGRectMake(notificationViewWidth - titleWidth - 10,
                                                 notificationViewHeight - titleHeight - 10,
                                                 titleWidth,
                                                 titleHeight);
            
            self.actionButton.titleLabel.font = buttonFont;
            [self.actionButton setTitle:notificationMessage.buttonTitle forState:UIControlStateNormal];
            self.actionButton.tintColor = [UIColor whiteColor];
            [self.actionButton addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:self.actionButton];
        }
    }
    
    return self;
}
 */

@end
