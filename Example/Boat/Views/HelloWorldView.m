#import "HelloWorldView.h"
#import <Boat/Drawer.h>

@implementation HelloWorldView

@synthesize textUserName, textPassword, logoImgView;

- (instancetype)initWithFrame:(CGRect)frame controller:(id)ctrl
{
    self = [self initWithFrame:frame styleFile:@"HelloWorld.ss" controller:ctrl];
    textUserName = [self.btDrawer addTextInput:@"用户名或邮箱" css:@"text_input_name"];
    textPassword = [self.btDrawer addTextInput:@"密码" css:@"text_input_password"];
    textPassword.secureTextEntry = YES;
    logoImgView = [self.btDrawer addImageView:@"logo" options:nil];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.btDrawer updateImageView:logoImgView imageName:@"http://tmeiju.com/images/ios-qrcode.png" placeholderImage:@"login-username.png" options:nil];
    [self.btDrawer drawText:@"Boat" css:@"title"];

    [self.btDrawer drawImage:@"login-username-input-bg.png" css:@"text_input_name_wrap" options:nil];
    [self.btDrawer drawImage:@"login-username.png" css:@"text_input_name_icon" options:nil];

    [self.btDrawer drawImage:@"login-password-input-bg.png" css:@"text_input_password_wrap" options:nil];
    [self.btDrawer drawImage:@"login-password.png" css:@"text_input_password_icon" options:nil];

    /*ImageButton *btnLogin = [drawer genImageButton:@"login-confirm" css:@"login_button"];
    [self addSubview:btnLogin];

    ImageButton *btnRegister = [drawer genImageButton:@"login-register" css:@"register_button"];
    [self addSubview:btnRegister];*/
}

@end
