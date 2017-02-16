//
//  CJSegementView.h
//  WeiBoSegement
//
//  Created by caijing on 17/1/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CJSegmentControlDelegate <NSObject>

/// (0 ~ titles count - 1)
@optional
- (void)segmentControlSelected:(NSInteger)tag;

@end

@interface CJSegmentControl : UIScrollView

/// delegate
@property (nonatomic, weak  ) id<CJSegmentControlDelegate> cjDelegate;
/// set index, default 0
@property (nonatomic, assign) NSInteger index;

/// top buttons attributes
/// default black color
@property (nonatomic, strong) UIColor *selectedColor;
/// default lightGray color
@property (nonatomic, strong) UIColor *normalColor;
/// default 15
@property (nonatomic, assign) CGFloat fontSize;

/// bottom line view attribute (CAGradientLayer *)
@property (nonatomic, strong) NSArray<UIColor *> * gradientColors;
/// width , default 30
@property (nonatomic, assign) CGFloat gradientWidth;
/// height , default 3
@property (nonatomic, assign) CGFloat gradientHeight;
/// bottom margin , default 4
@property (nonatomic, assign) CGFloat gradientBottomMargin;

/// set gradientLayer auto postion adjust offset.
/// default 0(center of self), >0 ==> move right, <0 ==> move left
@property (nonatomic, assign) CGFloat gradientOffset;
/**
 combine with UIScrollView

 @param frame View frame
 @param titles All titiles use a array
 @param selectionWidth Every selection width
 @param src Kind of UIScrollView
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>  *)titles selectionWidth:(CGFloat)selectionWidth scr:(UIScrollView *)src;

/**
 single segment control

 @param frame View frame
 @param titles All titiles use a array
 @param selectionWidth Every selection width
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>  *)titles selectionWidth:(CGFloat)selectionWidth;

/// selection width
@property (nonatomic, assign, readonly) CGFloat selectionWidth;
/// indicator layer
@property (nonatomic, strong, readonly) CAGradientLayer *progressLayer;
@end
