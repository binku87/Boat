//
//  BoatCellView.h
//  Pods
//
//  Created by bin on 30/12/14.
//
//

#import <UIKit/UIKit.h>
#import "Drawer.h"

@interface BoatCellView : UITableViewCell

@property (nonatomic) Drawer *btDrawer;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier styleFile:(NSString *)styleFile;

@end
