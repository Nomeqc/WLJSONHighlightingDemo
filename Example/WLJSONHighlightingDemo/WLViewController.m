//
//  WLViewController.m
//  WLJSONHighlightingDemo
//
//  Created by nomeqc@gmail.com on 09/26/2018.
//  Copyright (c) 2018 nomeqc@gmail.com. All rights reserved.
//

#import "WLViewController.h"
#import "CodePreviewController.h"


@interface WLViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WLViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.text = @"com.taobao.taobao4iphone";
}

- (IBAction)didTapQueryButton:(UIButton *)sender {
    NSString *bundleId = self.textField.text;
    if (bundleId.length == 0) {
        return;
    }
    [self requestWithBundleId:bundleId];
}

- (void)requestWithBundleId:(NSString *)bundleId {
    ///添加uuid参数 避免CDN缓存
    NSString *URLString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@&country=cn&uuid=%@",bundleId,[NSUUID UUID].UUIDString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:15.0];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                                                            [self showErrorText:[NSString stringWithFormat:@"%@",error]];
                                                        });
                                                    } else {
                                                        NSError *JSONError;
                                                        id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:&JSONError];
                                                        if (!JSONError) {
                                                            NSLog(@"%@",JSON);
                                                            NSString *prettyJsonString = ({
                                                                NSData *data = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
                                                                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                str;
                                                            });
                                                            dispatch_async(dispatch_get_main_queue(), ^(void) {
                                                                CodePreviewController *controller = [[CodePreviewController alloc] init];
                                                                controller.jsonString = prettyJsonString;
                                                                [self.navigationController pushViewController:controller animated:YES];
                                                            });
                                                        } else {
                                                            dispatch_async(dispatch_get_main_queue(), ^(void) {
                                                                [self showErrorText:@"JSON解析出错"];
                                                            });
                                                        }
                                                    }
                                                }];
    [dataTask resume];
}


- (void)showErrorText:(NSString *)text {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:text message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
