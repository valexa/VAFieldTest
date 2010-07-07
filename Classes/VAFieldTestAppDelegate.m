//
//  VAFieldTestAppDelegate.m
//  VAFieldTest
//
//  Created by Vlad Alexa on 7/6/10.
//  Copyright NextDesign 2010. All rights reserved.
//


#import "VAFieldTestAppDelegate.h"
#import "VAFieldTestViewController.h"

@implementation VAFieldTestAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
		
    return YES;
}



- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end