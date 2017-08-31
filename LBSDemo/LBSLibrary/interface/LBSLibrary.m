//
//  LBSLibrary.m
//  LBSLibrary
//
//  Created by xianjunwang on 17/5/11.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "LBSLibrary.h"
#import "CityListViewController.h"

@implementation LBSLibrary

#pragma mark  ----  自定义函数
static LBSLibrary * lbs = nil;
+(LBSLibrary *)sharedManager{
    
    if (!lbs) {
        lbs = [[LBSLibrary alloc] init];
        [lbs startLocating];
    }
    return lbs;
}

#pragma mark ----  定位
-(void)startLocating{
    
    //判断是否开启了定位服务
    if (![CLLocationManager locationServicesEnabled])
    {
        return;
    }
    
    //还未弹出权限的弹框
    if ([CLLocationManager authorizationStatus] == 0) {
        return;
    }
    //判断 本应用的定位服务是否开启
    if ([CLLocationManager authorizationStatus] < 3) {
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString * remaindStr = [NSString stringWithFormat:@"%@的定位服务未开启，请在iPhone的“设置”- “隐私”-“定位服务”功能中，找到应用程序“%@”更改",[infoDictionary objectForKey:@"CFBundleDisplayName"],[infoDictionary objectForKey:@"CFBundleDisplayName"]];
        //定位功能不可用
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:remaindStr preferredStyle:UIAlertControllerStyleAlert];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:^{
            
        }];
        return;
    }
    
    //定位功能可用
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    //设置定位精度
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

#pragma mark    城市列表的VC
+(UIViewController *)getCityListViewController{
    
    CityListViewController * cityListViewController = [[CityListViewController alloc] init];
    return cityListViewController;
}

#pragma mark  ----  代理
#pragma mark    定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //定位失败时，当前定位城市显示@"定位失败"
    NSLog(@"定位失败");
}
#pragma mark  ----  位置
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation * location = [locations objectAtIndex:0];
    NSLog(@"经度：%lf,纬度：%lf,楼层：%ld,位置的字符串显示：%@",location.coordinate.latitude,location.coordinate.longitude,location.floor.level,location.description);
    [locationManager stopUpdatingLocation];
}



@end
