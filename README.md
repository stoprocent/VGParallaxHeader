# VGParallaxHeader
Parallax Header Class (UIScrollView/UITableView Category) that should work with all kinds of Table Views and Scroll Views while using Auto Layout.

**Best way to explore all configurations is to download Example Project and try it.**

### Demo GIF

![https://raw.githubusercontent.com/stoprocent/VGParallaxHeader/master/demo.gif](https://raw.githubusercontent.com/stoprocent/VGParallaxHeader/master/demo.gif)

### Install

You can use CocoaPods:

```ruby
pod 'VGParallaxHeader'
```

### Using VGParallaxheader

Import UIScrollView+VGParallaxHeader.h, and use as follows:

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];

    HeaderView *headerView = [HeaderView alloc] init];
    
    // or self.tableView
    [self.scrollView setParallaxHeaderView:headerView
                                      mode:VGParallaxHeaderModeFill // For more modes have a look in UIScrollView+VGParallaxHeader.h 
                                    height:200
                           shadowBehaviour:VGParallaxHeaderShadowBehaviourDisappearing]; // For more behaviours have a look in UIScrollView+VGParallaxHeader.h 
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // This must be called in order to work
    [self.scrollView shouldPositionParallaxHeader];
    
    // scrollView.parallaxHeader.progress - is progress of current scroll
    NSLog(@"Progress: %f", scrollView.parallaxHeader.progress);
}
```
