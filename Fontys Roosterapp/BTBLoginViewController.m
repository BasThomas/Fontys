//
//  BTBLoginViewController.m
//  Fontys Roosterapp
//
//  Created by Bas Thomas Broek on 11/08/14.
//  Copyright (c) 2014 Bas Broek. All rights reserved.
//

#import "BTBLoginViewController.h"

@implementation BTBLoginViewController

- (IBAction)login:(id)sender
{
    // Check internet connection.
    
    // Login...
    NSLog(@"Logging in...");
    
    // Setup user below.
    
    [self performSegueWithIdentifier:@"loginSegue"
                              sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Logged in.");
}

@end
