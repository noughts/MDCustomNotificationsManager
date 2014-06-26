//
//  MDNotificationView.h
//  MDCustomNotificationsManager
//
//  Created by noughts on 2014/06/26.
//  Copyright (c) 2014年 Magic Dealers. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDNotificationMessage;

@interface MDNotificationView : UIView

@property(nonatomic) MDNotificationMessage* notificationMessage;

-(id)initWithNotificationMessage:(MDNotificationMessage*)notificationMessage;

@end
