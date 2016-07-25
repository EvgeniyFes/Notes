//
//  ImageManager.h
//  Notes
//
//  Created by Евгений Фесь on 23.07.16.
//  Copyright © 2016 AM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageManager : NSObject

+ (void)saveImage:(UIImage *)image filename:(NSString *)filename;
+ (UIImage *)getImage:(NSString *)filename;
+ (void)removeImage:(NSString*)filename;

@end
