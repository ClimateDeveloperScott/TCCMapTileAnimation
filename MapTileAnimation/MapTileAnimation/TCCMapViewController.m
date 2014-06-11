//
//  TCCViewController.m
//  MapTileAnimation
//
//  Created by Bruce Johnson on 6/11/14.
//  Copyright (c) 2014 The Climate Corporation. All rights reserved.
//

#import "TCCMapViewController.h"
#import "TCCTimeFrameParser.h"

#import "TCCMapTileProviderProtocol.h"
#import "TCCMapTileProvider.h"

#define FUTURE_RADAR_FRAMES_URI "https://qa1-twi.climate.com/assets/wdt-future-radar/LKG.txt?grower_apps=true"
//#define FUTURE_RADAR_FRAMES_URI "http://climate.com/assets/wdt-future-radar/LKG.txt?grower_apps=true"

@interface TCCMapViewController () <MKMapViewDelegate>

@property (nonatomic, readwrite, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, readwrite, strong) TCCMapTileProvider *tileProvider;
@property (nonatomic, readwrite, strong) TCCTimeFrameParser *timeFrameParser;

@end

@implementation TCCMapViewController
//============================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set the starting  location.
    CLLocationCoordinate2D startingLocation;
    startingLocation.latitude = 38.6272;  //St. Louis, MO
    startingLocation.longitude = -90.1978;
	
	self.mapView.region = MKCoordinateRegionMakeWithDistance(startingLocation, 180000, 180000);
    [self.mapView setCenterCoordinate: startingLocation];

	self.tileProvider = [[TCCMapTileProvider alloc] initWithTimeFrameURI: @FUTURE_RADAR_FRAMES_URI delegate: self];
}
//============================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//============================================================
#pragma mark - TCCMapTileProvider Protocol
//============================================================
- (void) tileProvider: (TCCMapTileProvider *)aProvider didFetchTimeFrameData: (NSData *)theTimeFrameData
{
	__block TCCMapViewController *mapController = self;
	
	self.timeFrameParser = [[TCCTimeFrameParser alloc] initWithData: theTimeFrameData];

	NSArray *templateURLs = self.timeFrameParser.templateFrameTimeURLs;
	NSString *templateURL = [templateURLs firstObject];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		MKTileOverlay *tileOverlay = [[MKTileOverlay alloc] initWithURLTemplate: templateURL];
		[mapController.mapView addOverlay: tileOverlay];
	});
}
//============================================================
#pragma mark - MKMapViewDelegate Protocol
//============================================================
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
	
}
//============================================================
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	
}
//============================================================
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
	if ([overlay isKindOfClass: [MKTileOverlay class]])
	{
		MKTileOverlayRenderer *renderer = [[MKTileOverlayRenderer alloc] initWithTileOverlay: (MKTileOverlay *)overlay];
		return renderer;
	}
	return nil;
}
//============================================================

//============================================================

@end
