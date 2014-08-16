//
//  BTBSubjectTableViewCell.h
//  Fontys Roosterapp
//
//  Created by Arnold Broek on 11/08/14.
//  Copyright (c) 2014 Bas Broek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTBSubjectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationTeacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *noSubjectLabel;

@end
