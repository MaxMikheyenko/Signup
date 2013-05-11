//
//  User.h
//  SignUp
//
//  Created by Max Mikheyenko on 5/10/13.
//  Copyright (c) 2013 Max Mikheyenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userEmail;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * accessToken;
@property (nonatomic, retain) NSNumber * gameId;

+ (User*)createUserWithDictionary:(NSDictionary*)userData;
+ (User*)currentUser;
+ (void)setGameId:(NSNumber*)currentGameId;
@end
