//
//  BTBSubjectTableViewController.h
//  Fontys Roosterapp
//
//  Created by Bas Thomas Broek on 10/08/14.
//  Copyright (c) 2014 Bas Broek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBSubjectTableViewCell.h"
#import "BTBCourse.h"
#import "BTBLoginViewController.h"
@class Reachability;

@interface BTBCourseTableViewController : UITableViewController <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData *urlData;
@property (nonatomic, strong) NSMutableArray *courses;

@property (nonatomic, strong) NSArray *days;

@property (nonatomic, strong) NSMutableArray *courseMonday;
@property (nonatomic, strong) NSMutableArray *courseTuesday;
@property (nonatomic, strong) NSMutableArray *courseWednesday;
@property (nonatomic, strong) NSMutableArray *courseThursday;
@property (nonatomic, strong) NSMutableArray *courseFriday;

@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *institute;

@property (nonatomic, strong) NSMutableArray *timetableClasses;
@property (nonatomic, strong) NSMutableArray *destructingClasses;

@property (nonatomic, strong) NSString *week;

@property (nonatomic) BOOL foundSubjects;

@property (nonatomic, strong) Reachability *internetReachable;
@property (nonatomic, strong) Reachability *hostReachable;
@property (nonatomic) BOOL internetActive;
@property (nonatomic) BOOL hostActive;

- (NSString *)currentWeek;
- (void)checkNetworkStatus:(NSNotification *)notice;

@end
