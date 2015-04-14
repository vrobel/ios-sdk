//
//  CLVOAuthWebViewController.m
//  CleverSDK
//
//  Created by Nikhil Pandit on 4/3/15.
//  Copyright (c) 2015 Clever, Inc. All rights reserved.
//

#import "CLVOAuthWebViewController.h"
#import "CLVOAuthManager.h"

@interface CLVOAuthWebViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, weak) UIViewController *parent;

@end

@implementation CLVOAuthWebViewController

- (id)initWithParent:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        self.parent = viewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenReceived:) name:CLVAccessTokenReceivedNotification object:nil];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    
    if ([CLVOAuthManager clientIdIsNotSet]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Clever Client ID is not set"
                                   delegate:nil
                          cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://clever.com/oauth/authorize?response_type=token&client_id=%@&redirect_uri=%@",
                           [CLVOAuthManager clientId], [CLVOAuthManager redirectUri]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)accessTokenReceived:(NSNotification *)notification {
    [self dismissViewControllerAnimated:NO completion:^{
        [CLVOAuthManager callSucessHandler];
    }];
}

@end
