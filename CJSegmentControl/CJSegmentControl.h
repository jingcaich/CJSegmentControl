//
//  CJSegementView.h
//  WeiBoSegement
//
//  Created by caijing on 17/1/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJSegmentViewAttManager : NSObject

// top buttons attributes
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, assign) NSUInteger fontSize;

// bottom line view attribute (CAGradientLayer *) kGradientWidth
@property (nonatomic, strong) NSArray<UIColor *> * gradientColors;

@end

@interface CJSegmentControl : UIView
/**
 唯一的初始化方法
 
 @param frame frame
 @param titles all titiles use a array
 @param src kind of UISCrollView
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>  *)titles scr:(UIScrollView *)src;

@property (nonatomic, strong) CJSegmentViewAttManager *manager;

@end
