//
//  JourneyController.m
//  newPocket
//
//  Created by 杜長城 on 8/31/14.
//  Copyright (c) 2014 杜長城. All rights reserved.
//

#import "JourneyController.h"

@interface JourneyController ()

@end

@implementation JourneyController

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
    NSNumber *traveling = [receiveJourney objectForKey:@"onGoing"];
    NSInteger travelingCheck = [traveling integerValue];
    
    NSNumber *yes = [NSNumber numberWithInteger:1];
    NSInteger yesCheck = [yes integerValue];

    
    if (travelingCheck==yesCheck) {
        NSLog(@"this journey is on going, redirect to record tab");
        [self setSelectedIndex: 0];
    } else{
        NSLog(@"this journey is not on going, redirect to timeline tab");
        [self setSelectedIndex: 1];
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setJourneyState:(NSMutableDictionary *)state {
    
    receiveJourney = state;
    
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
