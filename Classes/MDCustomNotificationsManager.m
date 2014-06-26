//
//  MDCustomNotificationsManager.m
//  BeAdict
//
//  Created by Thecafremo on 21/12/13.
//  Copyright (c) 2013 MagicDealers. All rights reserved.
//

#import "MDCustomNotificationsManager.h"
#import "MDNotificationView.h"

static UIFont *kMessageFont = nil;
static UIColor *kMessageTextColour = nil;

@interface MDCustomNotificationsManager ()

@property (nonatomic, strong) UIView *notificationView;
@property (nonatomic, copy) ActionCompletionBlock actualActionCompletionBlock;
@property (nonatomic, assign) float displayingSeconds;
@property (nonatomic, strong) NSMutableArray *messagesQueueArray;

@end

@implementation MDCustomNotificationsManager

#pragma mark Actions.

- (void)startPresentionProcess {
    
    MDNotificationMessage *notificationMessage = [self.messagesQueueArray objectAtIndex:0];
    self.actualActionCompletionBlock = notificationMessage.actionCompletionBlock;
    
    if (notificationMessage.displayingSeconds) self.displayingSeconds = notificationMessage.displayingSeconds;
    
	self.notificationView = [[MDNotificationView alloc] initWithNotificationMessage:notificationMessage];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePressAndHoldGesture:)];
    longPress.minimumPressDuration = 0.01;
    longPress.cancelsTouchesInView = NO;
    
    [self.notificationView addGestureRecognizer:longPress];
    
    [self presentNotification];
}


- (void)presentNotification {
	// 初期位置設定
	CGRect notificationFrame1 = self.notificationView.frame;
    notificationFrame1.origin.y = 0 - self.notificationView.frame.size.height;
	self.notificationView.frame = notificationFrame1;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.notificationView];
    self.notificationView.window.windowLevel = UIWindowLevelAlert;
    
    
    CGRect notificationFrame = self.notificationView.frame;
    notificationFrame.origin.y = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.notificationView.frame = notificationFrame;
        
    } completion:^(BOOL finished) {
        [self performSelector:@selector(dismissNotification:) withObject:nil afterDelay:self.displayingSeconds];
    }];
}


- (void)dismissNotification:(id)sender {
    
    CGRect notificationFrame = self.notificationView.frame;
    notificationFrame.origin.y -= notificationFrame.size.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.notificationView.frame = notificationFrame;
        
    } completion:^(BOOL finished) {
        
        self.notificationView.window.windowLevel = UIWindowLevelStatusBar - 1;
        [self.notificationView removeFromSuperview];
        [self.messagesQueueArray removeObjectAtIndex:0];
        
        if ([self.messagesQueueArray count] != 0) {
            [self startPresentionProcess];
        }
    }];
    
    if (self.actualActionCompletionBlock) self.actualActionCompletionBlock();
}


- (void)handlePressAndHoldGesture:(UILongPressGestureRecognizer *)pressAndHold {
    
    if (pressAndHold.state == UIGestureRecognizerStateBegan) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
    } else  if (pressAndHold.state == UIGestureRecognizerStateEnded) {
        [self dismissNotification:nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"kMPNotificationViewTapReceivedNotification" object:self.notificationView];
    }
}


#pragma mark Public Methods.

+ (void)displayNotificationWithMessage:(NSString *)message ofType:(MDCustomNotificationType)notificationType {
    
    [self displayNotificationWithMessage:message ofType:notificationType withActionCompletionBlock:nil];
}


+ (void)displayNotificationWithMessage:(NSString *)message ofType:(MDCustomNotificationType)notificationType withActionCompletionBlock:(ActionCompletionBlock)actionCompletionBlock {
    
    [self displayNotificationWithMessage:message ofType:notificationType withButtonWithTitle:nil buttonActionBlock:nil actionCompletionBlock:actionCompletionBlock];
}


+ (void)displayNotificationWithMessage:(NSString *)message ofType:(MDCustomNotificationType)notificationType withButtonWithTitle:(NSString *)buttonTitle buttonActionBlock:(ButtonActionBlock)buttonActionBlock {
    
    [self displayNotificationWithMessage:message ofType:notificationType withButtonWithTitle:buttonTitle buttonActionBlock:buttonActionBlock actionCompletionBlock:nil];
}


+ (void)displayNotificationWithMessage:(NSString *)message ofType:(MDCustomNotificationType)notificationType withButtonWithTitle:(NSString *)buttonTitle buttonActionBlock:(ButtonActionBlock)buttonActionBlock actionCompletionBlock:(ActionCompletionBlock)actionCompletionBlock {
    
    MDNotificationMessage *notificationMessage = [[MDNotificationMessage alloc] init];
    notificationMessage.message = message;
    notificationMessage.notificationType = notificationType;
    notificationMessage.buttonTitle = buttonTitle;
    notificationMessage.buttonActionBlock = buttonActionBlock;
    notificationMessage.actionCompletionBlock = actionCompletionBlock;
    
    [self displayNotificationWithMDNotificationMessage:notificationMessage];
}


+ (void)displayNotificationWithMDNotificationMessage:(MDNotificationMessage *)notificationMessage {
    
    [[MDCustomNotificationsManager sharedInstance].messagesQueueArray addObject:notificationMessage];
    if ([[MDCustomNotificationsManager sharedInstance].messagesQueueArray count] == 1) [[MDCustomNotificationsManager sharedInstance] startPresentionProcess];
}


#pragma mark Singleton's LifeCycle.

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        kMessageFont = [UIFont boldSystemFontOfSize:16.0];
        kMessageTextColour = [UIColor whiteColor];
        
        self.messagesQueueArray = [[NSMutableArray alloc] init];
        self.displayingSeconds = 3;
    }
    
    return self;
}


+ (MDCustomNotificationsManager *)sharedInstance {
    
    static MDCustomNotificationsManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MDCustomNotificationsManager alloc] init];
    });
    
    return instance;
}

@end


#pragma mark -

@implementation MDNotificationMessage


@end
