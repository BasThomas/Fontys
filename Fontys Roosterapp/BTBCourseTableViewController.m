//
//  BTBSubjectTableViewController.m
//  Fontys Roosterapp
//
//  Created by Arnold Broek on 10/08/14.
//  Copyright (c) 2014 Bas Broek. All rights reserved.
//

#import "BTBCourseTableViewController.h"

@interface BTBCourseTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

@end

@implementation BTBCourseTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        {
			self.courses = [[NSMutableArray alloc] init];
			
			self.apiKey = @"f4IcdWfO7U2UcjGpIPjMGA";
			self.institute = @"FHI";
			self.timetableClass = @"s32";
			[self currentWeek];
			self.week = @"20140901";
			
			[self fetchData];
            
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            [defaultCenter addObserver:self
                              selector:@selector(updateTableForDynamicType)
                                  name:UIContentSizeCategoryDidChangeNotification
                                object:nil];
        }
    
    return self;
}

#pragma mark - Helper functions

- (NSString *)currentWeek
{
	NSDate *today = [[NSDate alloc] init];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	components = [calendar components:NSWeekdayCalendarUnit
							 fromDate:today];
	
	NSUInteger weekdayToday = [components weekday];
	NSInteger daysToMonday = (9 - weekdayToday) % 7;
	
	NSDateFormatter *apiFormat = [[NSDateFormatter alloc] init];
	[apiFormat setDateFormat:@"yyyyMMdd"];
	
	NSDate *sectionDate = [[NSDate alloc] init];
	
	if ([components weekday] == 1 || [components weekday] == 7)
	{
		sectionDate = [today dateByAddingTimeInterval:60 * 60 * 24 * daysToMonday];
		self.week = [NSString stringWithFormat:@"%@", [apiFormat stringFromDate:sectionDate]];
	}
	else
	{
		sectionDate = [today dateByAddingTimeInterval:60 * 60 * 24 * -daysToMonday];
		self.week = [NSString stringWithFormat:@"%@", [apiFormat stringFromDate:sectionDate]];
	}
	
	return self.week;
}

#pragma mark - IBActions

- (IBAction)refresh:(UIRefreshControl *)sender
{
	// Refreshing...
    NSLog(@"Refreshing...");
	
	self.foundSubjects = NO;
	[self.courses removeAllObjects];
	[self.tableView reloadData];
    
	[self fetchData];
	
    [sender endRefreshing];
}

- (IBAction)logout:(id)sender
{
	// Get rid of all things here...
    NSLog(@"Logging out...");
    
    [self performSegueWithIdentifier:@"logoutSegue"
                              sender:self];
}

#pragma mark - JSON handling

- (void)fetchData
{
	// Prepare request
    NSString *loginString = [NSString stringWithFormat:@"%@:%@", @"306880@student.fontys.nl", @"BxF-LZJ-D6s-erH"];
    NSString *encodedLoginData = [BTBCourseTableViewController base64String:loginString];
    NSString *base64LoginData = [NSString stringWithFormat:@"Basic %@", encodedLoginData];
	
	NSString *urlString = [NSString stringWithFormat:@"https://secapi.fontys.nl/json.ashx?app=%@&rooster_institute=%@&rooster_class=%@&rooster_week=%@", self.apiKey, self.institute, self.timetableClass, self.week];
	
	NSLog(@"%@", urlString);
	
    NSURL *url= [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:base64LoginData
   forHTTPHeaderField:@"Authorization"];
    
    NSURLConnection *urlConnection;
    urlConnection = [[NSURLConnection alloc] initWithRequest:request
                                                    delegate:self];
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    self.urlData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection
	didReceiveData:(NSData *)data
{
    [self.urlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *json = [[NSString alloc] initWithData:self.urlData
                                           encoding:NSUTF8StringEncoding];
	if ([json rangeOfString:@"No data available for selected week."].location != NSNotFound)
	{
		return;
	}
	
	[self finished:json
			  data:self.urlData];
}

- (void) finished:(NSString *)json
			 data:(NSData *)data
{
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:nil];
    //NSLog(@"%@", jsonObject);
	
	NSMutableDictionary *startTimes = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *endTimes = [[NSMutableDictionary alloc] init];
	
	for (id key in jsonObject[@"Rooster"][@"Hours"])
	{
		NSString *hour = key[@"Nr"];
		NSString *startTime = key[@"StartTime"];
		NSString *endTime = key[@"EndTime"];
		
		[startTimes setObject:startTime
					   forKey:hour];
		
		[endTimes setObject:endTime
					forKey:hour];
	}
    
    [self.courses removeAllObjects];
    
    for (id key in jsonObject[@"Rooster"][@"Timetable"])
	{
        NSString *hour = key[@"Hour"];
        if ([key[@"Text"] rangeOfString:@"DIF"].location == NSNotFound)
        {
            BTBCourse *course = [[BTBCourse alloc] initWithStartTime:[startTimes objectForKey:hour]
                                                                    :[endTimes objectForKey:hour]
                                                                    :key[@"Date"]
                                                                    :key[@"Text"]];
            
            [self.courses addObject:course];
        }
	}
		
	[self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Uncomment the following line to preserve selection between presentations.
	// self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view management

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
	
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
	NSDate *today = [[NSDate alloc] init];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	components = [calendar components:NSWeekdayCalendarUnit
							 fromDate:today];
	
	NSUInteger weekdayToday = [components weekday];
	NSInteger daysToMonday = (9 - weekdayToday) % 7;
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"EEEE dd MMM"];
	
	NSDateFormatter *apiFormat = [[NSDateFormatter alloc] init];
	[apiFormat setDateFormat:@"yyyyMMdd"];
	
	NSDate *sectionDate = [[NSDate alloc] init];
	
	[self currentWeek];
	
	if ([components weekday] == 1 || [components weekday] == 7)
	{
		switch (section)
		{
			case 0:
				sectionDate = [today dateByAddingTimeInterval:60 * 60 * 24 * (daysToMonday + section)];
				return [NSString stringWithFormat:@"%@", [formatter stringFromDate:sectionDate]];
				break;
				
			case 1:
				sectionDate = [today dateByAddingTimeInterval:60 * 60 * 24 * (daysToMonday + section)];
				return [NSString stringWithFormat:@"%@", [formatter stringFromDate:sectionDate]];
				break;
				
			case 2:
				sectionDate = [today dateByAddingTimeInterval:60 * 60 * 24 * (daysToMonday + section)];
				return [NSString stringWithFormat:@"%@", [formatter stringFromDate:sectionDate]];
				break;
				
			case 3:
				sectionDate = [today dateByAddingTimeInterval:60 * 60 * 24 * (daysToMonday + section)];
				return [NSString stringWithFormat:@"%@", [formatter stringFromDate:sectionDate]];
				break;
				
			case 4:
				sectionDate = [today dateByAddingTimeInterval:60 * 60 * 24 * (daysToMonday + section)];
				return [NSString stringWithFormat:@"%@", [formatter stringFromDate:sectionDate]];
				break;
				
			default:
				return @"Uknown date";
				break;
		}
	}
	else
	{
		switch (section)
		{
			case 0:
				sectionDate = [today dateByAddingTimeInterval:60 * 60 * 24 * -(daysToMonday + section)];
				return [NSString stringWithFormat:@"%@", [formatter stringFromDate:sectionDate]];
				break;
				
			case 1:
				sectionDate = [today dateByAddingTimeInterval:60 * 60 * 24 * -(daysToMonday + section)];
				return [NSString stringWithFormat:@"%@", [formatter stringFromDate:sectionDate]];
				break;
				
			case 2:
				sectionDate = [today dateByAddingTimeInterval:60 * 60 * 24 * -(daysToMonday + section)];
				return [NSString stringWithFormat:@"%@", [formatter stringFromDate:sectionDate]];
				break;
				
			case 3:
				sectionDate = [today dateByAddingTimeInterval:60 * 60 * 24 * -(daysToMonday + section)];
				return [NSString stringWithFormat:@"%@", [formatter stringFromDate:sectionDate]];
				break;
				
			case 4:
				sectionDate = [today dateByAddingTimeInterval:60 * 60 * 24 * -(daysToMonday + section)];
				return [NSString stringWithFormat:@"%@", [formatter stringFromDate:sectionDate]];
				break;
				
			default:
				return @"Uknown date";
				break;
		}
	}
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	if ([self.courses count] > 0)
	{
		self.foundSubjects = YES;
		return [self.courses count];
	}
	else
	{
		self.foundSubjects = NO;
		return 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!self.foundSubjects)
	{
		BTBSubjectTableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"NoSubjectCell"
																			 forIndexPath:indexPath];
		
		emptyCell.noSubjectLabel.text = @"No subject found.";
		
		return emptyCell;
	}
	
	BTBSubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell"
																	forIndexPath:indexPath];
    
	BTBCourse *course = [self.courses objectAtIndex:[indexPath row]];
	
	// Configure the cell...
	cell.startTimeLabel.text = [course startTime];
	cell.endTimeLabel.text = [course endTime];
    
    cell.subjectLabel.text = [course subjectName];
    cell.locationTeacherLabel.text = [NSString stringWithFormat:@"%@ %@", [course location], [course teacherName]];    
	
    return cell;
}

+ (NSString *)base64String:(NSString *)str
{
    NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i = 0; i < length; i += 3)
	{
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++)
		{
            value <<= 8;
            
            if (j < length)
			{
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data
								 encoding:NSASCIIStringEncoding];
}

#pragma mark - Dynamic Type

- (void)updateTableForDynamicType
{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary)
    {
        cellHeightDictionary = @{UIContentSizeCategoryExtraSmall: @44,
                                 UIContentSizeCategorySmall: @44,
                                 UIContentSizeCategoryMedium: @44,
                                 UIContentSizeCategoryLarge: @44,
                                 UIContentSizeCategoryExtraLarge: @50,
                                 UIContentSizeCategoryExtraExtraLarge: @50,
                                 UIContentSizeCategoryExtraExtraExtraLarge: @50};
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue
				 sender:(id)sender
{
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
    NSLog(@"Logging out...");
}

@end
