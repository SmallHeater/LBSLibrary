//
//  ViewController.m
//  LBSDemo
//
//  Created by xianjunwang on 17/5/11.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "ViewController.h"
#import "LBSLibrary.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton * goCityLishVCBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    goCityLishVCBtn.frame = CGRectMake(100, 100, 100, 60);
    [goCityLishVCBtn setTitle:@"城市列表" forState:UIControlStateNormal];
    [goCityLishVCBtn addTarget:self action:@selector(goCityListVCBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goCityLishVCBtn];
}

-(void)goCityListVCBtnClicked{
    NSLog(@"1");
    UIViewController * vc = [LBSLibrary getCityListViewController];
    [self presentViewController:vc animated:YES completion:^{
        NSLog(@"2");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
