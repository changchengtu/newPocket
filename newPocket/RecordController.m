//
//  RecordController.m
//  newPocket
//
//  Created by 杜長城 on 9/3/14.
//  Copyright (c) 2014 杜長城. All rights reserved.
//

#import "RecordController.h"

@interface RecordController ()

@end

@implementation RecordController
@synthesize startCameraButton;
@synthesize showMedia;
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
    self.showMedia.contentMode = UIViewContentModeScaleToFill;
}

- (IBAction)clickStartCameraButton:(id)sender {
    
    // 先檢查裝置是否配備相機
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        // 設定相片來源為裝置上的相機
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 設定imagePicker的delegate為ViewController
        imagePicker.delegate = self;
        // 開啟相機拍照界面
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    // Apple limited file authority http://stackoverflow.com/questions/3837115/display-image-from-url-retrieved-from-alasset-in-iphone
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    if( [picker sourceType] == UIImagePickerControllerSourceTypeCamera )
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
         {
             
             NSLog(@"IMAGE SAVED TO PHOTO ALBUM");
             [library assetForURL:assetURL resultBlock:^(ALAsset *asset )
              {
                  NSLog(@"RecordController: ALAsset located!");
                  NSLog(@"RecordController: path= %@", [asset valueForProperty:ALAssetPropertyAssetURL]);
                  
                  // 取得已開啓的資料庫連線變數
                  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                  sqlite3 *db = [delegate getDB];
                  
                  if (db != nil) {
                      // 準備好查詢的SQL command
                      NSString *queryString = [NSString stringWithFormat:@"insert into medias values(NULL, NULL, 'picture', '2014-01-01 10:00:00', 'Bali', '%@', NULL, 1)", [asset valueForProperty:ALAssetPropertyAssetURL]];
                      const char *sql = [queryString UTF8String];
                      
                      sqlite3_stmt *statement;
                      // 執行
                      sqlite3_prepare(db, sql, -1, &statement, NULL);
                      // statement用來儲存執行結果
                      
                      while (sqlite3_step(statement) == SQLITE_ROW) {
                      }
                      
                      // 檢查插入資料是否成功
                      if (sqlite3_step(statement) == SQLITE_DONE) {
                          NSLog(@"TimelineController: picture path save to database");
                      } else {
                          NSLog(@"TimelineController: picture saving failed");
                      }
                      
                      sqlite3_finalize(statement);
                  }
                  
                  
                  
                  ALAssetRepresentation *rep = [asset defaultRepresentation];
                  CGImageRef iref = [rep fullResolutionImage];
                  if (iref) {
                      UIImage *largeimage = [UIImage imageWithCGImage:iref];
                      self.showMedia.image = largeimage;
                  }
              }
              failureBlock:^(NSError *error )
              {
                  NSLog(@"Error loading asset");
              }];
         }];
    }

    //[library release];
    // 關閉拍照程式
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 當使用者按下取消按鈕後關閉拍照程式
    [self dismissViewControllerAnimated:YES completion:nil];
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
