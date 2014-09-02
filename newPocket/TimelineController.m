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
    titleLabel.text = @"3/23 7pm at Taoyuan Taiwan";
    [cell.contentView addSubview:titleLabel];

    // show media, each cell has its own media
    UIImageView *media = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 320, 180)];
    media.contentMode = UIViewContentModeScaleToFill;
    media.image = [UIImage imageNamed:@"sample.jpg"];
    [cell.contentView addSubview:media];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    [mediaList addObject:@"pic0"];
    [mediaList addObject:@"pic1"];
    [mediaList addObject:@"pic2"];
    [mediaList addObject:@"pic3"];
    

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
