//
//  Utility.h
//  PrayBook
//
//  Created by Phatthana Tongon on 4/20/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Utility : NSObject
+(BOOL)haveCheckingKey:(NSString*)key;
+(void)createCheckingKey:(NSString*)key withValue:(id)value;
+(UIImagePickerControllerCameraFlashMode)currentFlashMode;
+(void)setCurrentFlashMode:(UIImagePickerControllerCameraFlashMode)mode;


+ (BOOL)isPad;
+ (BOOL)isPhone;

+ (NSArray*)facebookPermission;

+ (void)alertWithMessage:(NSString*)message;
+ (UIBarButtonItem*)menuBarButtonWithID:(UIViewController*)controller;
+ (UIBarButtonItem*)backButton:(UIViewController*)controller;
+ (UIButton*)refreshButton;

+ (UIColor*)backgroundColor;
+ (UIColor*)headerViewColor;

+ (NSData*)compressToFixSize:(UIImage*)image;
+ (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (NSString*)timeAgoWithDate:(NSDate *)time;
+ (NSString*)shortTimeAgoWithDate:(NSDate *)time;
+ (UIImage*)scaleImage:(UIImage*)anImage withEditingInfo:(NSDictionary*)editInfo;
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (NSString*)urlStringForPhotoKey:(NSString*)key;
@end
