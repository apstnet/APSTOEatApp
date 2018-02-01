//
//  QrScanController.m
//  OEatApp
//
//  Created by apstnetmgr on 14/12/8.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import "QrScanController.h"
#import <AVFoundation/AVFoundation.h>
#import "SupeDetailController.h"
#import "RestaurantDetailController.h"
#import "ProdDetailController.h"
#import "AccountManager.h"
#import "ScanOverlayView.h"

//QRcode, Restaurant: OEat-Rest-REST_xxxx, Supermarket: OEat-Supe-SM_xxxx, Product: OEat-Prod-PROD_xxxx
NSString *const QRcode_Rest_Prefix = @"OEat-Rest-";
NSString *const QRcode_Supe_Prefix = @"OEat-Supe-";
NSString *const QRcode_Prod_Prefix = @"OEat-Prod-";

@interface QrScanController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    NSMutableString *qrcode;
    NSInteger qrType; //1-Rest, 2-Supe, 3-Prod
}
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIView *previewView;

@property (weak, nonatomic) IBOutlet UILabel *retLbl;

- (void)dispQRCodeCapture;

@end

@implementation QrScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *_titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 28)];
    [_titleLbl setText:@"QR Scan"];
    [_titleLbl setTextColor:[UIColor whiteColor]];
    _titleLbl.font = [UIFont fontWithName:@"HelveticaNeue Bold" size:20];
    _titleLbl.backgroundColor = [UIColor clearColor];
    [_titleLbl sizeToFit];
    self.navigationItem.titleView = _titleLbl;
    
//    [self setTitle:@"QR Scan"];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(tapReaderCloseButton:)];
    self.navigationItem.rightBarButtonItem = closeButton;
    qrcode = [NSMutableString string];
    
    qrType = 0;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self applyBarTintColorToTheNavigationBar];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dispQRCodeCapture];
    });
}

- (void)applyBarTintColorToTheNavigationBar
{
    UIColor *barTintColor = [UIColor colorWithHexString:@"#68bf60"];
    
    id navigationBarAppearance = self.navigationController.navigationBar;
    
    [navigationBarAppearance setBarTintColor:barTintColor];
    
}

- (void)showReqInfor:(NSString*)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
}

#pragma mark - QR Code Reader
- (IBAction)tapReaderCloseButton:(id)sender {
    // Close preview view.
    [self.previewView removeFromSuperview];
    self.previewView = nil;

    self.session = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dispQRCodeCapture {
    
    
    // Capture session init
    self.session = AVCaptureSession.new;
    
    AVCaptureDevice *backCameraDevice;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionBack) {
            backCameraDevice = device;
            break;
        }
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCameraDevice
                                                                        error:&error];
    [self.session addInput:input];
    
    AVCaptureMetadataOutput *output = AVCaptureMetadataOutput.new;
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:output];
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    [self.session startRunning];
    
    self.previewView = [[UIView alloc] initWithFrame:self.view.frame];
    self.previewView.backgroundColor = [UIColor clearColor];
    
    AVCaptureVideoPreviewLayer *avCapturePreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    avCapturePreviewLayer.frame = self.view.bounds;
    avCapturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.view addSubview:self.previewView];
    
    [self.previewView.layer addSublayer:avCapturePreviewLayer];
    
    ScanOverlayView *_overlayView = [[ScanOverlayView alloc] initWithFrame:self.previewView.frame];
    [_overlayView setBackgroundColor:[UIColor clearColor]];
    [self.previewView addSubview:_overlayView];
}

#pragma mark - <AVCaptureMetadataOutputObjectsDelegate>

- (void) captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
        fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString *_strtmp = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            if (_strtmp) {
                [qrcode setString:_strtmp];
                NSMutableString *_qrStrTmp = [NSMutableString stringWithFormat:@"Scan: %@",qrcode];
                [self showReqInfor:_qrStrTmp];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self checkScanType:qrcode];
                });
            }
            [self.previewView removeFromSuperview];
            self.previewView = nil;
            self.session = nil;
            
            
            break;
        }
    }
}

- (void)checkScanType:(NSString*)Qrcode
{
    int _len = (int)[QRcode_Rest_Prefix length];
    NSString *_preStr;
    NSString *_lastStr;
    
    if ([Qrcode length] < _len+2) {
        return;
    }else{
        _preStr = [Qrcode substringToIndex:_len];
        _lastStr = [Qrcode substringFromIndex:_len];
    }
    
    if ([_preStr isEqualToString:QRcode_Rest_Prefix]) {
        qrType= 1;
        [self showRestDetailVC:_lastStr restname:@""];
    }
    
    if ([_preStr isEqualToString:QRcode_Supe_Prefix]) {
        qrType = 2;
        [self showSupeDetailVC:_lastStr];
    }
    
    if ([_preStr isEqualToString:QRcode_Prod_Prefix]) {
        qrType = 3;
        [self showProdDetailVC:_lastStr];
    }
}

- (void)showRestDetailVC:(NSString*)restId restname:(NSString*)restName
{
    UIStoryboard *_theStoryboard = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
    RestaurantDetailController *_controller = (RestaurantDetailController*)[_theStoryboard instantiateViewControllerWithIdentifier:@"RestaurantDetailController"];
    if (!_controller.restId) {
        _controller.restId = [NSMutableString string];
    }
    [_controller.restId setString:restId];
    
    if (!_controller.restName) {
        _controller.restName = [NSMutableString string];
    }
    [_controller.restName setString:@""];
    
    [self.navigationController pushViewController:_controller animated:YES];
}

- (void)showSupeDetailVC:(NSString*)smId
{
    UIStoryboard *_theStoryboard = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
    SupeDetailController *_controller = (SupeDetailController*)[_theStoryboard instantiateViewControllerWithIdentifier:@"SupeDetailController"];
    if (!_controller.smId) {
        _controller.smId = [NSMutableString string];
    }
    [_controller.smId setString:smId];
    
    if (!_controller.smName) {
        _controller.smName = [NSMutableString string];
    }
    [_controller.smName setString:@""];
    
    [self.navigationController pushViewController:_controller animated:YES];
}

- (void)showProdDetailVC:(NSString*)prodId
{
    UIStoryboard *_theStoryboard = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
    ProdDetailController *_controller = (ProdDetailController*)[_theStoryboard instantiateViewControllerWithIdentifier:@"ProdDetailController"];
    
    if (!_controller.prodId) {
        _controller.prodId = [NSMutableString string];
    }
    [_controller.prodId setString:prodId];
    
    if (!_controller.prodName) {
        _controller.prodName = [NSMutableString string];
    }
    [_controller.prodName setString:@""];
    
    [self.navigationController pushViewController:_controller animated:YES];
}

@end
