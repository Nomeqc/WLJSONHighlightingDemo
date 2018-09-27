//
//  CodePreviewController.m
//  AppVersionReminder
//
//  Created by Fallrainy on 2018/4/16.
//  Copyright © 2018年 Fallrainy. All rights reserved.
//

#import "CodePreviewController.h"
#import "HOCodeView.h"
#import "HOTextStorage.h"
#import "VKBeautify.h"

@import JavaScriptCore;

@interface CodePreviewController ()

@property (nonatomic) HOCodeView *codeView;

@end

@implementation CodePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    NSString *beautifiedJsonString = [VKBeautify beautified:self.jsonString type:VKBeautifySourceTypeJSON];
    self.codeView.text = beautifiedJsonString;
    [self.codeView render:beautifiedJsonString language:@"json"];
}

- (void)setupViews {
    self.codeView = ({
        HOCodeView *view = [[HOCodeView alloc] init];
        view.frame = self.view.bounds;
        view.editable = NO;
        [view setDataDetectorTypes:UIDataDetectorTypeLink];
        view;
    });
    [self.view addSubview:self.codeView];
}


@end
