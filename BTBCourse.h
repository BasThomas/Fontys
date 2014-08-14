//
//  BTBCourse.h
//  Fontys Roosterapp
//
//  Created by Arnold Broek on 11/08/14.
//  Copyright (c) 2014 Bas Broek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTBCourse : NSObject

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *text;

- (instancetype) init;

@end
