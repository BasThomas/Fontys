//
//  BTBLoginViewController.h
//  Fontys Roosterapp
//
//  Created by Bas Thomas Broek on 11/08/14.
//  Copyright (c) 2014 Bas Broek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"

@interface BTBLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) KeychainItemWrapper *keychainItem;

@end
