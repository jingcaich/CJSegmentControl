//
//  CJSegementView.m
//  WeiBoSegement
//
//  Created by caijing on 17/1/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "CJSegmentControl.h"
#import <mach/mach_time.h>

#define COLOR_RGB(rgbValue,a) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00)>>8))/255.0 blue: ((float)((rgbValue) & 0xFF))/255.0 alpha:(a)]


@implementation CJSegmentViewAttManager



@end

@interface CJTopButton : UIButton


@end

@implementation CJTopButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return self;
}

- (void)resetNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor fontSize:(NSInteger)fontSize{
    [self setTitleColor:selectedColor forState:UIControlStateSelected];
    [self setTitleColor:selectedColor forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

@end

// gradient layer basic config
CGFloat const kGradientViewHeight = 4;
CGFloat const kGradientViewGap = 4;
CGFloat const kGradientWidth = 30;
CGFloat const kScrollViewOffsetDeviation = 10; //误差

NSString * const kCJSegementViewContentOffset = @"contentOffset";

@interface CJSegmentControl()<UIScrollViewDelegate>

@property (nonatomic, weak  ) CJTopButton *lastSelectedButton;
@property (nonatomic, strong) CAGradientLayer *progressLayer;
@property (nonatomic, strong) NSMutableArray<CJTopButton *> *mutArr;
//
@property (nonatomic, assign) CGFloat averageWidth;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat buttonHeight;

@property (nonatomic, strong) UIScrollView *scr;
@end

@implementation CJSegmentControl

#pragma mark - Initial

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles scr:(UIScrollView *)src{
    
    if (self = [super initWithFrame:frame]) {
        _mutArr = @[].mutableCopy;
        src.bounces = NO;
        _averageWidth = frame.size.width / titles.count;
        _height = frame.size.height;
        _buttonHeight = _height - kGradientViewHeight - 2 * kGradientViewGap;
        for (int i = 0; i < titles.count;i++) {
            CJTopButton *titleButton = [[CJTopButton alloc] initWithFrame:CGRectMake(i * _averageWidth, 0, _averageWidth, _buttonHeight)];
            titleButton.userInteractionEnabled = YES;
            titleButton.tag = i;
            [titleButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [titleButton setTitle:titles[i] forState:UIControlStateNormal];
            [_mutArr addObject:titleButton];
            if (0 == i) {_lastSelectedButton = titleButton;_lastSelectedButton.selected = YES;};
            [self addSubview:titleButton];
        }
        self.progressLayer.frame = CGRectMake((_averageWidth - kGradientWidth) / 2., _buttonHeight + kGradientViewGap, kGradientWidth, kGradientViewHeight);
        [self.layer addSublayer:self.progressLayer];
        _scr = src;
        [_scr addObserver:self forKeyPath:kCJSegementViewContentOffset options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
#pragma mark - Actions

- (void)clickAction:(CJTopButton *)button{
    
    if (_lastSelectedButton == button) return; //需求待定

    [_scr setContentOffset:CGPointMake(_scr.frame.size.width * button.tag - 0.1, 0) animated:YES];
    
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object == _scr) {
        
        CGPoint new = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (!_scr.dragging && new.x == 0) return;
        if (new.x < 0 || new.x > (_scr.contentSize.width - _scr.frame.size.width)) return;
        CGFloat halfMargin = (_averageWidth - kGradientWidth) / 2.;
        
        if ((new.x >= (_lastSelectedButton.tag  * _scr.frame.size.width + _scr.frame.size.width))) {
            _lastSelectedButton.selected = NO;
            CJTopButton *btn = _mutArr[_lastSelectedButton.tag + 1];
            _lastSelectedButton = btn;
            btn.selected = YES;
        }else if (new.x < (_lastSelectedButton.tag * _scr.frame.size.width - _scr.frame.size.width) + kScrollViewOffsetDeviation){
            _lastSelectedButton.selected = NO;
            CJTopButton *btn = _mutArr[_lastSelectedButton.tag - 1];
            _lastSelectedButton = btn;
            btn.selected = YES;
        }
        
        CGFloat originX = _averageWidth * _lastSelectedButton.tag + halfMargin;
        CGFloat scrOriginX = _scr.frame.size.width * _lastSelectedButton.tag;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        if (new.x >= scrOriginX) {
            CGFloat currentMidX = (_lastSelectedButton.tag * _scr.frame.size.width + _scr.frame.size.width / 2.);
            if (new.x >= currentMidX) {
                CGFloat rate = (new.x - currentMidX) / (_scr.frame.size.width / 2.);
                self.progressLayer.frame = CGRectMake( originX +  _averageWidth + kGradientWidth , _buttonHeight + kGradientViewGap, - (kGradientWidth + (1 - rate) * _averageWidth), kGradientViewHeight);
            }else{
                CGFloat rate = (currentMidX - new.x) / (_scr.frame.size.width / 2.);
                self.progressLayer.frame = CGRectMake( originX  , _buttonHeight + kGradientViewGap, kGradientWidth + (1 - rate) * _averageWidth, kGradientViewHeight);
            }
        }
        else{
            CGFloat currentMidX = (_lastSelectedButton.tag * _scr.frame.size.width - _scr.frame.size.width / 2.);
            if (new.x > currentMidX) {
                CGFloat rate = ( new.x - currentMidX) / (_scr.frame.size.width / 2.);
                self.progressLayer.frame = CGRectMake( originX + kGradientWidth , _buttonHeight + kGradientViewGap, - (kGradientWidth + (1 - rate) * _averageWidth), kGradientViewHeight);
            }else{
                CGFloat rate =  (currentMidX -  new.x) / (_scr.frame.size.width / 2.);
                self.progressLayer.frame = CGRectMake(originX - _averageWidth, _buttonHeight + kGradientViewGap, (1-rate) * _averageWidth + kGradientWidth, kGradientViewHeight);
            }
        }
        
        [CATransaction commit];
    }
}

#pragma mark - Getter & Setter

- (void)setManager:(CJSegmentViewAttManager *)manager{
    _manager = manager;
    for (CJTopButton *button in _mutArr) {
        [button  resetNormalColor:manager.normalColor selectedColor:manager.normalColor fontSize:manager.fontSize];
    }
    if (manager.gradientColors.count) {
        NSMutableArray *mut = @[].mutableCopy;
        for (UIColor *color in manager.gradientColors) {
            NSAssert([color isKindOfClass:[UIColor class]], @"please use UIColor type");
            [mut addObject:(id)color.CGColor];
        }
        self.progressLayer.colors = mut.copy;
    }
}


- (CAGradientLayer *)progressLayer{
    
    if (!_progressLayer) {
        _progressLayer = [CAGradientLayer layer];
        _progressLayer.colors = @[(id)COLOR_RGB(0xffaa91, 1).CGColor,(id)COLOR_RGB(0xff6000, 1).CGColor];
        _progressLayer.startPoint = CGPointMake(0, 0.5);
        _progressLayer.endPoint = CGPointMake(1, 0.5);
        _progressLayer.frame = self.bounds;
        _progressLayer.masksToBounds = YES;
        _progressLayer.cornerRadius = 2;
    }
    
    return _progressLayer;
    
}

#pragma mark - Life Circle

- (void)dealloc{
    [_scr removeObserver:self forKeyPath:kCJSegementViewContentOffset];
}

@end
