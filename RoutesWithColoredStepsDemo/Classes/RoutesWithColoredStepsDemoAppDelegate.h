/**
 *  \file RoutesWithColoredStepsDemoAppDelegate.h
 *  \brief delegate.
 *	\author antoine
 *	\date 30/12/10
 *
 *  Created by antoine on 30/12/10.
 *  Copyright __MyCompanyName__ 2010. All rights reserved.
 */
 
#import <UIKit/UIKit.h>
#import <MappyKit/MappyKit.h>

@class RoutesWithColoredStepsDemoViewController;

@interface RoutesWithColoredStepsDemoAppDelegate : NSObject <UIApplicationDelegate, RMMapViewDelegate, MPGeoLocDelegate, UISearchBarDelegate> {
    UIWindow *window;
    RoutesWithColoredStepsDemoViewController *viewController;
	
	MPItiDataSource * dataSourceIti;
	int stepCount;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RoutesWithColoredStepsDemoViewController *viewController;

- (IBAction) buttonHasBeenPressed:(id)sender;

-(void) initToolbar;

@end

