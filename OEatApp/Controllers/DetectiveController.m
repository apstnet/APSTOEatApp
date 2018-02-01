//
//  DetectiveController.m
//  OEatApp
//
//  Created by apstnetmgr on 15/2/17.
//  Copyright (c) 2015年 APST. All rights reserved.
//

#import "DetectiveController.h"
#import "AccountManager.h"

#define TXTFIELD_OFFSET  60.0f

@interface DetectiveController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    BOOL bGood;
    
    NSMutableString *photoFileUrl;
    
    UIActionSheet *updatePhotoSheet;
    UIActionSheet *takePhotoSheet;
    
    UIImage *photoImg;
    
    MBProgressHUD *HUD;
}

@property (nonatomic) UITextField *activeField;
@property (nonatomic) UIToolbar *keyboardToolbar;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *goodTagBtn;
@property (weak, nonatomic) IBOutlet UIButton *badTagBtn;
@property (weak, nonatomic) IBOutlet UIImageView *searchImv;

@property (weak, nonatomic) IBOutlet UILabel *titleOneLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleTwoLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleThreeLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleFourLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleFiveLbl;

@property (weak, nonatomic) IBOutlet UITextField *txtfieldOne;
@property (weak, nonatomic) IBOutlet UITextField *txtfieldTwo;
@property (weak, nonatomic) IBOutlet UITextField *txtfieldThree;
@property (weak, nonatomic) IBOutlet UITextField *txtfieldFour;
@property (weak, nonatomic) IBOutlet UILabel *photoUrlLbl;


@property (weak, nonatomic) IBOutlet UIView *textContainerOne;
@property (weak, nonatomic) IBOutlet UIView *textContainerTwo;
@property (weak, nonatomic) IBOutlet UIView *textContainerThree;
@property (weak, nonatomic) IBOutlet UIView *textContainerFour;
@property (weak, nonatomic) IBOutlet UIView *textContainerFive;

@property (weak, nonatomic) IBOutlet UIButton *feedbackBtn;
- (IBAction)feedbackAct:(id)sender;
- (IBAction)takePhotoAct:(id)sender;
- (IBAction)goodTagAct:(id)sender;
- (IBAction)badTagAct:(id)sender;

- (IBAction)closeWinAct:(id)sender;
@end

@implementation DetectiveController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        // To indicate to the system that we have a custom presentation controller, use UIModalPresentationCustom as our modalPresentationStyle
        [self setModalPresentationStyle:UIModalPresentationCustom];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bGood = NO;
    if (!photoFileUrl) {
        photoFileUrl = [NSMutableString string];
    }
    
    [self configClientView];
    
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle: @"Close" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem, doneBarItem, nil]];
        _txtfieldOne.inputAccessoryView = self.keyboardToolbar;
        _txtfieldTwo.inputAccessoryView = self.keyboardToolbar;
        _txtfieldThree.inputAccessoryView = self.keyboardToolbar;
        _txtfieldFour.inputAccessoryView = self.keyboardToolbar;
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)resignKeyboard
{
    [_txtfieldOne resignFirstResponder];
    [_txtfieldTwo resignFirstResponder];
    [_txtfieldThree resignFirstResponder];
    [_txtfieldFour resignFirstResponder];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    id navigationBarAppearance = self.navigationController.navigationBar;
    
    [navigationBarAppearance setBarTintColor:[UIColor darkGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configClientView
{
    if (bGood) {
        [_titleOneLbl setText:@"What did you like?"];
        
        [_goodTagBtn setImage:[UIImage imageNamed:@"FoodDetective_goodchose"] forState:UIControlStateNormal];
        [_badTagBtn setImage:[UIImage imageNamed:@"FoodDetective_bad"] forState:UIControlStateNormal];
        [_feedbackBtn setImage:[UIImage imageNamed:@"FoodDetective_praise"] forState:UIControlStateNormal];
        
    }else{
        [_titleOneLbl setText:@"Any Problems?"];
        
        [_goodTagBtn setImage:[UIImage imageNamed:@"FoodDetective_good"] forState:UIControlStateNormal];
        [_badTagBtn setImage:[UIImage imageNamed:@"FoodDetective_badchose"] forState:UIControlStateNormal];
        [_feedbackBtn setImage:[UIImage imageNamed:@"FoodDetective_report"] forState:UIControlStateNormal];
    }
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

- (void)showLoadingHud
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = NSLocalizedString(@"Loading Data...", @"数据加载中..." );
    
    [HUD show:YES];
}

- (void)hideLoadingHud
{
    [HUD hide:YES];
}

- (IBAction)feedbackAct:(id)sender
{
    if ([_photoUrlLbl.text length] < 4) {
        takePhotoSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString( @"Take Evidence Photo?",@"选择证据照片")
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"YES",@"是的"),
                            NSLocalizedString(@"NO",@"不需要"),nil];
        takePhotoSheet.actionSheetStyle = UIActionSheetStyleDefault;
        takePhotoSheet.destructiveButtonIndex = 1;	// make the second button red (destructive)
        [takePhotoSheet showInView:self.view];
    }else{
        [self reqAddDetectiveInfo];
    }
}

- (IBAction)takePhotoAct:(id)sender
{
    [self chosePhotoImage];
}

- (IBAction)goodTagAct:(id)sender
{
    bGood = YES;
    
    [self configClientView];
}

- (IBAction)badTagAct:(id)sender
{
    bGood = NO;
    
    [self configClientView];
}

- (IBAction)closeWinAct:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITextfieldDelegate protocol methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignKeyboard];
    return YES;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGPoint pt;
    if (_activeField==_txtfieldOne) {
        
    }
    if (_activeField==_txtfieldTwo) {
        pt = _containerView.center;
        pt.y -= TXTFIELD_OFFSET;
        [_containerView setCenter:pt];
        
        pt = _goodTagBtn.center;
        pt.y -= TXTFIELD_OFFSET;
        [_goodTagBtn setCenter:pt];
        
        pt = _badTagBtn.center;
        pt.y -= TXTFIELD_OFFSET;
        [_badTagBtn setCenter:pt];
        
        pt = _searchImv.center;
        pt.y -= TXTFIELD_OFFSET;
        [_searchImv setCenter:pt];
    }
    
    if (_activeField==_txtfieldThree) {
        
        pt = _containerView.center;
        pt.y -= 2*TXTFIELD_OFFSET;
        [_containerView setCenter:pt];
        
        pt = _goodTagBtn.center;
        pt.y -= 2*TXTFIELD_OFFSET;
        [_goodTagBtn setCenter:pt];
        
        pt = _badTagBtn.center;
        pt.y -= 2*TXTFIELD_OFFSET;
        [_badTagBtn setCenter:pt];
        
        pt = _searchImv.center;
        pt.y -= 2*TXTFIELD_OFFSET;
        [_searchImv setCenter:pt];
    }

    if (_activeField==_txtfieldFour) {
        
        pt = _containerView.center;
        pt.y -= 3*TXTFIELD_OFFSET;
        [_containerView setCenter:pt];
        
        pt = _goodTagBtn.center;
        pt.y -= 3*TXTFIELD_OFFSET;
        [_goodTagBtn setCenter:pt];
        
        pt = _badTagBtn.center;
        pt.y -= 3*TXTFIELD_OFFSET;
        [_badTagBtn setCenter:pt];
        
        pt = _searchImv.center;
        pt.y -= 3*TXTFIELD_OFFSET;
        [_searchImv setCenter:pt];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGPoint pt;
    if (_activeField==_txtfieldOne) {
        
    }
    if (_activeField==_txtfieldTwo) {
        pt = _containerView.center;
        pt.y += TXTFIELD_OFFSET;
        [_containerView setCenter:pt];
        
        pt = _goodTagBtn.center;
        pt.y += TXTFIELD_OFFSET;
        [_goodTagBtn setCenter:pt];
        
        pt = _badTagBtn.center;
        pt.y += TXTFIELD_OFFSET;
        [_badTagBtn setCenter:pt];
        
        pt = _searchImv.center;
        pt.y += TXTFIELD_OFFSET;
        [_searchImv setCenter:pt];
    }
    
    if (_activeField==_txtfieldThree) {
        
        pt = _containerView.center;
        pt.y += 2*TXTFIELD_OFFSET;
        [_containerView setCenter:pt];
        
        pt = _goodTagBtn.center;
        pt.y += 2*TXTFIELD_OFFSET;
        [_goodTagBtn setCenter:pt];
        
        pt = _badTagBtn.center;
        pt.y += 2*TXTFIELD_OFFSET;
        [_badTagBtn setCenter:pt];
        
        pt = _searchImv.center;
        pt.y += 2*TXTFIELD_OFFSET;
        [_searchImv setCenter:pt];
    }

    if (_activeField==_txtfieldFour) {
        
        pt = _containerView.center;
        pt.y += 3*TXTFIELD_OFFSET;
        [_containerView setCenter:pt];
        
        pt = _goodTagBtn.center;
        pt.y += 3*TXTFIELD_OFFSET;
        [_goodTagBtn setCenter:pt];
        
        pt = _badTagBtn.center;
        pt.y += 3*TXTFIELD_OFFSET;
        [_badTagBtn setCenter:pt];
        
        pt = _searchImv.center;
        pt.y += 3*TXTFIELD_OFFSET;
        [_searchImv setCenter:pt];
    }
    _activeField = nil;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    photoImg = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!photoImg) {
        photoImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [_photoUrlLbl setText:@"Photo Ready"];
    
    [self uploadPhotoImg];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void) chosePhotoImage
{
    updatePhotoSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString( @"Chose Photo",@"选择照片")
                                                   delegate:self
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"Phone Camera",@"手机拍照"),NSLocalizedString(@"Photo Album",@"来自图库"),
                        NSLocalizedString(@"Cancel",@"取消操作"),nil];
    updatePhotoSheet.actionSheetStyle = UIActionSheetStyleDefault;
    updatePhotoSheet.destructiveButtonIndex = 2;	// make the second button red (destructive)
    [updatePhotoSheet showInView:self.view];
    
    
}
#pragma mark - actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType;
    
    if (actionSheet == takePhotoSheet) {
        switch (buttonIndex) {
            case 0:
            {
                [self chosePhotoImage];
            }
                break;
            case 1:
            {
                [self reqAddDetectiveInfo];
            }
                break;
            default:
                break;
        }
    }
    if (actionSheet == updatePhotoSheet) {
        switch (buttonIndex) {
            case 0:
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                }
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                break;
            case 2:
                return;
        }
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}

- (void) uploadPhotoImg
{
    if (!photoImg) {
        return;
    }
    
    NSMutableString *URLPath = [NSMutableString stringWithFormat:@"http://azknet.com/oeatapp/oeat_upload_image.php?interface_code=uploadDetetivePhoto"];
    
    NSURL *url = [NSURL URLWithString:URLPath];
    if (url == nil){
        return;
    }
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL: url];
    [urlRequest setHTTPMethod: @"POST"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    [postBody appendData:[@"-----------------------------10102754414578508781458777923\nContent-Disposition: form-data; name=\"image\"; filename=\"photo.jpg\"\nContent-Type: image/jpg\n\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:UIImageJPEGRepresentation(photoImg, 1)];
    
    [postBody appendData:[@"\n-----------------------------10102754414578508781458777923--" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequest addValue:@"multipart/form-data; boundary=---------------------------10102754414578508781458777923" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody: postBody];
    NSLog(@"photo data length: %lu", (unsigned long)[postBody length]);
    
    [self showLoadingHud];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *indata, NSError *error) {
        
        NSString *responseText = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
        NSLog(@"uploadOeatLogo:\n%@",responseText);
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                [self handleUploadAvatar:jsonDict];
            }else{
                [self hideLoadingHud];
            }
            
        }else{
            [self hideLoadingHud];
        }
    }];
    
}

- (void) handleUploadAvatar:(NSDictionary*)dictData
{
    [self hideLoadingHud];
    
    NSString *_status = [dictData objectForKey:@"ret"];
    NSString *_strTmp;
    if ([_status isEqualToString:@"0"]) {
        _strTmp = [dictData objectForKey:@"photo"];
        if (_strTmp) {
            [photoFileUrl setString:_strTmp];
        }else{
            [photoFileUrl setString:@""];
        }
        [_photoUrlLbl setText:photoFileUrl];
    }
}

- (BOOL) checkDetectiveInfo
{
    
    if ([_txtfieldOne.text length] < 1) {
        return NO;
    }else{
        
    }
    
    if ([_txtfieldTwo.text length] < 1) {
        return NO;
    }else{
        
    }
    
    if ([_txtfieldThree.text length] < 1) {
        return NO;
    }else{
        
    }
    
    if ([_txtfieldFour.text length] < 1) {
        return NO;
    }else{
        
    }
    
    return YES;
}

- (void) reqAddDetectiveInfo
{
//    if (![self checkDetectiveInfo]) {
//        [self showReqInfor:@"Info no completed!"];
//        return;
//    }
    
    NSMutableString *URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getPublicUrl]];
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *_tmpStr;
    
    [body appendData:[@"interface_code=addNewDetetive&" dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (bGood) {
        _tmpStr = @"DetectiveType=good&";
    }else{
        _tmpStr = @"DetectiveType=bad&";
    }
    [body  appendData: [_tmpStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    _tmpStr = [NSString stringWithFormat:@"DetectiveDesc=%@&",_txtfieldOne.text];
    [body  appendData: [_tmpStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    _tmpStr = [NSString stringWithFormat:@"Brand=%@&",_txtfieldTwo.text];
    [body  appendData: [_tmpStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    _tmpStr = [NSString stringWithFormat:@"Location=%@&",_txtfieldThree.text];
    [body  appendData: [_tmpStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    _tmpStr = [NSString stringWithFormat:@"Contact=%@&",_txtfieldFour.text];
    [body  appendData: [_tmpStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    _tmpStr = [NSString stringWithFormat:@"PhotoUrl=%@&",_photoUrlLbl.text];
    [body  appendData: [_tmpStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [self showLoadingHud];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *indata, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseText = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
        NSLog(@"reqAddDetectiveInfo: %@",responseText);
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                [self handleReqAddInspect:jsonDict];
            }else{
                [self hideLoadingHud];
            }
        }else{
            [self hideLoadingHud];
        }
        
        
    }];
    
}

- (void) handleReqAddInspect:(NSDictionary*)dictData
{
    [self hideLoadingHud];
}

@end
