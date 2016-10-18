//
//  ViewController.m
//  QingHuaTestDemo
//
//  Created by 遇见远洋 on 16/10/12.
//  Copyright © 2016年 遇见远洋. All rights reserved.
//

#import "ViewController.h"
#import "PLMediaStreamingKit.h"
#import "PLPlayerKit.h"

@interface ViewController ()<PLMediaStreamingSessionDelegate, PLPlayerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) PLMediaStreamingSession *session;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIButton *conferenceButton;
@property (nonatomic, strong) NSString *    userID;
@property (nonatomic, strong) NSString *    roomToken;
@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, assign) NSUInteger viewSpaceMask;
@property (nonatomic, strong) NSMutableDictionary *userViewDictionary;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userViewDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];

    [self setupUI];
    [self initStreamingSession];
}

- (void)setupUI {
    self.roomName = @"testroom";

    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    
    //推流按钮
    self.actionButton = [[UIButton alloc] initWithFrame:CGRectMake(20, size.height - 66 - 20, 66, 66)];
    [self.actionButton setTitle:@"推流" forState:UIControlStateNormal];
    [self.actionButton setTitle:@"暂停" forState:UIControlStateSelected];
    [self.actionButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.actionButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.actionButton];
    
    
    //连麦按钮
    self.conferenceButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 66 - 20, size.height - 66 - 20, 66, 66)];
    [self.conferenceButton setTitle:@"连麦" forState:UIControlStateNormal];
    [self.conferenceButton setTitle:@"停止" forState:UIControlStateSelected];
    [self.conferenceButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.conferenceButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.conferenceButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [self.conferenceButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.conferenceButton addTarget:self action:@selector(conferenceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.conferenceButton];
}



- (void)initStreamingSession
{
    self.session = [[PLMediaStreamingSession alloc]
                    initWithVideoCaptureConfiguration:[PLVideoCaptureConfiguration defaultConfiguration]
                    audioCaptureConfiguration:[PLAudioCaptureConfiguration defaultConfiguration] videoStreamingConfiguration:[PLVideoStreamingConfiguration defaultConfiguration] audioStreamingConfiguration:[PLAudioStreamingConfiguration defaultConfiguration] stream:nil];
    self.session.delegate = self;
    self.session.previewView.frame = self.view.bounds;
    [self.view insertSubview:self.session.previewView atIndex:0];
    NSDictionary *dict =  @{
                            @"createdAt": @"2016-10-10T17:56:55.219+08:00",
                            @"updatedAt": @"2016-10-10T17:56:55.219+08:00",
                            @"expireAt": @"2016-10-26T17:56:55.219+08:00",
                            @"title": @"57fb65e71013853bf005ddcc",
                            @"hub": @"guoyi-test1",
                            @"disabledTill": @0,
                            @"disabled": @(false),
                            @"publishKey": @"81a8a0d16efbf777",
                            @"publishSecurity": @"dynamic",
                            @"hosts": @{
                                    @"publish": @{
                                            @"rtmp": @"pili-publish.www.chemucao.cn"
                                            },
                                    @"live": @{
                                            @"hdl": @"pili-live-hdl.www.chemucao.cn",
                                            @"hls": @"pili-live-hls.www.chemucao.cn",
                                            @"http": @"pili-live-hls.www.chemucao.cn",
                                            @"rtmp": @"pili-live-rtmp.www.chemucao.cn",
                                            @"snapshot": @"pili-live-snapshot.www.chemucao.cn"
                                            },
                                    @"playback": @{
                                            @"hls": @"10004g4.playback1.z1.pili.qiniucdn.com",
                                            @"http": @"10004g4.playback1.z1.pili.qiniucdn.com"
                                            },
                                    @"play": @{
                                            @"http": @"pili-live-hls.www.chemucao.cn",
                                            @"rtmp": @"pili-live-rtmp.www.chemucao.cn"
                                            }
                                    }
                            };
    self.session.stream = [PLStream streamWithJSON:dict];
    
    //连麦的观众ID
    self.userID = @"50";
//    self.roomToken = @"QzdCUKE0lXmIJsvJ_yQJTeIsJYeK6liEdWAn9JuU:5038HiYCDx8OVRn6KDCU38IZjgs=:eyJyb29tX25hbWUiOiJ0ZXN0cm9vbSIsInVzZXJfaWQiOiJ1c2VyMDEiLCJwZXJtIjoiYWRtaW4iLCJleHBpcmVfYXQiOjE3ODU2MDAwMDAwMDB9";
    
    self.roomToken = @"QzdCUKE0lXmIJsvJ_yQJTeIsJYeK6liEdWAn9JuU:-NfG25JDfa0LwGTqoH6gv39Dm1A=:eyJyb29tX25hbWUiOiJ0ZXN0cm9vbSIsInVzZXJfaWQiOiI1MCIsInBlcm0iOiJ1c2VyIiwiZXhwaXJlX2F0IjoxNzg1NjAwMDAwMDAwfQ==";
}



#pragma mark- XXXXXXXXXXXXXXX推流的点击事件XXXXXXXXXXXXXXXXXXXX
- (void)actionButtonClick:(id)sender
{
    if (self.session.streamState == PLStreamStateConnected) {
        [self.session stopStreaming];
    } else {
        self.actionButton.enabled = NO;
        
//        [self.session startStreamingWithFeedback:^(PLStreamStartStateFeedback feedback) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.actionButton.enabled = YES;
//                if (feedback == PLStreamStartStateSuccess) {
//                    NSLog(@"推流成功");
//                }else {
//                    
//                    NSLog(@"推流失败 %ld",feedback);
//                }
//            });
//        }];
        
        
#warning NeedToDo 填入七牛的推流地址
        [self.session startStreamingWithPushURL:[NSURL URLWithString:@"这里填入七牛的推流地址"]feedback:^(PLStreamStartStateFeedback feedback) {
            
        }];
        
    }
}


#pragma mark- XXXXXXXXXXXXXXX连麦的点击事件XXXXXXXXXXXXXXXXXXXX
- (void)conferenceButtonClick:(id)sender
{
    self.conferenceButton.enabled = NO;
    
    if (!self.conferenceButton.selected) {
        PLRTCConfiguration *configuration = [PLRTCConfiguration defaultConfiguration];
        [self.session startConferenceWithRoomName:self.roomName userID:self.userID roomToken:self.roomToken rtcConfiguration:configuration];
        NSDictionary *option = @{kPLRTCRejoinTimesKey:@(2), kPLRTCConnetTimeoutKey:@(3000)};
        self.session.rtcOption = option;
        self.session.rtcMinVideoBitrate= 100 * 1000;
        self.session.rtcMaxVideoBitrate= 300 * 1000;
        self.session.rtcMixOverlayRectArray = [NSArray arrayWithObjects:[NSValue valueWithCGRect:CGRectMake(330, 480, 90, 160)], [NSValue valueWithCGRect:CGRectMake(330, 320, 90, 160)], nil];
    }
    else {
        [self.session stopConference];
    }
    return;
}



- (void)kickoutButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    UIView *view = button.superview;
    for (NSString *userID in self.userViewDictionary.allKeys) {
        if ([self.userViewDictionary objectForKey:userID] == view) {
            [self.session kickoutUserID:userID];
            break;
        }
    }
}


- (void)showAlertWithMessage:(NSString *)message completion:(void (^)(void))completion
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark - 推流回调

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session streamStateDidChange:(PLStreamState)state {
    if (PLStreamStateConnected == state) {
        self.actionButton.selected = YES;
    }
    else {
        self.actionButton.selected = NO;
    }
    self.actionButton.enabled = YES;
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didDisconnectWithError:(NSError *)error {
    NSLog(@"error: %@", error);
    self.actionButton.enabled = YES;
    self.actionButton.selected = NO;
    [self showAlertWithMessage:[NSString stringWithFormat:@"Error code: %ld, %@", (long)error.code, error.localizedDescription] completion:nil];
}



#pragma mark - 连麦回调

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session rtcStateDidChange:(PLRTCState)state {
    
    if (state == PLRTCStateConferenceStarted) {
        self.conferenceButton.selected = YES;
    } else {
        self.conferenceButton.selected = NO;
    }
    self.conferenceButton.enabled = YES;
}



/// @abstract 因产生了某个 error 的回调
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session rtcDidFailWithError:(NSError *)error {
    NSLog(@"error: %@", error);
    self.conferenceButton.enabled = YES;
    [self showAlertWithMessage:[NSString stringWithFormat:@"Error code: %ld, %@", (long)error.code, error.localizedDescription] completion:^{
    }];
}



- (void)mediaStreamingSession:(PLMediaStreamingSession *)session userID:(NSString *)userID didAttachRemoteView:(UIView *)remoteView {
    NSInteger space = 0;
    if (!(self.viewSpaceMask & 0x01)) {
        self.viewSpaceMask |= 0x01;
        space = 1;
    }
    else if (!(self.viewSpaceMask & 0x02)) {
        self.viewSpaceMask |= 0x02;
        space = 2;
    }
    else {
        //超出 3 个连麦观众，不再显示。
        return;
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat width = screenSize.width / 4;
    CGFloat height = screenSize.height / 4;
    remoteView.frame = CGRectMake(screenSize.width - width, screenSize.height - height * space, width, height);
    remoteView.clipsToBounds = YES;
    [self.view addSubview:remoteView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width - 40, 0, 40, 40)];
    [button setTitle:@"踢出" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button addTarget:self action:@selector(kickoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [remoteView addSubview:button];
    
    [self.userViewDictionary setObject:remoteView forKey:userID];
    [self.view bringSubviewToFront:self.conferenceButton];
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session userID:(NSString *)userID didDetachRemoteView:(UIView *)remoteView {
    [remoteView removeFromSuperview];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat height = screenSize.height / 4;
    if (self.view.frame.size.height - remoteView.center.y < height) {
        self.viewSpaceMask &= 0xFE;
    }
    else {
        self.viewSpaceMask &= 0xFD;
    }
    
    [self.userViewDictionary removeObjectForKey:userID];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
