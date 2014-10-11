//
//  SignInView.m
//  Boat
//
//  Created by bin on 12/10/14.
//  Copyright (c) 2014 binku. All rights reserved.
//

#import "SignInView.h"
#import <Boat/Drawer.h>

@implementation SignInView

@synthesize textUserName, textPassword;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    Drawer *drawer = [[Drawer alloc] initWithStyleFile:@"SignIn.ss"];
    [drawer drawText:@"Boat" css:@"title"];
    
    [drawer drawImage:@"login-username-input-bg.png" css:@"text_input_name_wrap"];
    [drawer drawImage:@"login-username.png" css:@"text_input_name_icon"];
    textUserName = [drawer genTextInput:@"用户名或邮箱" css:@"text_input_name"];
    [self addSubview:textUserName];
    
    [drawer drawImage:@"login-password-input-bg.png" css:@"text_input_password_wrap"];
    [drawer drawImage:@"login-password.png" css:@"text_input_password_icon"];
    textPassword = [drawer genTextInput:@"密码" css:@"text_input_password"];
    textPassword.secureTextEntry = YES;
    [self addSubview:textPassword];
    
    ImageButton *btnLogin = [drawer genImageButton:@"login-confirm" css:@"login_button"];
    [self addSubview:btnLogin];
    
    ImageButton *btnRegister = [drawer genImageButton:@"login-register" css:@"register_button"];
    [self addSubview:btnRegister];
}

@end
