//
//  MyXMPP.m
//  XMPP_For_iPhone
//
//  Created by xu lingyi on 11/18/14.
//  Copyright (c) 2014 xuly. All rights reserved.
//

#import "MyXMPP.h"

#import "XMPP.h"
#import "XMPPJID.h"

#import "XMPPRoster.h"
#import "XMPPRosterMemoryStorage.h"

@interface MyXMPP()

@property (strong,nonatomic) CallBackBlock success;
@property (strong,nonatomic) CallBackBlockErr fail;
@property (strong,nonatomic) XMPPRosterMemoryStorateCallBack xmppRosterscallback;

@property (strong,nonatomic) XMPPRosterMemoryStorage *xmppRosterMemoryStorage;
@property (strong,nonatomic) XMPPRoster *xmppRoster;

@end

@implementation MyXMPP

- (BOOL)connect:(NSString *)account password:(NSString *)password host:(NSString *)host success:(CallBackBlock)Success fail:(CallBackBlockErr)Fail
{
    if (self.xmppStream == nil) {
        self.xmppStream = [[XMPPStream alloc] init];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }

    self.password = password;
    self.success = Success;
    
    self.fail = Fail;
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }
    
    if (account == nil) {
        return NO;
    }
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:account]];
    [self.xmppStream setHostName:host];
    
    NSError *err = nil;
    if (![self.xmppStream connectWithTimeout:30 error:&err]) {
        NSLog(@"cant connect %@", host);
        Fail(err);
        return NO;
    }
    
    return YES;
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

- (void)getRosterList:(XMPPRosterMemoryStorateCallBack)callback {
    self.xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterMemoryStorage];
    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppRoster activate:self.xmppStream];
    
    NSLog(@"fetchRoster");
    self.xmppRosterscallback = callback;
    [self.xmppRoster fetchRoster];
}

// connect 成功后回调
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"connected");
    NSError *error = nil;
    
    [[self xmppStream] authenticateWithPassword:self.password error:&error];
    if(error!=nil)
    {
        NSLog(@"login fail");
        self.fail(error);
    }
}

// authenticateWithPassword 成功后调用
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    [self goOnline];
    self.success();
}


// authenticateWithPassword 失败后调用
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    NSLog(@"not authenticated");
    NSError *err = [[NSError alloc] initWithDomain:Domain code:-100 userInfo:@{@"detail": @"not authorized"}];
    self.fail(err);
}

// fetchRoster 后调用。
- (void)xmppRosterDidPopulate:(XMPPRosterMemoryStorage *)sender{
    if(self.xmppRosterscallback){
        self.xmppRosterscallback(sender);
    }
}

@end
