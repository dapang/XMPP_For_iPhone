//
//  MyXMPP.h
//  XMPP_For_iPhone
//
//  Created by xu lingyi on 11/18/14.
//  Copyright (c) 2014 xuly. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMPPStream;
@class XMPPPresence;
@class XMPPRoster;
@class XMPPRosterMemoryStorage;

@interface MyXMPP : NSObject

typedef void (^CallBackBlock) (void);
typedef void (^CallBackBlockErr) (NSError *result);
typedef void (^XMPPRosterMemoryStorateCallBack) (XMPPRosterMemoryStorage *rosters);

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;

@property (nonatomic,strong) XMPPStream *xmppStream;

- (BOOL)connect:(NSString *)account password:(NSString *)password host:(NSString *)host success:(CallBackBlock)Success fail:(CallBackBlockErr)Fail;

- (void)goOnline;

- (void)getRosterList:(XMPPRosterMemoryStorateCallBack)callback;

@end
