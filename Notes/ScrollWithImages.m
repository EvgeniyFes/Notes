//
//  ScrollWithImages.m
//  Notes
//
//  Created by Евгений Фесь on 25.07.16.
//  Copyright © 2016 AM. All rights reserved.
//

#import "ScrollWithImages.h"

@implementation ScrollWithImages

- (ScrollWithImages*)showImages:(NSArray*)images{
    [self removeSubViews];
    
    NSInteger scrollWidth = 10;
    for(int i = 0; i < images.count; i++){
        UIImage* image = images[i];
        CGSize imgSize = image.size;
        
        float maxScale = imgSize.width / 80;
        maxScale = (maxScale > imgSize.height / 100) ? imgSize.height / 100 : maxScale;
        
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(scrollWidth, 10,  imgSize.width / maxScale,  imgSize.height / maxScale)];
        imgView.image = image;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imgView];
        scrollWidth += imgView.frame.size.width;
        
        UIButton* removeBtn = [[UIButton alloc] initWithFrame:CGRectMake(scrollWidth - 15, 5, 20, 20)];
        [removeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        removeBtn.tag = i;
        [removeBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:removeBtn];
        
        
        scrollWidth += 10;
    }
    
    self.scrollEnabled = YES;
    self.contentSize = CGSizeMake(scrollWidth, 100);
    
    return self;
}

- (void)click:(UIButton*)btn{
    [self.delegate removeImageWithIndex:btn.tag];
}

- (void)removeSubViews{
    NSArray* allSubviews = [self subviews];
    for(UIView* view in allSubviews)
        [view removeFromSuperview];
}

@end
