//
//  JourneyController.h
//  newPocket
//
//  Created by 杜長城 on 8/31/14.
//  Copyright (c) 2014 杜長城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JourneyController : UITabBarController
{
    NSMutableDictionary *receiveJourney;
}
- (void) setJourneyState:(NSMutableDictionary *)state;
@end
