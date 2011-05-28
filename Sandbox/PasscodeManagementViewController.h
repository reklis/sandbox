//
//  PasscodeManagementViewController.h
//  tnsbodapp
//
//  Created by Steven Fusco on 5/12/11.
//  Copyright 2011 Cibo Technology, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PasscodeView.h"

typedef enum PasscodeManagementStepsEnum {
    PasscodeManagementStep_EnterCurrentPasscode = 1,
    PasscodeManagementStep_EnterNewPasscode,
    PasscodeManagementStep_EnterNewPasscodeAgain,
    PasscodeManagementStep_Success
} PasscodeManagementStep;

@protocol PasscodeManagementDelegate;

@interface PasscodeManagementViewController : UIViewController
<PasscodeViewDelegate>
{
@private
    PasscodeManagementStep currentStep;
}

@property (nonatomic, retain) NSString* currentPasscode;
@property (nonatomic, retain) NSString* newPasscode;

@property (nonatomic, assign) id<PasscodeManagementDelegate> delegate;

- (void) saveChanges;
- (NSString*) messageForStep:(PasscodeManagementStep)step;

@end

@protocol PasscodeManagementDelegate <NSObject>

@optional

- (void) passcodeManagerDidCancel:(PasscodeManagementViewController*)mgr;
- (void) passcodeManagerDidSucceed:(PasscodeManagementViewController*)mgr;

@end