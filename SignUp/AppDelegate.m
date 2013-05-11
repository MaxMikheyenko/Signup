//
//  AppDelegate.m
//  SignUp
//
//  Created by Max Mikheyenko on 5/10/13.
//  Copyright (c) 2013 Max Mikheyenko. All rights reserved.
//

#import "AppDelegate.h"

#import "SignUpViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  self.viewController = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
  self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Helper Methods

+ (NSString*)APIURL
{
  return @"http://ec2-54-224-181-7.compute-1.amazonaws.com";
}

#pragma mark - Core Data Singletons
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  if (_persistentStoreCoordinator == nil) {
    NSURL *persistenceDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL *storeURL = [persistenceDirectory URLByAppendingPathComponent:@"signup_iphone.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
    [options setValue:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setValue:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
      //TODO something a lot more sophisticated here
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
  
  return _persistentStoreCoordinator;
}


- (NSManagedObjectModel *)managedObjectModel
{
  if (_managedObjectModel == nil) {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  }
  
  return _managedObjectModel;
}


- (NSManagedObjectContext *)managedObjectContext
{
  if (_managedObjectContext == nil) {
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
      _managedObjectContext = [[NSManagedObjectContext alloc] init];
      [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
  }
  
  return _managedObjectContext;
}


@end
