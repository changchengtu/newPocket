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
    //media.contentMode = UIViewContentModeScaleToFill;
    
    // show thumbnail
    NSData *thumbnailData = [NSData dataWithContentsOfFile:[[mediaList objectAtIndex:indexPath.row] objectForKey:@"thumbnail_path"]];
    media.image = [UIImage imageWithData:thumbnailData];
    
    
    // show original picture
    /*
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    //NSURL *url = [NSURL URLWithString:@"assets-library://asset/asset.JPG?id=FF014D89-29E6-42A4-AC78-07E6A9DD0793&ext=JPG"];
    NSURL *url;
    
    ALAsset *assetURL=[NSURL URLWithString:[[mediaList objectAtIndex:indexPath.row] objectForKey:@"thumbnail_path"]];
    
    [library assetForURL:assetURL resultBlock:^(ALAsset *asset )
     {
         NSLog(@"Timelinecontroller: ALAsset located!");
         ALAssetRepresentation *rep = [asset defaultRepresentation];
         CGImageRef iref = [rep fullResolutionImage];
         if (iref) {
             UIImage *original = [UIImage imageWithCGImage:iref]; //the image should be compress or memroy warning
             UIImage *small = [UIImage imageWithCGImage:original.CGImage scale:0.01 orientation:original.imageOrientation];
             media.image = small;
         }
     } failureBlock:^(NSError *error )
     {
         NSLog(@"Error loading asset");
     }];
    */
    
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
    NSLog(@"TimelineController: viewDidLoad");
    
    //initial a notification for reload tableview function
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ReloadMediaFunction:)
                                                 name:@"refreshMedia"
                                               object:nil];
    
    [self loadMediaFromDB];
    
    /*
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
    */
    
}

-(void)ReloadMediaFunction:(NSNotification *)notification {
    
    [self loadMediaFromDB];
    
    NSLog(@"RecordController: reload");
    // 用迴圈取得位於ViewController上的每一個UIView類別
    for (UIView *view in self.view.subviews) {
        // 判斷取得的view是否屬於UITableView類別
        if ([view isKindOfClass:[UITableView class]]) {
            // 如果是就強制轉型為UITableView
            UITableView *tableView = (UITableView *)view;
            // 要求重新載入資料
            [tableView reloadData];
            break;
        }
    }
    
}

- (void)loadMediaFromDB
{
    
    mediaList = [[NSMutableArray alloc] init];
    // 取得已開啓的資料庫連線變數
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sqlite3 *db = [delegate getDB];
    
    if (db != nil) {
        // 準備好查詢的SQL command
        NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM medias"];
        const char *sql = [queryString UTF8String];
        
        sqlite3_stmt *statement;
        // 執行
        sqlite3_prepare(db, sql, -1, &statement, NULL);
        // statement用來儲存執行結果
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char *time = (char *)sqlite3_column_text(statement, 3);
            char *location = (char *)sqlite3_column_text(statement, 4);
            char *thumbnail_path = (char *)sqlite3_column_text(statement, 6);
            
            NSMutableDictionary *mediaInfo = [[NSMutableDictionary alloc] init];
            [mediaInfo setObject:[NSString stringWithFormat:@"%s", thumbnail_path, nil] forKey:@"thumbnail_path"];
            [mediaInfo setObject:[NSString stringWithFormat:@"%s", time, nil] forKey:@"title"];
            [mediaList addObject:mediaInfo];
            
        }
        
        sqlite3_finalize(statement);
    }

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
