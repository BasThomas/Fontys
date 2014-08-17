//
//  BTBSubjectTableViewCell.m
//  Fontys Roosterapp
//
//  Created by Arnold Broek on 11/08/14.
//  Copyright (c) 2014 Bas Broek. All rights reserved.
//

#import "BTBSubjectTableViewCell.h"

@implementation BTBSubjectTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self
                          selector:@selector(updateTableForDynamicType)
                              name:UIContentSizeCategoryDidChangeNotification
                            object:nil];
    }
    
    return self;
}

- (void)updateTableForDynamicType
{
    UIFont *bodyFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	UIFont *captionFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    
	self.startTimeLabel.font = captionFont;
	self.endTimeLabel.font = captionFont;
    
    self.subjectLabel.font = bodyFont;
    self.locationTeacherLabel.font = captionFont;
	
	self.noSubjectLabel.font = bodyFont;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateTableForDynamicType];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
