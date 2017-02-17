//
//  ViewController.m
//  WeiBoSegement
//
//  Created by caijing on 17/1/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "ViewController.h"
#import "CJSegmentControl.h"

@interface ViewController ()<UIScrollViewDelegate,CJSegmentControlDelegate>

@property (nonatomic, weak  ) UIScrollView *scr;
@property (nonatomic, weak  ) CJSegmentControl *segementControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CJSegmentControl *singleSegementControl = [[CJSegmentControl alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 35) titles:@[@"选我",@"快选我",@"快点选我",@"选项1",@"选项1",@"选项1",@"选项1",@"拳打镇关西"] selectionWidth:100];
    singleSegementControl.gradientColors = @[[UIColor redColor],[UIColor cyanColor]];
    singleSegementControl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.];
    singleSegementControl.fontSize = 13;
    singleSegementControl.normalColor = [UIColor whiteColor];
    singleSegementControl.selectedColor = [UIColor redColor];
    singleSegementControl.gradientBottomMargin = 8;
    singleSegementControl.gradientOffset = 50;
    singleSegementControl.cjDelegate = self;
   [self.view addSubview:singleSegementControl];

    CJSegmentControl *segementControl = [[CJSegmentControl alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 30) titles:@[@"123",@"AAA",@"VVV",@"CCC",@"123",@"AAA",@"VVV",@"CCC"] selectionWidth:80 scr:self.scr];
    segementControl.backgroundColor = [UIColor whiteColor];
    segementControl.gradientOffset = -50;
    segementControl.gradientBottomMargin = 5;
    _segementControl = segementControl;
    [self.view  addSubview:segementControl];
    
    singleSegementControl.index = 3;

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)segmentControlSelected:(NSInteger)tag{
    [_segementControl setIndex:tag];
}

- (UIScrollView *)scr{
    if (!_scr) {
        UIScrollView *scr = [[UIScrollView alloc] init];
        scr.pagingEnabled = YES;
        scr.frame = CGRectMake(0, 94, self.view.frame.size.width, self.view.frame.size.height - 94);
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
        _scr = scr;
    }
    return _scr;
}

@end
