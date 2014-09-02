//
//  TimelineController.m
//  newPocket
//
//  Created by 杜長城 on 9/1/14.
//  Copyright (c) 2014 杜長城. All rights reserved.
//

#import "TimelineController.h"

@interface TimelineController ()

@end

@implementation TimelineController
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mediaList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indicator = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indicator];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indicator];
    }
    //cell.textLabel.text = @"picture";
    
    // show title about the media
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 320, 20)];
    titleLabel.text = [[mediaList objectAtIndex:indexPath.row] objectForKey:@"title"];
    [cell.contentView addSubview:titleLabel];

    // show media, each cell has its own media
    UIImageView *media = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 320, 180)];
    media.contentMode = UIViewContentModeScaleToFill;
    media.image = [UIImage imageNamed:[[mediaList objectAtIndex:indexPath.row] objectForKey:@"path"]];
    [cell.contentView addSubview:media];
    
    
    return cell;
}

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
    // Do any additional setup after loading the view.
    
    mediaList = [[NSMutableArray alloc] init];
    
    
    // please load camera here
    // init 4 medias and save to mediaList for later presenting in cell
    NSMutableDictionary *mediaInfo1 = [[NSMutableDictionary alloc] init];
    [mediaInfo1 setObject:@"sample1.jpg" forKey:@"path"];
    [mediaInfo1 setObject:@"3/23 7pm at Taoyuan Taiwan" forKey:@"title"];
    [mediaList addObject:mediaInfo1];
    
    NSMutableDictionary *mediaInfo2 = [[NSMutableDictionary alloc] init];
    [mediaInfo2 setObject:@"sample2.jpg" forKey:@"path"];
    [mediaInfo2 setObject:@"3/23 10pm at Hsinchu Taiwan" forKey:@"title"];
    [mediaList addObject:mediaInfo2];
    
    NSMutableDictionary *mediaInfo3 = [[NSMutableDictionary alloc] init];
    [mediaInfo3 setObject:@"sample3.jpg" forKey:@"path"];
    [mediaInfo3 setObject:@"3/24 8am at Hsinchu Taiwan" forKey:@"title"];
    [mediaList addObject:mediaInfo3];
    
    NSMutableDictionary *mediaInfo4 = [[NSMutableDictionary alloc] init];
    [mediaInfo4 setObject:@"sample4.jpg" forKey:@"path"];
    [mediaInfo4 setObject:@"3/24 1pm at Taiper Taiwan" forKey:@"title"];
    [mediaList addObject:mediaInfo4];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
