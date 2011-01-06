/**
 *  \file PoisAroundRouteDemoAppDelegate.h
 *  \brief delegate.
 *	\author antoine
 *	\date 30/12/10
 *
 *  Created by antoine on 30/12/10.
 *  Copyright Mappy 2010. All rights reserved.
 */
 
#import <UIKit/UIKit.h>
#import <MappyKit/MappyKit.h>

@class PoisAroundRouteDemoViewController;

@interface PoisAroundRouteDemoAppDelegate : NSObject <UIApplicationDelegate, RMMapViewDelegate, MPGeoLocDelegate, UISearchBarDelegate> {
    UIWindow *window;
    PoisAroundRouteDemoViewController *viewController;
	
	MPItiDataSource * dataSourceIti;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PoisAroundRouteDemoViewController *viewController;

- (IBAction) buttonHasBeenPressed:(id)sender;

-(void) initToolbar;

@end

