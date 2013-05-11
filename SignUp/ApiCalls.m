//
//  ApiCalls.m
//  SignUp
//
//  Created by Max Mikheyenko on 5/10/13.
//  Copyright (c) 2013 Max Mikheyenko. All rights reserved.
//

#import "ApiCalls.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "User.h"

@implementation ApiCalls

+ (void)signUpWithUsername:(NSString*)userName email:(NSString*)email password:(NSString*)password
{
  NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/signup", [AppDelegate APIURL]]];
  ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:requestUrl];

  [request setRequestMethod:@"POST"];
  [request addPostValue:email forKey:@"email"];
  [request addPostValue:password forKey:@"password"];
  [request addPostValue:userName forKey:@"user_name"];
  [request addPostValue:@"12345678" forKey:@"device_token"];
  
  ASIFormDataRequest *weakRequest = request;
  [request setCompletionBlock:^{
    NSDictionary *responseData = [[JSONDecoder decoder] parseJSONData:weakRequest.responseData];
    NSLog(@"response: %@", responseData);
    
    if([[responseData objectForKey:@"code"] integerValue] == 106)
    {
      [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Email Already Exists" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"SignupFailed" object:nil];
      return;
    }

    if([[responseData objectForKey:@"code"] integerValue] == 202)
    {
      [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Username Already Taken" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"SignupFailed" object:nil];
      return;
    }

    if([[responseData objectForKey:@"status"] isEqualToString:@"success"])
    {
      [User createUserWithDictionary:responseData];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"SignupSuccessful" object:nil];
    }
    }];
  
  [request setFailedBlock:^{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"SignUp Failed" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SignupFailed" object:nil];
  }];
  
  [request startAsynchronous];
}

+ (void)createGameForCurrentUser
{
  User *user = [User currentUser];
  if(!user)
    return;
  
  NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/game/create", [AppDelegate APIURL]]];
  ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:requestUrl];
  [request setRequestMethod:@"POST"];
  [request addPostValue:user.userId forKey:@"user_id"];
  [request addPostValue:user.userEmail forKey:@"email"];
  [request addPostValue:user.accessToken forKey:@"access_token"];
  
  ASIFormDataRequest *weakRequest = request;
  [request setCompletionBlock:^{
    NSDictionary *responseData = [[JSONDecoder decoder] parseJSONData:weakRequest.responseData];
    int statusCode = [[responseData objectForKey:@"code"] integerValue];
    
    switch (statusCode) {
      case 109:
        [[[UIAlertView alloc] initWithTitle:@"Status" message:@"Can't Find an Opponent" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        break;

      case 200:
        [User setGameId:[responseData objectForKey:@"game_id"]];
        break;
        
      default:
        [[[UIAlertView alloc] initWithTitle:@"Status" message:[responseData objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        break;
    }
  }];
  
  [request setFailedBlock:^{
    NSLog(@"error: %@", weakRequest.responseStatusMessage);
  }];
  
  [request startAsynchronous];
}
@end
