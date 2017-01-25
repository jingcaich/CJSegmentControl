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
    CJSegmentControl *segementView = [[CJSegmentControl alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 30) titles:@[@"123",@"AAA",@"VVV",@"CCC"] scr:_scr];
    scr.frame = CGRectMake(0, CGRectGetMaxY(segementView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(segementView.frame));
    scr.contentSize = CGSizeMake(scr.frame.size.width * 4, scr.frame.size.height);
    scr.pagingEnabled = YES;
    for (int i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * scr.frame.size.width, 0, scr.frame.size.width, scr.frame.size.height)];
        view.backgroundColor = [UIColor colorWithRed:(i + 1) / 5. green:(i + 1) / 5. blue:(i + 1) / 5. alpha:01];
        [scr addSubview:view];
    }
    [self.view  addSubview:scr];
    [self.view  addSubview:segementView];
    // Do any additional setup after loading the view, typically from a nib.
}


@end
