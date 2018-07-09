//
//  ZPDFView.h
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPDFView : UIView {
    CGPDFDocumentRef pdfDocument;
    NSUInteger pageNO;
}

-(id)initWithFrame:(CGRect)frame atPage:(NSUInteger)index withPDFDoc:(CGPDFDocumentRef) pdfDoc;

@end
