//
//  ZPDFPageModel.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFPageModel.h"
#import "ZPDFPageController.h"

@implementation ZPDFPageModel

-(id) initWithPDFDocument:(CGPDFDocumentRef) pdfDoc {
    self = [super init];
    if (self) {
        pdfDocument = pdfDoc;
    }
    return self;
}

- (ZPDFPageController *)viewControllerAtIndex:(NSUInteger)pageNO {
    // Return the data view controller for the given index.
    //返回PDF文档的页数
    long pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
    if (pageSum== 0 || pageNO >= pageSum+1) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    ZPDFPageController *pageController = [[ZPDFPageController alloc] init];
    pageController.pdfDocument = pdfDocument;
    pageController.pageNO  = pageNO;
    return pageController;
    
}

- (NSUInteger)indexOfViewController:(ZPDFPageController *)viewController {
    return viewController.pageNO;
}

//返回上一个viewcontroller
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController: (ZPDFPageController *)viewController];
    if ((index == 1) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法，自动来维护次序。
    // 不用我们去操心每个ViewController的顺序问题。
    return [self viewControllerAtIndex:index];
}
// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController: (ZPDFPageController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    /**
     *  如果原来加载的数据加载完毕了，就加载更多数据
     */
    long pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
    if (index >= pageSum+1) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

@end
