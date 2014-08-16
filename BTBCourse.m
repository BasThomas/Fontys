//
//  BTBCourse.m
//  Fontys Roosterapp
//
//  Created by Arnold Broek on 11/08/14.
//  Copyright (c) 2014 Bas Broek. All rights reserved.
//

#import "BTBCourse.h"

@implementation BTBCourse

- (instancetype)initWithStartTime:(NSString *)startTime
                                 :(NSString *)endTime
                                 :(NSString *)date
                                 :(NSString *)text
{
	self = [super init];
	
	if (self)
	{
        self.teacher = NO;
        self.location = NSLocalizedString(@"Unknown location", @"Unknown location");
        
        self.startTime = startTime;
        self.endTime = endTime;
        self.date = date;
        self.text = text;
        
		[self textToTypes];
	}
	
	return self;
}

- (void)textToTypes
{
    NSArray *splitText = [[NSArray alloc] init];
    splitText = [self.text componentsSeparatedByString:@" "];
    
    if (![[splitText objectAtIndex:0] isEqual: @"-"])
    {
        self.teacherName = [NSString stringWithFormat:@"— %@", [splitText objectAtIndex:0]];
    }
    else
    {
        self.teacherName = [NSString stringWithFormat:@"— %@", NSLocalizedString(@"selfstudy", @"Selfstudy")];
    }
    self.subjectName = [splitText objectAtIndex:1];
    
    BOOL checkedForLocation = NO;
    BOOL checkedForTeacher = NO;
    
    int amountOfLocations = 0;
    
    for (NSString *word in splitText)
    {
        // Check room location.
        if ([word characterAtIndex:0] == 'R')
        {
            amountOfLocations++;
            
            if (!checkedForLocation)
            {
                self.location = word;
                checkedForLocation = YES;
            }
        }
        
        // Check for teacher.
        if (!checkedForTeacher)
        {
            if([word rangeOfString:@"zw"].location != NSNotFound)
            {
                // Has no teacher.
                self.teacher = NO;
                checkedForTeacher = YES;
                
                break;
            }
        }
    }
    
    if (amountOfLocations > 1)
    {
        NSString *teachers = [[NSString alloc] init];
        teachers = [teachers stringByAppendingString:@"— "];
        
        for (int i = 0; i < amountOfLocations; i++)
        {
            if (i != (amountOfLocations - 1))
            {
                teachers = [teachers stringByAppendingFormat:@"%@, ", splitText[i]];
                NSLog(@"%@", splitText[i]);
            }
            else
            {
                teachers = [teachers stringByAppendingFormat:@"%@", splitText[i]];
            }
        }
        
        self.teacherName = teachers;
        self.subjectName = splitText[amountOfLocations];
    }
}

@end
