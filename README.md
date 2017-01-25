# WeiBo-Segment-Control
模仿微博iOS App的选项滑动功能(觉得比较有意思，就花了一个下午做了下)

##Cocoapdos
> pod 'CJSegmentControl'

##Sample
 ![image](https://github.com/jingcaich/WeiBo-Segment-Control/blob/master/seg.gif)
                                                                                         


##Usage
```
// 传入对应的数据即可
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>  *)titles scr:(UIScrollView *)src;
```
##Setting Attibute 
> use Manager class in .h

``` 
@property (nonatomic, strong) CJSegmentViewAttManager *manager 
```
##最后
欢迎各位使用,有问题欢迎pr, qq:519475439 蔡晶
