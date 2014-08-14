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
			
			[self fetchData];
        }
    
    return self;
}

- (void)fetchData
{
	// Prepare request
    NSString *loginString = [NSString stringWithFormat:@"%@:%@", @"306880@student.fontys.nl", @"BxF-LZJ-D6s-erH"];
    NSString *encodedLoginData = [BTBCourseTableViewController base64String:loginString];
    NSString *base64LoginData = [NSString stringWithFormat:@"Basic %@",encodedLoginData];
    
    NSURL *url= [NSURL URLWithString:@"https://secapi.fontys.nl/json.ashx?app=f4IcdWfO7U2UcjGpIPjMGA&rooster_institute=FHI&rooster_class=s32&rooster_week=20140901"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:base64LoginData forHTTPHeaderField:@"Authorization"];
    
    NSURLConnection *urlConnection;
    urlConnection = [[NSURLConnection alloc] initWithRequest:request
                                                    delegate:self];
}


NSMutableData *urlData;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    urlData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [urlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *json = [[NSString alloc] initWithData:urlData
                                           encoding:NSUTF8StringEncoding];
    [self finished:json data:urlData];
}

- (void) finished:(NSString *)json data:(NSData *)data
{
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:nil];
    //NSLog(@"%@", jsonObject);
	
	NSMutableDictionary *startTimes = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *endTimes = [[NSMutableDictionary alloc] init];
	
	//[startTimes setObject:@"08:45" forKey:@"1"];
	//NSLog(@"%@", [startTimes valueForKey:@"1"]);
	
	
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
    
    for (id key in jsonObject[@"Rooster"][@"Timetable"])
	{
		BTBCourse *course = [[BTBCourse alloc] init];
		// Set begin/end hour here
		NSString *hour = key[@"Hour"];
		[course setStartTime:[startTimes objectForKey:hour]];
		[course setEndTime:[endTimes objectForKey:hour]];
		[course setDate:key[@"Date"]];
		[course setText:key[@"Text"]];
		
		[self.courses addObject:course];
	}
		
	[self.tableView reloadData];
}

- (IBAction)logout:(id)sender
{
	// Get rid of all things here...
    NSLog(@"Logging out...");
    
    
    [self performSegueWithIdentifier:@"logoutSegue"
                              sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Uncomment the following line to preserve selection between presentations.
	// self.clearsSelectionOnViewWillAppear = NO;
    
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Table view data source

- (IBAction)refresh:(UIRefreshControl *)sender
{
	// Refreshing...
    NSLog(@"Refreshing...");
	[self fetchData];
	
    [sender endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTBSubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell" forIndexPath:indexPath];
    
	BTBCourse *course = [self.courses objectAtIndex:[indexPath row]];
	
	// Configure the cell...
	cell.startTimeLabel.text = [course startTime];
	cell.endTimeLabel.text = [course endTime];
	cell.subjectLabel.text = [course text];
	
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


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    NSLog(@"Logging out...");
}

@end
