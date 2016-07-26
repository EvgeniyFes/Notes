//
//  ScrollWithImages.h
//  Notes
//
//  Created by Евгений Фесь on 25.07.16.
//  Copyright © 2016 AM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollWithImagesDelegate <NSObject>

- (void)removeImageWithIndex:(NSInteger)index;

@end

@interface ScrollWithImages : UIScrollView

@property (weak, nonatomic) id<ScrollWithImagesDelegate> delegate;
- (ScrollWithImages*)showImages:(NSArray*)images;

@end
