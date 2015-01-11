//
//  BoatCellView.m
//  Pods
//
//  Created by bin on 30/12/14.
//
//

#import "BoatCellView.h"
#import "Drawer.h"

@implementation BoatCellView

@synthesize btDrawer;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier styleFile:(NSString *)styleFile
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    btDrawer = [[Drawer alloc] initWithStyleFile:styleFile view:self];
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    [btDrawer reset];
}
@end
