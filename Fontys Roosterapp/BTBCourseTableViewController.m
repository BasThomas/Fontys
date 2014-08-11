//
//  BTBSubjectTableViewController.m
//  Fontys Roosterapp
//
//  Created by Arnold Broek on 10/08/14.
//  Copyright (c) 2014 Bas Broek. All rights reserved.
//

#import "BTBCourseTableViewController.h"
#import "BTBSubjectTableViewCell.h"

@interface BTBCourseTableViewController () <NSURLSessionDataDelegate>

@property (nonatomic) NSURLSession *session;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

@end

@implementation BTBCourseTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:self
                                            delegateQueue:nil];
        [self fetchData];
    }
    
    return self;
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    // Use login to fill username and password here.
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"306880@student.fontys.nl"
                                                             password:@"BxF-LZJ-D6s-erH"
                                                          persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

- (void)fetchData
{
    NSString *requestString = @"https://secapi.fontys.nl/json.ashx?app=f4IcdWfO7U2UcjGpIPjMGA&rooster_institute=FTHV&rooster_class=TEI7&rooster_week=20121119";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionTask *dataTask = [self.session dataTaskWithRequest:request
                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      //NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                      //                                                     options:0
                                      //                                                       error:&error];
                                      NSString *json = [[NSString alloc] initWithData:data
                                                                             encoding:NSUTF8StringEncoding];
                                      
                                      if (json)
                                      {
                                          //NSLog(@"JSON: %@", json);
                                      }
                                      else
                                      {
                                          //NSLog(@"%@", [error localizedDescription]);
                                      }
                                  }];
    [dataTask resume];
}

- (IBAction)logout:(id)sender
{
    // Get rid of all things here...
    NSLog(@"Logging out...");
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
