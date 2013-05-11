//
//  User.m
//  SignUp
//
//  Created by Max Mikheyenko on 5/10/13.
//  Copyright (c) 2013 Max Mikheyenko. All rights reserved.
//

#import "User.h"
#import "AppDelegate.h"

@implementation User

@dynamic userName;
@dynamic userEmail;
@dynamic userId;
@dynamic accessToken;
@dynamic gameId;

+ (User*)createUserWithDictionary:(NSDictionary *)userData
{
  AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
  if([self currentUser])
  {
    [appDelegate.managedObjectContext deleteObject:[self currentUser]];
    [appDelegate.managedObjectContext save:nil];
  }
    
  User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:appDelegate.managedObjectContext];
  
  user.userName = [userData objectForKey:@"user_name"];
  user.userId = [userData objectForKey:@"user_id"];
  user.userEmail = [userData objectForKey:@"user_email"];
  user.accessToken = [userData objectForKey:@"access_token"];
  
  [appDelegate.managedObjectContext save:nil];
  
  return [self currentUser];
}

+ (User*)currentUser
{
  NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"User"];
  fetch.fetchLimit = 1;
  
  AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
  NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
  
  if(results.count > 0)
  {
    User *currentUser = (User*)[results objectAtIndex:0];
    return currentUser;
  }
  return nil;
}

+ (void)setGameId:(NSNumber*)currentGameId
{
  [User currentUser].gameId = currentGameId;
  AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
  [appDelegate.managedObjectContext save:nil];
}
@end
