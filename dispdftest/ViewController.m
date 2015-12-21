//
//  ViewController.m
//  dispdftest
//
//  Created by Aidan Cornelius-Bell on 26/06/2015.
//  Copyright (c) 2015 Department for Education and Child Development. All rights reserved.
//

// Based on this SO answer http://stackoverflow.com/a/28601694/5051008

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"2.2" ofType:@"pdf"]]]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *nextPDF = @"2.2";
    //now traverse to specific page
    [self performSelector:@selector(traverseInWebViewWithPage:) withObject:nextPDF afterDelay:0.1];
}

-(void)traverseInWebViewWithPage: (NSString *) resourcePath
{
    //Get total pages in PDF File ----------- PDF File name here ---------------
    NSString *strPDFFilePath = [[NSBundle mainBundle] pathForResource:resourcePath ofType:@"pdf"];
    NSInteger totalPDFPages = [self getTotalPDFPages:strPDFFilePath];
    
    //Get total PDF pages height in webView
    CGFloat totalPDFHeight = webView.scrollView.contentSize.height;
    NSLog ( @"total pdf height: %f", totalPDFHeight);
    
    //Calculate page height of single PDF page in webView
    NSInteger horizontalPaddingBetweenPages = 10*(totalPDFPages+1);
    CGFloat pageHeight = (totalPDFHeight-horizontalPaddingBetweenPages)/(CGFloat)totalPDFPages;
    NSLog ( @"pdf page height: %f", pageHeight);
    
    //scroll to specific page --------------- here your page number -----------
    NSInteger specificPageNo = 3;
    if(specificPageNo <= totalPDFPages)
    {
        //calculate offset point in webView
        CGPoint offsetPoint = CGPointMake(0, (10*(specificPageNo-1))+(pageHeight*(specificPageNo-1)));
        //set offset in webView
        [webView.scrollView setContentOffset:offsetPoint];
    }
}

-(NSInteger)getTotalPDFPages:(NSString *)strPDFFilePath
{
    NSURL *pdfUrl = [NSURL fileURLWithPath:strPDFFilePath];
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((CFURLRef)pdfUrl);
    size_t pageCount = CGPDFDocumentGetNumberOfPages(document);
    return pageCount;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
