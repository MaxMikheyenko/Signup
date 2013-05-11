//
//  ViewController.m
//  SignUp
//
//  Created by Max Mikheyenko on 5/10/13.
//  Copyright (c) 2013 Max Mikheyenko. All rights reserved.
//

#import "SignUpViewController.h"
#import "ApiCalls.h"

@interface SignUpViewController ()
- (BOOL)validateInput;
@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

  //populates fields with test data
//  self.userName.text = @"user";
//  self.email.text = @"user@user.use";
//  self.password.text = @"pass";
//  self.confirmPassword.text = @"pass";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if(textField.tag<4)
  {
     [[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
  } else {
    [textField resignFirstResponder];
  }
    return YES;
}

#pragma mark - Input Validation Methods

- (BOOL)validateInput
{
  NSString* errorText = @"";
  
  //Validate username
  if([self.userName.text isEqualToString:@""])
    errorText = [errorText stringByAppendingFormat:@"Please Enter Username. "];
  
  //Validate Email
  NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  if (![emailTest evaluateWithObject:self.email.text])
    errorText = [errorText stringByAppendingFormat:@"Email is invalid. "];
  
  //Validate Password
  if([self.password.text isEqualToString:@""])
    errorText = [errorText stringByAppendingFormat:@"Please Enter Password. "];
  
  //Validate Confirmation
  if(![self.confirmPassword.text isEqualToString:self.password.text])
    errorText = [errorText stringByAppendingFormat:@"Password and Confirmation don't Match."];
  
  if([errorText isEqualToString:@""])
  {
    return YES;
  } else {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:errorText delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
    return NO;
  }
}
#pragma mark - IBAction Methods

- (IBAction)signUp:(id)sender {
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createGame) name:@"SignupSuccessful" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signupFailed) name:@"SignupFailed" object:nil];
  
  if([self validateInput])
  {
    self.view.userInteractionEnabled = NO;
    [ApiCalls signUpWithUsername:self.userName.text email:self.email.text password:self.password.text];
  }
}

#pragma mark - Helper Methods
- (void)signupFailed
{
  self.view.userInteractionEnabled = YES;
}

- (void)createGame
{
  [[[UIAlertView alloc] initWithTitle:@"Success" message:@"SignUp Successful" delegate:self cancelButtonTitle:@"Create Game" otherButtonTitles:nil] show];
}

#pragma mark - AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  [ApiCalls createGameForCurrentUser];  
}

@end
