# VGParallaxHeader
Parallax Header Class (UIScrollView/UITableView Category) that should work with all kinds of Table Views and Scroll Views while using Auto Layout.

**It is using tableHeaderView** so no ugly hacks by adding subview to UITableView and changing contentInset.
If you change contentInset section headers are displayed wrong. 
And YES ... it's very fast ;)

**Best way to explore all configurations is to download Example Project and try it.**

### Demo GIF

![https://raw.githubusercontent.com/stoprocent/VGParallaxHeader/master/demo.gif](https://raw.githubusercontent.com/stoprocent/VGParallaxHeader/master/demo.gif)

### Install

You can use CocoaPods:

```ruby
pod 'VGParallaxHeader'
```

### Version 0.0.6 Update

This version fix a little glitch i didnt notice in VGParallaxHeaderModeCenter mode when
parallax header view height will jump 0.0f-0.5f. This was causing layoutSubviews 
being called on each scrollViewDidScroll. 

** Please note that VGParallaxHeaderModeCenter should be the fastest mode. **

** I think I'm almost ready to mark it as version 1.0 soon. If you have any requests or ideas let me know. **

### Version 0.0.5 Update

Please note that shadow is now depricated. If you are using **setParallaxHeaderView:mode:height:shadowBehaviour:** it will give you warning.

New version brings new property called **Sticky View**. You can replicate shadow with it. Have a look in examples and gif :)
Have fun using new version and please report any problems in Github **issues**.
Full Storyboard support is still pending and again I'm more than happy if someone will create pull request with this feature.

### Using VGParallaxheader

Import UIScrollView+VGParallaxHeader.h, and use as follows:

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];

    HeaderView *headerView = [HeaderView alloc] init];
    
    // or self.tableView
    [self.scrollView setParallaxHeaderView:headerView
                                      mode:VGParallaxHeaderModeFill // For more modes have a look in UIScrollView+VGParallaxHeader.h 
                                    height:200];
                                    
    // Optional Sticky View :)
    UILabel *stickyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stickyLabel.backgroundColor = [UIColor colorWithRed:1 green:0.749 blue:0.976 alpha:1];
    stickyLabel.textAlignment = NSTextAlignmentCenter;
    stickyLabel.text = @"Say hello to Sticky View :)";
    
    self.tableView.parallaxHeader.stickyViewPosition = VGParallaxHeaderStickyViewPositionBottom; // VGParallaxHeaderStickyViewPositionTop
    [self.tableView.parallaxHeader setStickyView:stickyLabel
                                      withHeight:40];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // This must be called in order to work
    [self.scrollView shouldPositionParallaxHeader];
    
    // scrollView.parallaxHeader.progress - is progress of current scroll
    NSLog(@"Progress: %f", scrollView.parallaxHeader.progress);
    
    // This is how you can implement appearing or disappearing of sticky view
    [scrollView.parallaxHeader.stickyView setAlpha:scrollView.parallaxHeader.progress];
}
```
