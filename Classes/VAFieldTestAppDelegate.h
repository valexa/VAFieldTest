//
//  VAFieldTestAppDelegate.h
//  VAFieldTest
//
//  Created by Vlad Alexa on 7/6/10.
//  Copyright NextDesign 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VAFieldTestViewController;

@interface VAFieldTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    VAFieldTestViewController *viewController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet VAFieldTestViewController *viewController;

@end

