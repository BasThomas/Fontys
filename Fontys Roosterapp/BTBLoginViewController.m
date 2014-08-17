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
	
	self.keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"login"
															accessGroup:nil];
	
	[self.keychainItem setObject:self.usernameTextField.text
						  forKey:(__bridge id)kSecAttrAccount];
	
	[self.keychainItem setObject:self.passwordTextField.text
						  forKey:(__bridge id)kSecValueData];
    
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
