#import "HelloWorldView.h"
#import <Boat/Drawer.h>

@implementation HelloWorldView

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
    Drawer *drawer = [[Drawer alloc] initWithStyleFile:@"HelloWorld.ss"];
    UIImageView *logo = [drawer genRemoteImage:@"http://tmeiju.com/images/ios-qrcode.png" placeholderImage:@"login-username.png" css:@"logo"];
    [self addSubview:logo];
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
