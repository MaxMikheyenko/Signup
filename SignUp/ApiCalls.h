//
//  ApiCalls.h
//  SignUp
//
//  Created by Max Mikheyenko on 5/10/13.
//  Copyright (c) 2013 Max Mikheyenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface ApiCalls : NSObject

+ (void)signUpWithUsername:(NSString*)userName email:(NSString*)email password:(NSString*)password;
+ (void)createGameForCurrentUser;
@end
