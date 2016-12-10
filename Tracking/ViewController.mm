//
//  ViewController.mm
//  Tracking
//
//  Created by Eric Fang on 11/29/16.
//  Copyright © 2016 Yujie_Fang-Zeyi_Huang. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <opencv2/opencv.hpp>

#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/videoio/cap_ios.h>

#import "CMT.h"

#define RATIO  640.0/738.0

using namespace cv;
using namespace std;

@interface ViewController ()<CvVideoCameraDelegate>
{
    CGPoint rectLeftTopPoint;
    CGPoint rectRightDownPoint
    ;
    UIImageView *imageView_;
    UITextView *fpsView_; // Display the current FPS
    UITextView *fpsView_1;
    int64 curr_time_; // Store the current time
    
    double number;
    
    cv::Rect selectBox;
    cv::Rect initCTBox;
    cv::Rect box;
    bool beginInit;
    bool startTracking;
    
    // CMT Tracker
    cmt::CMT *cmtTracker;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) CvVideoCamera *videoCamera;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageView.frame = CGRectMake(0, 0, 738, 480 * 738/640.0);
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
     number =0;
    
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    self.videoCamera.defaultFPS = 30;
    [self.videoCamera start];
    
    float cam_width = 680; float cam_height = 740;
    
    int view_width = self.view.frame.size.width;
    int view_height = (int)(cam_height*self.view.frame.size.width/cam_width);
    int offset =0;
    [self.view addSubview:imageView_];
    fpsView_ = [[UITextView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    [fpsView_ setOpaque:false]; // Set to be Opaque
    [fpsView_ setBackgroundColor:[UIColor clearColor]]; // Set background color to be clear
    [fpsView_ setTextColor:[UIColor redColor]]; // Set text to be RED
    [fpsView_ setFont:[UIFont systemFontOfSize:18]]; // Set the Font size
    [self.view addSubview:fpsView_];
    
    fpsView_1 = [[UITextView alloc] initWithFrame:CGRectMake(0,40,100,100)];
    [fpsView_1 setOpaque:false]; // Set to be Opaque
    [fpsView_1 setBackgroundColor:[UIColor clearColor]]; // Set background color to be clear
    [fpsView_1 setTextColor:[UIColor redColor]]; // Set text to be RED
    [fpsView_1 setFont:[UIFont systemFontOfSize:18]]; // Set the Font size
    [self.view addSubview:fpsView_1];
    
    rectLeftTopPoint = CGPointZero;
    rectRightDownPoint = CGPointZero;
    
    beginInit = false;
    startTracking = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reset
{
    startTracking = false;
    beginInit = false;
    
    rectLeftTopPoint.x = 0;
    rectRightDownPoint.x = 0;
}

- (IBAction)CMT:(id)sender
{
    [self reset];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    startTracking = false;
    beginInit = false;
    UITouch *aTouch  = [touches anyObject];
    rectLeftTopPoint = [aTouch locationInView:self.imageView];
    
    NSLog(@"touch in :%f,%f",rectLeftTopPoint.x,rectLeftTopPoint.y);
    rectRightDownPoint = CGPointZero;
    selectBox = cv::Rect(rectLeftTopPoint.x * RATIO,rectLeftTopPoint.y * RATIO,0,0);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch  = [touches anyObject];
    rectRightDownPoint = [aTouch locationInView:self.imageView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch  = [touches anyObject];
    rectRightDownPoint = [aTouch locationInView:self.imageView];
    
    NSLog(@"touch end :%f,%f",rectRightDownPoint.x,rectRightDownPoint.y);
    selectBox.width = abs(rectRightDownPoint.x * RATIO - selectBox.x);
    selectBox.height = abs(rectRightDownPoint.y * RATIO - selectBox.y);
    beginInit = true;
    initCTBox = selectBox;
    
}

- (void)processImage:(cv::Mat &)image
{
    if (rectLeftTopPoint.x != 0 && rectLeftTopPoint.y != 0 && rectRightDownPoint.x != 0 && rectRightDownPoint.y != 0 && !beginInit && !startTracking) {
        
        rectangle(image, cv::Point(rectLeftTopPoint.x * RATIO,rectLeftTopPoint.y * RATIO), cv::Point(rectRightDownPoint.x * RATIO,rectRightDownPoint.y * RATIO), Scalar(255,0,0));
    }
    
    
    
    // Finally estimate the frames per second (FPS)
    int64 next_time = getTickCount(); // Get the next time stamp
    float fps = (float)getTickFrequency()/(next_time - curr_time_); // Estimate the fps
    curr_time_ = next_time; // Update the time
    NSString *fps_NSStr = [NSString stringWithFormat:@"FPS = %2.2f",fps];
    
    // Have to do this so as to communicate with the main thread
    // to update the text display
    dispatch_sync(dispatch_get_main_queue(), ^{
        fpsView_.text = fps_NSStr;
    });

    
     NSString *fps_NSStr1 = [NSString stringWithFormat:@"Points = %2.2f",number];
    dispatch_sync(dispatch_get_main_queue(), ^{
        fpsView_1.text = fps_NSStr1;
    });
    
    [self cmtTracking:image];
}

- (void)cmtTracking:(cv::Mat &)image
{
    Mat img_gray;
    cvtColor(image,img_gray,CV_RGB2GRAY);
    
    if (beginInit) {
        if (cmtTracker != NULL) {
            delete cmtTracker;
        }
        cmtTracker = new cmt::CMT();
        cmtTracker->initialize(img_gray,initCTBox);
        NSLog(@"cmt track init!");
        startTracking = true;
        beginInit = false;
    }
    
    if (startTracking) {
        NSLog(@"cmt process...");
        cmtTracker->processFrame(img_gray);
        
        for(size_t i = 0; i < cmtTracker->points_active.size(); i++)
        {
            number = cmtTracker->points_active.size();
            circle(image, cmtTracker->points_active[i], 2, Scalar(0,0,255));
        }
        
        
        RotatedRect rect = cmtTracker->bb_rot;
        Point2f vertices[4];
        rect.points(vertices);
        for (int i = 0; i < 4; i++)
        {
            line(image, vertices[i], vertices[(i+1)%4], Scalar(255,0,0));
        }
    }
}

@end
