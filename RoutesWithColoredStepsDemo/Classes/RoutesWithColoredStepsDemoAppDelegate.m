/**
 *  \file RoutesWithColoredStepsDemoAppDelegate.m
 *  \brief delegate.
 *	\author antoine
 *	\date 30/12/10
 *
 *  Created by antoine on 30/12/10.
 *  Copyright __MyCompanyName__ 2010. All rights reserved.
 */

#import "RoutesWithColoredStepsDemoAppDelegate.h"
#import "RoutesWithColoredStepsDemoViewController.h"

@implementation RoutesWithColoredStepsDemoAppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
    [self.window addSubview:viewController.view];
	viewController.mapView.delegate = self;
	viewController.searchBar.delegate = self;
	[self initToolbar];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
	[dataSourceIti release];
    [viewController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark init

-(void) initToolbar
{
	viewController.rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(buttonHasBeenPressed:)];
	viewController.leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(buttonHasBeenPressed:)];
	viewController.centeredButton = [[UIBarButtonItem alloc] initWithTitle:@"my text here" style:UIBarButtonItemStylePlain target:self action:@selector(buttonHasBeenPressed:)];
	
	UIBarButtonItem * spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	[viewController.toolBar setItems:[NSArray arrayWithObjects:viewController.leftButton, spacer, viewController.rightButton, nil]];
	[spacer release];
}


#pragma mark -
#pragma mark RMMapViewDelegate

- (void) beforeMapMove:(RMMapView *)map
{
	[map.userLocation setIsMapFollowMe:NO];
}

#pragma mark -
#pragma mark UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[MPGeocoder geocode:viewController.searchBar.text delegate:self context:@"MKS_SEARCH"];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
	[MPGeocoder cancelTasksWithDelegate:self];
	[viewController.searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark MPGeoLocDelegate

-(void)didFindLocation:(MPLocationData *)locationData context:(id)aContext
{
	viewController.searchBar.text = locationData.address;
	
	[viewController.searchBar resignFirstResponder];
	
	CLLocationCoordinate2D findLocation = locationData.location.coordinate;
	[viewController.mapView setCenterCoordinate:findLocation];
	
	MPMarkerManager * markerManager = [viewController.mapView markerManager];
	MPMarkerCategory * locCategory = [markerManager getCategory:MKS_LOC_CATEGORY];
	
	[locCategory.dataSource removeAllElements];
	MPPoi * poi = [[MPPoi alloc] initWithUId:locationData.address withLocation:findLocation];
	[locCategory.dataSource addElement:poi];
	[poi release];
	
	stepCount = -1;
	
	if (dataSourceIti != nil)
	{
		[[viewController.mapView pathManager] removePath:MKS_ROUTE_CATEGORY];
		[dataSourceIti release];
	}
	
	//Create step list : start step : userLocation and arrival step : geoElement location.
	CLLocation * userLoc = [[CLLocation alloc] initWithLatitude:viewController.mapView.userLocation.currentLocation.latitude longitude:viewController.mapView.userLocation.currentLocation.longitude];
	NSArray * steps = [NSArray arrayWithObjects:userLoc, locationData.location, nil]; 
	[userLoc release];
	//Create a bundle and the datasource
	dataSourceIti = [[MPRouteWithStepDataSource alloc] init:steps withBundle:[MPRouteBundle routeBundleWithVehicule:PEDESTRIAN withCost:LENGTH]];
	// create a polyline path
	MPPathPolylineMulticolor * path = [[MPPathPolylineMulticolor alloc] init];
	// set the polyline datasource
	[path setDataSource:(id<MPPathDataSource>)[dataSourceIti pathDataSource]];
	// add the new path in the path manager to be drawn on the map.
	[[viewController.mapView pathManager] addPath:path withName:MKS_ROUTE_CATEGORY];
	[path release];
}

#pragma mark -
#pragma mark button

- (IBAction)buttonHasBeenPressed:(id)sender
{
	if (sender == viewController.centeredButton)
	{
		NSLog(@"press center");
	}
	else if (sender == viewController.leftButton)
	{
		if (dataSourceIti != nil && [dataSourceIti getListOfElement] != nil && [[dataSourceIti getListOfElement] count] > 0)
		{
			//step hilight
			MPPathPolylineMulticolor * path = (MPPathPolylineMulticolor*)[[viewController.mapView pathManager] getPath:MKS_ROUTE_CATEGORY];
			path.highlightStyle.lineColor = [UIColor blueColor];
			stepCount -= 1;
			if (stepCount < 0)
				stepCount = [[dataSourceIti getListOfElement] count] - 1;
			NSLog(@"step %d, elementlistCount %d", stepCount, [[dataSourceIti getListOfElement] count]);
			[path hightlightStep:[[dataSourceIti getListOfElement] objectAtIndex:(stepCount)]];
			
		}
	}
	else if (sender == viewController.rightButton)
	{
		if (dataSourceIti != nil && [dataSourceIti getListOfElement] != nil && [[dataSourceIti getListOfElement] count] > 0)
		{
			//on hightlith l'etape 0
			MPPathPolylineMulticolor * path = (MPPathPolylineMulticolor*)[[viewController.mapView pathManager] getPath:MKS_ROUTE_CATEGORY];
			path.highlightStyle.lineColor = [UIColor blueColor];
			stepCount += 1;
			if (stepCount >= [[dataSourceIti getListOfElement] count])
				stepCount = 0;
			NSLog(@"step %d, elementlistCount %d", stepCount, [[dataSourceIti getListOfElement] count]);
			[path hightlightStep:[[dataSourceIti getListOfElement] objectAtIndex:(stepCount)]];
		}
	}
}

@end
