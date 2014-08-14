//
//  BTBSubjectTableViewController.h
//  Fontys Roosterapp
//
//  Created by Arnold Broek on 10/08/14.
//  Copyright (c) 2014 Bas Broek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBSubjectTableViewCell.h"
#import "BTBCourse.h"

@interface BTBCourseTableViewController : UITableViewController <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableArray *courses;

@end
