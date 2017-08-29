//
//  LBSLibrary.h
//  LBSLibrary
//
//  Created by xianjunwang on 17/5/11.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>//定位
#import <MapKit/MapKit.h>
@interface LBSLibrary : NSObject<CLLocationManagerDelegate>{
    
    CLLocationManager * locationManager;
}
+(LBSLibrary *)sharedManager;
//城市列表的VC
+(UIViewController *)getCityListViewController;
@end
