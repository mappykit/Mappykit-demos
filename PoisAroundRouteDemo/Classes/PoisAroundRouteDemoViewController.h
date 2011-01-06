/**
 *  \file PoisAroundRouteDemoViewController.h
 *  \brief controller.
 *	\author antoine
 *	\date 30/12/10
 *
 *  Created by antoine on 30/12/10.
 *  Copyright Mappy 2010. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <MappyKit/MappyKit.h>

#define MKS_LOC_CATEGORY @"loc"
#define MKS_ROUTE_CATEGORY @"route"
#define MKS_CARBU_CATEGORY @"carbu"

@interface PoisAroundRouteDemoViewController : UIViewController {
	RMMapView * mapView;
	UISearchBar * searchBar;
	
	//button
	UIBarButtonItem * rightButton;
	UIBarButtonItem * leftButton;
	UIBarButtonItem * centeredButton;
	
	UIToolbar * toolBar;
}

@property (nonatomic, retain) IBOutlet RMMapView * mapView;
@property (nonatomic, retain) IBOutlet UISearchBar * searchBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * rightButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * leftButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * centeredButton;
@property (nonatomic, retain) IBOutlet UIToolbar * toolBar;

@end

