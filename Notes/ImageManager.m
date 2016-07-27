//
//  ImageManager.m
//  Notes
//
//  Created by Евгений Фесь on 23.07.16.
//  Copyright © 2016 AM. All rights reserved.
//

#import "ImageManager.h"

@implementation ImageManager

+ (void)saveImage:(UIImage *)image filename:(NSString *)filename{
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
        NSData * data = UIImagePNGRepresentation(image);
        [data writeToFile:filename atomically:YES];
    });
}



+ (UIImage *)getImage:(NSString *)filename{
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData * data = [NSData dataWithContentsOfFile:filename];
    return [UIImage imageWithData:data];
}



+ (void)removeImage:(NSString*)filename{
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager removeItemAtPath:filename error:&error];
}

@end
