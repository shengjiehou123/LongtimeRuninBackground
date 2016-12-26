//
//  ViewController.m
//  定位
//
//  Created by 木子女乔 on 2016/12/26.
//  Copyright © 2016年 木子女乔. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"


@interface ViewController ()<CLLocationManagerDelegate>

@end

@implementation ViewController
{
    LocationManager *locationManager;
    NSTimer *timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initLocation];

}

- (void)initLocation
{
    locationManager = [LocationManager shareInstance];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [locationManager._locationManager requestAlwaysAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways){
        //设置代理
        locationManager._locationManager.delegate=self;
        //        //设置定位精度
        //        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //        //定位频率,每隔多少米定位一次
        //        CLLocationDistance distance= 0;//十米定位一次
        //        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [locationManager._locationManager startUpdatingLocation];
    }

}


#pragma mark  CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(printCurrentTime:) userInfo:nil repeats:YES];
    }
    
//    //如果不需要实时定位，使用完即使关闭定位服务
//    [_locationManager stopUpdatingLocation];
}


-(void)printCurrentTime:(id)sender{
    NSLog(@"当前的时间是---%@---",[self getCurrentTime]);
    
}


-(NSString *)getCurrentTime{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
    NSString *dateTime=[dateFormatter stringFromDate:[NSDate date]];
    return  dateTime;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
