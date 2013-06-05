//
//  ImageGridViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/3/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"

@interface ImageGridViewController : UIViewController
<GMGridViewActionDelegate,GMGridViewDataSource>
{
    IBOutlet UILabel *hashTagLabel;
    IBOutlet UILabel *numberPhotosLabel;
    IBOutlet UIView *contentView;
}
- (id)initWithHashTagName:(NSString *)tag;
@property (nonatomic, retain) NSString *hashTag;

@end
