//
//  Utility.m
//  PrayBook
//
//  Created by Phatthana Tongon on 4/20/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "Utility.h"
#import "IIViewDeckController.h"
@implementation Utility

+ (void)alertWithMessage:(NSString*)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"StockShot"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

+(BOOL)haveCheckingKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:key])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(void)createCheckingKey:(NSString*)key withValue:(id)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (BOOL)isPad
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return NO;
}

+ (BOOL)isPhone
{
    return ![Utility isPad];
}



+ (NSArray*)facebookPermission
{
    NSArray * params = [NSArray arrayWithObjects:
                        @"user_checkins",@"friends_checkins",@"email",
                        nil];
    
    return params;
}

+ (UIBarButtonItem*)menuBarButtonWithID:(UIViewController*)controller
{
    UIButton *toggleButton = [[UIButton alloc] init];
    toggleButton.frame = CGRectMake(0, 0, 50, 44);
    [toggleButton setImage:[UIImage imageNamed:@"menu_bt.png"] forState:UIControlStateNormal];
    toggleButton.imageView.contentMode = UIViewContentModeCenter;
    [toggleButton addTarget:controller.viewDeckController
                     action:@selector(toggleLeftView)
           forControlEvents:UIControlEventTouchUpInside];

    return [[UIBarButtonItem alloc] initWithCustomView:toggleButton];
}

+ (UIBarButtonItem*)backButton:(UIViewController*)controller
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"back_bt.png"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton addTarget:controller.navigationController action:@selector(popViewControllerAnimated:)
         forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

+ (UIButton*)refreshButton
{
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"refresh_bt.png"] forState:UIControlStateNormal];
    refreshButton.frame = CGRectMake(0, 0, 44, 44);
    return refreshButton;
}

+ (UIColor*)backgroundColor
{
    return [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0];
}

+ (UIColor*)headerViewColor
{
    return [UIColor colorWithRed:125.0/255.0 green:135.0/255.0 blue:143.0/255.0 alpha:1.0];
}

+ (NSData*)compressToFixSize:(UIImage*)image
{
    CGFloat compression = 0.8f;
    CGFloat maxCompression = 0.1f;
    NSInteger maxFileSize = 40000;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.05;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;
}

+ (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height)
    {
        NSLog(@"W>H");
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSString*)timeAgoWithDate:(NSDate *)time
{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *dateNow = [NSDate date];
    int timeAgo;
    NSString *unit = [[NSString alloc] init];
    
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:time  toDate:dateNow  options:0];
    
    if ([breakdownInfo month] > 0)
    {
        timeAgo = [breakdownInfo month];
        if (timeAgo>1)
            unit = @"months";
        else
            unit = @"month";
    }
    else if([breakdownInfo day] > 0)
    {
        timeAgo = [breakdownInfo day];
        if (timeAgo>1)
            unit = @"days";
        else
            unit = @"day";
    }
    else if([breakdownInfo hour] > 0)
    {
        timeAgo = [breakdownInfo hour];
        if (timeAgo>1)
            unit = @"hours";
        else
            unit = @"hour";
    }
    else if([breakdownInfo minute] > 0)
    {
        timeAgo = [breakdownInfo minute];
        if (timeAgo>1)
            unit = @"minutes";
        else
            unit = @"minute";
    }
    else
    {
        timeAgo = [breakdownInfo second];
        if (timeAgo>1 && timeAgo < 60)
            unit = @"secs";
        else
        {
            unit = @"sec";
            timeAgo = 1;
        }
        
    }
    return [NSString stringWithFormat:@"%d %@ ago",timeAgo,unit];
}

+ (UIImage*)scaleImage:(UIImage*)anImage withEditingInfo:(NSDictionary*)editInfo{
    
    UIImage *newImage;
    
    UIImage *originalImage = [editInfo valueForKey:@"UIImagePickerControllerOriginalImage"];
    CGSize originalSize = CGSizeMake(originalImage.size.width, originalImage.size.height);
    CGRect originalFrame;
    originalFrame.origin = CGPointMake(0,0);
    originalFrame.size = originalSize;
    
    CGRect croppingRect = [[editInfo valueForKey:UIImagePickerControllerCropRect] CGRectValue];
    CGSize croppingRectSize = CGSizeMake(croppingRect.size.width, croppingRect.size.height);
//    NSLog(@"CropRect: %@",NSStringFromCGRect(croppingRect));
    
    CGSize croppedScaledImageSize = anImage.size;
    
    float scaledBarClipHeight = 0;
    
    CGSize scaledImageSize;
    float scale;
    
//    NSLog(@"croppedScaledImageSize: %@ || originalSize: %@",NSStringFromCGSize(croppedScaledImageSize),NSStringFromCGSize(originalSize));
    if(CGSizeEqualToSize(croppedScaledImageSize, originalSize)){
        
        scale = croppedScaledImageSize.width/croppingRectSize.width;
        float barClipHeight = scaledBarClipHeight/scale;
        
        croppingRect.origin.y -= barClipHeight;
        
        if(croppingRect.origin.y<=0){
            croppingRect.size.height += croppingRect.origin.y;
            croppingRect.origin.y=0;
        }
        
        if(croppingRect.size.height > (originalSize.height - croppingRect.origin.y)){
            croppingRect.size.height = (originalSize.height - croppingRect.origin.y);
        }
        
        
        scaledImageSize = croppingRect.size;
        scaledImageSize.width *= scale;
        scaledImageSize.height *= scale;
//        NSLog(@"CropRect: %@",NSStringFromCGRect(croppingRect));
        newImage =  [Utility cropImage:originalImage to:croppingRect andScaleTo:scaledImageSize];

        
    }else{
        
        newImage = originalImage;
        
    }
    
    return newImage;
}

+ (UIImage *)cropImage:(UIImage *)image to:(CGRect)cropRect andScaleTo:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef subImage = CGImageCreateWithImageInRect([image CGImage], cropRect);
    CGRect myRect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, 0.0f, -size.height);
    CGContextDrawImage(context, myRect, subImage);
    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(subImage);
    return croppedImage;
}

+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    [imageToCrop drawInRect:CGRectMake(rect.origin.x, rect.origin.y,
                                       imageToCrop.size.width, imageToCrop.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
