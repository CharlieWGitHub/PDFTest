//
//  ZPDFView.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFView.h"

@implementation ZPDFView

-(id)initWithFrame:(CGRect)frame atPage:(NSUInteger)index withPDFDoc:(CGPDFDocumentRef) pdfDoc{
    self = [super initWithFrame:frame];
    pageNO = index;//页码
    pdfDocument = pdfDoc;//文档
    return self;
}

-(void)drawInContext:(CGContextRef)context atPageNo:(NSUInteger)page_no{
    // PDF page drawing expects a Lower-Left coordinate system, so we flip the coordinate system
// before we start drawing.//转化坐标系
/*  调用CGContextTranslateCTM函数来修改每个点的x, y坐标值。意思是该图片会沿x轴移动了100个单位，沿    y轴移动了50个单位。具体代码如下：
     CGContextTranslateCTM (myContext, 100, 50);
*/
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
/*
   CGContextScaleCTM函数来指定x, y缩放因子
 */
    CGContextScaleCTM(context, 1.0, -1.0);
    
    NSInteger pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
    NSLog(@"pageSum = %ld", pageSum);
    
    if (pageNO == 0) {
        pageNO = 1;
    }
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument, pageNO);
//    CGContextSaveGState函数的作用是将当前图形状态推入堆栈
    CGContextSaveGState(context);
//    CGContextConcatCTM ( CGContextRef c, CGAffineTransform transform )：使用 transform 变换矩阵对 CGContextRef 的坐标系统执行变换，通过使用坐标矩阵可以对坐标系统执行任意变换。
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.bounds, 0, true);
    //Quartz 2D 提供更加通用的坐标转换
    CGContextConcatCTM(context, pdfTransform);
    
    CGContextDrawPDFPage(context, page);
//    在修改完成后，您可以通过CGContextRestoreGState函数把堆栈顶部的状态弹出，返回到之前的图形状态。
    CGContextRestoreGState(context);
    
}

- (void)drawRect:(CGRect)rect {
    
    [self drawInContext:UIGraphicsGetCurrentContext() atPageNo:pageNO];
}


/*
 
 CGContextRotateCTM函数来指定旋转角度(以弧度为单位)。意思是图片会以原点(左下角)为中心旋转45度，代码所下所示：
 CGContextRotateCTM (myContext, radians(–45.0));
 
 
 使用Quartz时涉及到一个图形上下文，其中图形上下文中包含一个保存过的图形状态堆栈。在Quartz创建图形上下文时，该堆栈是空的。CGContextSaveGState函数的作用是将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的描画操作，但不影响存储在堆栈中的拷贝。在修改完成后，您可以通过CGContextRestoreGState函数把堆栈顶部的状态弹出，返回到之前的图形状态。这种推入和弹出的方式是回到之前图形状态的快速方法，避免逐个撤消所有的状态修改；这也是将某些状态（比如裁剪路径）恢复到原有设置的唯一方式。
 
 
 */

@end
