//
//  ScrollWithImages.h
//  Notes
//
//  Created by Евгений Фесь on 25.07.16.
//  Copyright © 2016 AM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollImagesDelegate <NSObject>

- (void)removeImageWithIndex:(NSInteger)index;

@end

@interface ScrollWithImages : UIScrollView

@property (weak, nonatomic) id<ScrollImagesDelegate> delegate;
- (ScrollWithImages*)showImages:(NSArray*)images;

@end
