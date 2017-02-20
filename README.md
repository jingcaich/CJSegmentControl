# WeiBo-Segment-Control
[![CocoaPods](https://img.shields.io/cocoapods/v/CJSegmentControl.svg)](http://cocoapods.org/pods/CJSegmentControl)
###模仿微博iOS App的选项滑动功能(觉得比较有意思，就花了一个下午做了下)

##Cocoapods
> pod 'CJSegmentControl'

##Update history
version 1.1.2 => 增加demo, 并增加滚动优化, 新增渐变indicator属性的支持
##Sample
 ![image](https://github.com/jingcaich/CJSegmentControl/blob/master/seg.gif)
                                                                                         
##Usage
```
/// 传入对应的数据即可 1.1.2增加每个选项的宽度 并关联UIScrollView
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>  *)titles selectionWidth:(CGFloat)selectionWidth scr:(UIScrollView *)src;
/// 1.1.2新增, 不需要关联UIScrollView
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>  *)titles selectionWidth:(CGFloat)selectionWidth;
```

##最后
欢迎各位使用,有问题欢迎pr或者issue, qq:519475439 蔡晶
