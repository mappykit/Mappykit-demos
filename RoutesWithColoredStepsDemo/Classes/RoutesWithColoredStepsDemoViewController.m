/**
 *  \file RoutesWithColoredStepsDemoViewController.m
 *  \brief controller.
 *	\author antoine
 *	\date 30/12/10
 *
 *  Created by antoine on 30/12/10.
 *  Copyright __MyCompanyName__ 2010. All rights reserved.
 */

#import "RoutesWithColoredStepsDemoViewController.h"

@implementation RoutesWithColoredStepsDemoViewController

@synthesize mapView, searchBar;
@synthesize rightButton, leftButton, centeredButton;
@synthesize toolBar;

- (void)viewDidLoad {
    [super viewDidLoad];
	//initialisation
	[MPInit initialisation:MAPPYKIT_API_KEY];
	[RMMapView class];
	
	mapView.showsUserLocation = YES;
	
	MPMarkerManager * markerManager = [mapView markerManager];
	[markerManager addCategory:MKS_LOC_CATEGORY withColor:[UIColor orangeColor]];
}

- (void)dealloc {
	[mapView release];
	[searchBar release];
	[leftButton release];
	[rightButton release];
	[centeredButton release];
	[toolBar release];
    [super dealloc];
}

@end
