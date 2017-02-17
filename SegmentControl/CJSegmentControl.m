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

@interface CJTopButton : UIButton

@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;

@end

@implementation CJTopButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _normalTitleColor = [UIColor darkGrayColor];
        _selectedTitleColor = [UIColor blackColor];
        // initialization color
        [self setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
        [self setTitleColor:_normalTitleColor forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.numberOfLines = 0;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [self setTitleColor:selected ?_selectedTitleColor : _normalTitleColor forState:UIControlStateNormal];
}


@end

CGFloat const kScrollViewOffsetDeviation = 10; //误差

NSString * const kCJSegementViewContentOffset = @"contentOffset";

@interface CJSegmentControl()<UIScrollViewDelegate>

@property (nonatomic, weak  ) CJTopButton *lastSelectedButton;
@property (nonatomic, strong) CAGradientLayer *progressLayer;
@property (nonatomic, strong) NSMutableArray<CJTopButton *> *mutArr;
//
@property (nonatomic, assign) CGFloat selectionWidth;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat buttonHeight;
@property (nonatomic, strong) UIScrollView *scr;

@property (nonatomic ,assign) BOOL isUserTap;


@end

@implementation CJSegmentControl

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>  *)titles selectionWidth:(CGFloat)selectionWidth scr:(UIScrollView *)src{
    
    if (self = [super initWithFrame:frame]) {
        // basic config
        _mutArr = @[].mutableCopy;
        _gradientOffset = 0;
        _gradientWidth = 30;
        _gradientHeight = 3;
        _gradientBottomMargin = 4;
        _gradientColors = @[(id)COLOR_RGB(0xffaa91, 1).CGColor,(id)COLOR_RGB(0xff6000, 1).CGColor];
        _selectionWidth = selectionWidth;
        self.contentSize = CGSizeMake(_selectionWidth * titles.count, frame.size.height);
        self.scrollEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        _buttonHeight = frame.size.height - _gradientHeight - 2 * _gradientBottomMargin;
        // add buttons
        for (int i = 0; i < titles.count;i++) {
            CJTopButton *titleButton = [[CJTopButton alloc] initWithFrame:CGRectMake(i * _selectionWidth, 0, _selectionWidth, _buttonHeight)];
            titleButton.userInteractionEnabled = YES;
            titleButton.tag = i;
            [titleButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [titleButton setTitle:titles[i] forState:UIControlStateNormal];
            [_mutArr addObject:titleButton];
            if (0 == i) {_lastSelectedButton = titleButton;_lastSelectedButton.selected = YES;};
            [self addSubview:titleButton];
        }
        // add gradient layer
        [self _adjustProgressLayerFrame];
        [self.layer addSublayer:self.progressLayer];
        
        _scr = src;
        src.bounces = NO;
        if (src) [_scr addObserver:self forKeyPath:kCJSegementViewContentOffset options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>  *)titles selectionWidth:(CGFloat)width{
    return  [self initWithFrame:frame titles:titles selectionWidth:width scr:nil];
}

#pragma mark - Actions

- (void)clickAction:(CJTopButton *)button{
    _isUserTap = YES;
    if (_lastSelectedButton == button) return; //需求待定
    _lastSelectedButton.selected = NO;
    button.selected = YES;
    _lastSelectedButton = button;
    [self _triggerDelegate];
    [self _adjustSelectedPosition];
    [_scr setContentOffset:CGPointMake(_scr.frame.size.width * button.tag, 0) animated:NO];
    [self _adjustProgressLayerFrame];
    _isUserTap = NO;
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (_isUserTap) return;
    if (object == _scr) {
        
        CGPoint new = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (!_scr.dragging && new.x == 0) return;
        if (new.x < 0 || new.x > (_scr.contentSize.width - _scr.frame.size.width)) return;
        CGFloat halfMargin = (_selectionWidth - _gradientWidth) / 2.;
        
        if ((new.x >= (_lastSelectedButton.tag  * _scr.frame.size.width + _scr.frame.size.width))) {
            _lastSelectedButton.selected = NO;
            CJTopButton *btn = _mutArr[_lastSelectedButton.tag + 1];
            _lastSelectedButton = btn;
            btn.selected = YES;
            [self _adjustSelectedPosition];
            [self _triggerDelegate];
        }else if (new.x < (_lastSelectedButton.tag * _scr.frame.size.width - _scr.frame.size.width) + kScrollViewOffsetDeviation){
            _lastSelectedButton.selected = NO;
            CJTopButton *btn = _mutArr[_lastSelectedButton.tag - 1];
            _lastSelectedButton = btn;
            btn.selected = YES;
            [self _adjustSelectedPosition];
            [self _triggerDelegate];
        }
        
        CGFloat originX = _selectionWidth * _lastSelectedButton.tag + halfMargin;
        CGFloat scrOriginX = _scr.frame.size.width * _lastSelectedButton.tag;
        CGFloat layerY = self.frame.size.height - _gradientBottomMargin - _gradientHeight;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        if (new.x >= scrOriginX) {
            CGFloat currentMidX = (_lastSelectedButton.tag * _scr.frame.size.width + _scr.frame.size.width / 2.);
            if (new.x >= currentMidX) {
                CGFloat rate = (new.x - currentMidX) / (_scr.frame.size.width / 2.);
                self.progressLayer.frame = CGRectMake( originX +  _selectionWidth + _gradientWidth , layerY, - (_gradientWidth + (1 - rate) * _selectionWidth), _gradientHeight);
            }else{
                CGFloat rate = (currentMidX - new.x) / (_scr.frame.size.width / 2.);
                self.progressLayer.frame = CGRectMake( originX  , layerY, _gradientWidth + (1 - rate) * _selectionWidth, _gradientHeight);
            }
        }
        else{
            CGFloat currentMidX = (_lastSelectedButton.tag * _scr.frame.size.width - _scr.frame.size.width / 2.);
            if (new.x > currentMidX) {
                CGFloat rate = ( new.x - currentMidX) / (_scr.frame.size.width / 2.);
                self.progressLayer.frame = CGRectMake( originX + _gradientWidth , layerY, - (_gradientWidth + (1 - rate) * _selectionWidth), _gradientHeight);
            }else{
                CGFloat rate =  (currentMidX -  new.x) / (_scr.frame.size.width / 2.);
                self.progressLayer.frame = CGRectMake(originX - _selectionWidth, layerY, (1-rate) * _selectionWidth + _gradientWidth, _gradientHeight);
            }
        }
        
        [CATransaction commit];
    }
}
#pragma mark - Private Methods

- (void)_adjustSelectedPosition{
    CGFloat gap = (self.frame.size.width - _selectionWidth)/2.;
    CGFloat correctX = (_lastSelectedButton.tag ) * _selectionWidth - gap - _gradientOffset;

    if (correctX < 0 ) {
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
        return;
    }
    if (correctX > (self.contentSize.width - self.frame.size.width)) {
        [self setContentOffset:CGPointMake(self.contentSize.width - self.frame.size.width, 0) animated:YES];
        return;
    }
    [self setContentOffset:CGPointMake(correctX, 0) animated:YES];
}


- (void)_triggerDelegate{
    if ([self.cjDelegate respondsToSelector:@selector(segmentControlSelected:)]) {
        [self.cjDelegate segmentControlSelected:_lastSelectedButton.tag];
    }
}

- (void)_adjustProgressLayerFrame{
    CGFloat halfMargin = (_selectionWidth - _gradientWidth) / 2.;
    _progressLayer.frame = CGRectMake(_lastSelectedButton.tag *_selectionWidth +halfMargin , self.frame.size.height - _gradientBottomMargin - _gradientHeight, _gradientWidth, _gradientHeight);
}

#pragma mark - Getter & Setter

- (void)setGradientBottomMargin:(CGFloat)gradientBottomMargin{
    _gradientBottomMargin = gradientBottomMargin;
    [self _adjustProgressLayerFrame];
}

- (void)setGradientWidth:(CGFloat)gradientWidth{
    _gradientWidth = gradientWidth;
    [self _adjustProgressLayerFrame];
}

- (void)setGradientHeight:(CGFloat)gradientHeight{
    _gradientHeight = gradientHeight;
    [self _adjustProgressLayerFrame];
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    if (index-1 >_mutArr.count) return;
    CJTopButton *btn = _mutArr[index];
    [self clickAction:btn];
}

- (void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    for (CJTopButton *button in _mutArr) {
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    for (CJTopButton *button in _mutArr) {
        button.normalTitleColor = normalColor;
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
    for (CJTopButton *button in _mutArr) {
        button.selectedTitleColor = selectedColor;
    }
}

- (void)setGradientColors:(NSArray<UIColor *> *)gradientColors{
    _gradientColors = gradientColors;
    if (gradientColors.count) {
        NSMutableArray *mut = @[].mutableCopy;
        for (UIColor *color in gradientColors) {
            NSAssert([color isKindOfClass:[UIColor class]], @"please use UIColor type");
            [mut addObject:(id)color.CGColor];
        }
        self.progressLayer.colors = mut.copy;
    }
}

- (CAGradientLayer *)progressLayer{
    
    if (!_progressLayer) {
        _progressLayer = [CAGradientLayer layer];
        _progressLayer.colors = _gradientColors;
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
    if (_scr) [_scr removeObserver:self forKeyPath:kCJSegementViewContentOffset];
}

@end
