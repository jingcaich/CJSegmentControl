//
//  ViewController.m
//  WeiBoSegement
//
//  Created by caijing on 17/1/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "ViewController.h"
#import "CJSegmentControl.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak  ) UIScrollView *scr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scr = [[UIScrollView alloc] init];
    scr.delegate = self;
    scr.pagingEnabled = YES;
    _scr = scr;
    CJSegmentControl *segementControl = [[CJSegmentControl alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 30) titles:@[@"123",@"AAA",@"VVV",@"CCC",@"123",@"AAA",@"VVV",@"CCC"] selectionWidth:120 scr:_scr];
    segementControl.backgroundColor = [UIColor greenColor];
    scr.frame = CGRectMake(0, CGRectGetMaxY(segementControl.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(segementControl.frame));
    int titleCount = 8;
    scr.contentSize = CGSizeMake(scr.frame.size.width * titleCount, scr.frame.size.height);
    scr.pagingEnabled = YES;
    for (int i = 0; i < titleCount; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * scr.frame.size.width, 0, scr.frame.size.width, scr.frame.size.height)];
        CGFloat colorRatio = (i + 1) / (CGFloat)titleCount;
        view.backgroundColor = [UIColor colorWithRed:colorRatio green:colorRatio blue:colorRatio alpha:01];
        [scr addSubview:view];
    }
    [self.view  addSubview:scr];
    [self.view  addSubview:segementControl];
    // Do any additional setup after loading the view, typically from a nib.
}

@end
