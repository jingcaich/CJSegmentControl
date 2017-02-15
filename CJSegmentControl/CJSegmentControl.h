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

// bottom line view attribute (CAGradientLayer *) kGradientselectionWidth
@property (nonatomic, strong) NSArray<UIColor *> * gradientColors;

@end

@protocol CJSegmentControlDelegate <NSObject>

@optional
- (void)segmentControlSelected:(NSInteger)tag;

@end

@interface CJSegmentControl : UIScrollView


/// attribute manager
@property (nonatomic, strong) CJSegmentViewAttManager *manager;
/// delegate
@property (nonatomic, weak  ) id<CJSegmentControlDelegate> cjDelegate;
/// set index, default 0
@property (nonatomic, assign) NSInteger index;

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


@property (nonatomic, assign, readonly) CGFloat selectionWidth;
/// indicator layer
@property (nonatomic, strong, readonly) CAGradientLayer *progressLayer;
@end
