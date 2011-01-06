/**
 *  \file PoisAroundRouteDemoViewController.m
 *  \brief controller.
 *	\author antoine
 *	\date 30/12/10
 *
 *  Created by antoine on 30/12/10.
 *  Copyright Mappy 2010. All rights reserved.
 */

#import "PoisAroundRouteDemoViewController.h"

@implementation PoisAroundRouteDemoViewController

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
	MPMarkerCategory * carbuCategory = [markerManager addCategory:MKS_CARBU_CATEGORY withColor:[UIColor whiteColor]];
	carbuCategory.animateAtFirstShow =YES;
	carbuCategory.animatedLabel = YES;
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
