//
//  PocketController.m
//  newPocket
//
//  Created by 杜長城 on 8/31/14.
//  Copyright (c) 2014 杜長城. All rights reserved.
//

#import "PocketController.h"
#import "JourneyController.h"

@interface PocketController ()

@end

@implementation PocketController
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    journeyList = [[NSMutableArray alloc] init]; //List all journey on Pocket page
    
    // 取得已開啓的資料庫連線變數
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sqlite3 *db = [delegate getDB];
    
    if (db != nil) {
        // 準備好查詢的SQL command
        const char *sql = "SELECT * FROM journey";
        // statement用來儲存執行結果
        sqlite3_stmt *statement;
        sqlite3_prepare(db, sql, -1, &statement, NULL);
        
        // 利用迴圈取出查詢NSMutableDictionary *mutableDict = [dictionary mutableCopy];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *iid = (char *)sqlite3_column_text(statement, 0);
            char *name = (char *)sqlite3_column_text(statement, 1);
            char *country = (char *)sqlite3_column_text(statement, 2);
            char *city = (char *)sqlite3_column_text(statement, 3);
            char *start = (char *)sqlite3_column_text(statement, 4);
            char *end = (char *)sqlite3_column_text(statement, 5);
            char *description = (char *)sqlite3_column_text(statement, 6);
            char *profilepic = (char *)sqlite3_column_text(statement, 7);
            char *traveling = (char *)sqlite3_column_text(statement, 8);
            
            
            journeyInfoDict = [[NSMutableDictionary alloc] init];
            [journeyInfoDict setObject:[NSString stringWithFormat:@"%s", iid, nil] forKey:@"iid"];
            [journeyInfoDict setObject:[NSString stringWithFormat:@"%s", name, nil] forKey:@"name"];
            [journeyInfoDict setObject:[NSString stringWithFormat:@"%s", country, nil] forKey:@"country"];
            [journeyInfoDict setObject:[NSString stringWithFormat:@"%s", city, nil] forKey:@"city"];
            [journeyInfoDict setObject:[NSString stringWithFormat:@"%s", start, nil] forKey:@"start"];
            [journeyInfoDict setObject:[NSString stringWithFormat:@"%s", end, nil] forKey:@"end"];
            [journeyInfoDict setObject:[NSString stringWithFormat:@"%s", description, nil] forKey:@"description"];
            [journeyInfoDict setObject:[NSString stringWithFormat:@"%s", profilepic, nil] forKey:@"profilepic"];
            [journeyInfoDict setObject:[NSString stringWithFormat:@"%s", traveling, nil] forKey:@"traveling"];
            
            [journeyList addObject:journeyInfoDict];
            
            // NSLog([NSString stringWithFormat:@"%s", traveling, nil]);

        }
        
        sqlite3_finalize(statement);
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [journeyList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indicator = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indicator];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indicator];
    }
    NSLog(@"ready to load data to a cell");
    cell.textLabel.text = [[journeyList objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSLog(@"cell has loaded data");
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //to compare two value, we must transform the value into NSInteger first for condition of IF works normally
    NSNumber *traveling = [[journeyList objectAtIndex:indexPath.row] objectForKey:@"traveling"];
    NSInteger travelingCheck = [traveling integerValue];
    
    NSNumber *yes = [NSNumber numberWithInteger:1];
    NSInteger yesCheck = [yes integerValue];
    
    
    passJourney = [[NSMutableDictionary alloc] init];
    
    
    if (indexPath.row > -1)
	{
        NSLog(@"check the journeyState");
        // check if user is on journey
        if (travelingCheck==yesCheck) {
            NSString *state = @"1";
            //NSLog(@"yes");
            [passJourney setObject:state forKey:@"onGoing"];
        } else{
            //NSLog(@"no");
            NSString *state = @"0";
            [passJourney setObject:state forKey:@"onGoing"];
        }
    }
    [self performSegueWithIdentifier:@"showJourney" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue from deals screen");
    //addToCartViewContollerForItem
    if([[segue identifier] isEqualToString:@"showJourney"]){
        NSIndexPath *selectedRow = [[self tableView] indexPathForSelectedRow];
        
        
        JourneyController *vc = [segue destinationViewController];
        [vc setJourneyState:passJourney];
    }
    
    
}

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
