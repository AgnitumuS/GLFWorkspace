//
//  DetailViewController2.m
//  GLFiTunesShare
//
//  Created by guolongfei on 2018/5/30.
//  Copyright © 2018年 GuoLongfei. All rights reserved.
//

#import "DetailViewController2.h"
#import "SubViewController2.h"
#import "FileModel.h"

@interface DetailViewController2 ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
{
    UIPageViewController *pageVC; // 专门用来作电子书效果的,它用来管理其它的视图控制器
    
    GLFFileManager *fileManager;
}
@end

@implementation DetailViewController2


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    FileModel *currentModel = self.fileArray[self.selectIndex];
    self.title = currentModel.name;
    
    pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageVC.view.frame = self.view.bounds;
    pageVC.delegate = self;
    pageVC.dataSource = self;
    
    fileManager = [GLFFileManager sharedFileManager];
    
    SubViewController2 *subVC = [[SubViewController2 alloc] init];
    subVC.currentIndex = self.selectIndex;
    subVC.model = currentModel;
    subVC.backBlock = ^() {
        [self.navigationController popViewControllerAnimated:YES];
    };
    subVC.titleBlock = ^(NSString *title) {
        self.title = title;
    };
    [pageVC setViewControllers:@[subVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.view addSubview:pageVC.view];
}

#pragma mark UIPageViewControllerDataSource
// 上一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    self.selectIndex = ((SubViewController2 *) viewController).currentIndex;
    if (self.selectIndex==0 || self.selectIndex==NSNotFound) {
        return nil;
    }
    
    self.selectIndex--; // 注意: 直接使用VC的顺序index,不要再单独标记了,否则出大问题
    
    SubViewController2 *subVC = [[SubViewController2 alloc] init];
    subVC.currentIndex = self.selectIndex;
    subVC.model = self.fileArray[self.selectIndex];
    subVC.backBlock = ^() {
        [self.navigationController popViewControllerAnimated:YES];
    };
    return subVC;
}

// 下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    self.selectIndex = ((SubViewController2 *) viewController).currentIndex;
    if (self.selectIndex==self.fileArray.count-1 || self.selectIndex==NSNotFound) {
        return nil;
    }
    
    self.selectIndex++;
    
    SubViewController2 *subVC = [[SubViewController2 alloc] init];
    subVC.currentIndex = self.selectIndex;
    subVC.model = self.fileArray[self.selectIndex];
    subVC.backBlock = ^() {
        [self.navigationController popViewControllerAnimated:YES];
    };
    subVC.titleBlock = ^(NSString *title) {
        self.title = title;
    };
    return subVC;
}

#pragma mark UIPageViewControllerDelegate
// 开始滚动或翻页的时候触发
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    NSInteger currentIndex = ((SubViewController2 *) pendingViewControllers[0]).currentIndex;
    FileModel *currentModel = self.fileArray[currentIndex];
    self.title = currentModel.name;
}

// 结束滚动或翻页的时候触发
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}


@end
