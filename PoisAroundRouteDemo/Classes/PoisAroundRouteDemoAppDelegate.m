/**
 *  \file PoisAroundRouteDemoAppDelegate.m
 *  \brief delegate.
 *	\author antoine
 *	\date 30/12/10
 *
 *  Created by antoine on 30/12/10.
 *  Copyright Mappy 2010. All rights reserved.
 */

#import "PoisAroundRouteDemoAppDelegate.h"
#import "PoisAroundRouteDemoViewController.h"

@implementation PoisAroundRouteDemoAppDelegate

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
	viewController.centeredButton = [[UIBarButtonItem alloc] initWithTitle:@"show fuel station" style:UIBarButtonItemStylePlain target:self action:@selector(buttonHasBeenPressed:)];
	
	UIBarButtonItem * spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	[viewController.toolBar setItems:[NSArray arrayWithObjects:spacer, viewController.centeredButton, spacer, nil]];
	[spacer release];
}


#pragma mark -
#pragma mark RMMapViewDelegate

- (void) beforeMapMove:(RMMapView *)map
{
	[map.userLocation setIsMapFollowMe:NO];
}

- (void) tapOnMarker: (MPMarker*) marker 
			   onMap: (RMMapView*) map
{
	if (marker != viewController.mapView.userLocation)
	{
		[viewController.mapView.markerManager hideAllLabel];
		[marker toggleLabel];
	}
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
	
	//compute route to user location
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
	dataSourceIti = [[MPRouteWithStepDataSource alloc] init:steps withBundle:[MPRouteBundle routeBundleWithVehicule:MIDCAR withCost:LENGTH]];
	// create a polyline path
	MPPathPolyline * path = [[MPPathPolyline alloc] init];
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
		
		MPMarkerManager *markerManager = [viewController.mapView markerManager];
		MPMarkerCategory * categoryCarbu = [markerManager getCategory:MKS_CARBU_CATEGORY];
		
		//add a new mappy poi datasource for fuel station around route; we limit the number of station showed to 10
		MPPoiDataSource * dataSource = [dataSourceIti getPoiAroundRoute:5012 number:10];
		//set the zoom to be optimal : show all poi in the category
		[categoryCarbu setOptimalZoom:YES];
		//set label hidden for the first appear on map
		[categoryCarbu setHideLabelOnTheFirstShow:YES];
		[categoryCarbu setDataSource:dataSource];
	}
	else if (sender == viewController.leftButton)
	{
		NSLog(@"press left");
	}
	else if (sender == viewController.rightButton)
	{
		NSLog(@"press right");
	}
	NSLog(@"here");
}

@end
