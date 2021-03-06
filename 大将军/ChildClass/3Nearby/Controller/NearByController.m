//
//  NearByController.m
//  大将军
//
//  Created by 郑晋洋 on 16/7/6.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "NearByController.h"
#import "LocalDogListViewController.h"
#import "MAMutablePolyline.h"
#import "MAMutablePolylineView.h"
#import "MepRecord.h"
#import "FileHelper.h"
#import "RecordViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface NearByController ()<MAMapViewDelegate, AMapNearbySearchManagerDelegate, AMapSearchDelegate>{
    CLLocation *_currentLocation;
    AMapNearbySearchManager *_nearbyManager;
    AMapSearchAPI *_search;
}

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIButton *locationBtn;
@property (nonatomic, strong) UIBarButtonItem *rightBtn;
@property (nonatomic, strong) NSMutableArray *annoArr;
@property (nonatomic, strong) UIButton *tdBtn;
@property (nonatomic, strong) UIButton *startBtn;


@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) MAMutablePolyline *mutablePolyline;
@property (nonatomic, strong) MAMutablePolylineView *mutableView;
@property (nonatomic, strong) NSMutableArray *locationsArray;
@property (nonatomic, strong) MepRecord *currentRecord;
@property (nonatomic, strong) UIButton *recordBtn;

@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UILabel *distanceLable;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *distance;

@end

@implementation NearByController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView removeAnnotations:self.annoArr];
    self.annoArr = nil;
    _isRecording = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"将军府" style:(UIBarButtonItemStyleDone) target:self action:@selector(didLeftBtn)];
    
}

- (void)didLeftBtn {
    if ([self.delegate respondsToSelector:@selector(NearbyClickLeftBtn)]) {
        [self.delegate NearbyClickLeftBtn];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [AMapServices sharedServices].apiKey = @"b49a48a1dd3bc124ae01778a3ecc22c4";
    self.view.backgroundColor = [UIColor colorWithRed:16 / 255.0 green:168 / 255.0 blue:173 / 255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = BACKGROUNDCOLOR;
    [self.navigationController.navigationBar setTintColor:COLOR(255, 255, 255)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR(250, 205, 174),NSFontAttributeName:[UIFont boldSystemFontOfSize:28]}];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.locationBtn];
    [self.view addSubview:self.tdBtn];
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.timeLable];
    [self.view addSubview:self.distanceLable];
    [self.view addSubview:self.time];
    [self.view addSubview:self.distance];
    [self.navigationItem setRightBarButtonItem:self.rightBtn animated:YES];
    [self.view addSubview:self.recordBtn];
    [self initNearBySearch];
    [self initLocationsArray];
    [self initOverlay];
    
}

#pragma mark -- Init

- (void)initOverlay {
    self.mutablePolyline = [[MAMutablePolyline alloc] initWithPoints:@[]];
}

//配置附近搜索
- (void)initNearBySearch {
    _nearbyManager = [AMapNearbySearchManager sharedInstance];
    _nearbyManager.delegate = self;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
}

- (void)initLocationsArray{
    
    self.locationsArray = [NSMutableArray array];
    
}

#pragma mark -- Getter

- (MAMapView *)mapView {
    
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _mapView.delegate = self;
        _mapView.showsCompass = YES;
        _mapView.compassOrigin = CGPointMake(SCREEN_WIDTH * 12 / 14, SCREEN_HEIGHT / 8);
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.skyModelEnable = YES;
        _mapView.pausesLocationUpdatesAutomatically = NO;
        _mapView.allowsBackgroundLocationUpdates    = YES;
        _mapView.distanceFilter = 10;
        _mapView.desiredAccuracy =kCLLocationAccuracyNearestTenMeters;
        
        
//        _mapView.centerCoordinate = CLLocationCoordinate2DMake(_mapView.userLocation.location.coordinate.latitude, _mapView.userLocation.location.coordinate.longitude);
    }
    
    return _mapView;
    
}

- (UIButton *)locationBtn {
    if (!_locationBtn) {
        _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationBtn.frame = CGRectMake(10, SCREEN_HEIGHT * 5 / 6, 35, 35);
        _locationBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _locationBtn.layer.cornerRadius = 5;
        _locationBtn.backgroundColor = [UIColor whiteColor];
        
        [_locationBtn addTarget:self action:@selector(action_LocPressed) forControlEvents:UIControlEventTouchUpInside];
        [_locationBtn setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateNormal];
    }
    return _locationBtn;
}

- (UIButton *)tdBtn {
    if (!_tdBtn) {
        _tdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tdBtn.frame = CGRectMake(10, SCREEN_HEIGHT * 5 / 6 - 45, 35, 35);
        _tdBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _tdBtn.layer.cornerRadius = 5;
        _tdBtn.backgroundColor = [UIColor whiteColor];
        
        [_tdBtn addTarget:self action:@selector(action_tdBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [_tdBtn setImage:[UIImage imageNamed:@"vr-3d"] forState:UIControlStateNormal];
    }
    return _tdBtn;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.frame = CGRectMake(self.view.bounds.size.width / 2 - 30, SCREEN_HEIGHT * 5 / 6 - 35, 60, 60);
        _startBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _startBtn.layer.cornerRadius = 30;
        _startBtn.backgroundColor = COLOR(254, 168, 195);
        
        [_startBtn setImage:[UIImage imageNamed:@"icon_play.png"] forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(action_startBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIBarButtonItem *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"附近的狗" style:UIBarButtonItemStylePlain target:self action:@selector(action_rightBtnPressed)];
    }
    return _rightBtn;
}

- (NSMutableArray *)annoArr {
    if (!_annoArr) {
        _annoArr = [[NSMutableArray alloc] init];
    }
    return _annoArr;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.frame = CGRectMake(SCREEN_WIDTH * 12 / 14, SCREEN_HEIGHT / 8 + 46, 36, 36);
        _recordBtn.layer.cornerRadius = 18;
        _recordBtn.backgroundColor = [UIColor whiteColor];
        [_recordBtn setImage:[UIImage imageNamed:@"记录"] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(action_recordBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (UILabel *)timeLable {
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.text = @"时间";
        _timeLable.font = [UIFont systemFontOfSize:28];
        _timeLable.frame = CGRectMake(30, self.view.bounds.size.height, 100, 44);
        _timeLable.textColor = [UIColor whiteColor];
    }
    return _timeLable;
}

- (UILabel *)distanceLable {
    if (!_distanceLable) {
        _distanceLable = [[UILabel alloc] init];
        _distanceLable.text = @"路程";
        _distanceLable.font = [UIFont systemFontOfSize:28];
        _distanceLable.frame = CGRectMake(self.view.bounds.size.width - 30 - 60, self.view.bounds.size.height, 100, 44);
        _distanceLable.textColor = [UIColor whiteColor];
    }
    return _distanceLable;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.text = [NSString stringWithFormat:@"%.2fs",[self.currentRecord totalDuration]];
        _time.frame = CGRectMake(30, self.view.bounds.size.height, 200, 30);
        _time.font = [UIFont systemFontOfSize:20];
        _time.textColor = [UIColor whiteColor];
        
//        NSString stringWithFormat:@"距离: %.2fm, 时间: %.2fs",  [self totalDistance], [self totalDuration]
    }
    return _time;
}

- (UILabel *)distance {
    if (!_distance) {
        _distance = [[UILabel alloc] init];
        _distance.text = [NSString stringWithFormat:@"%.2fm",[self.currentRecord totalDistance]];
        _distance.frame = CGRectMake(self.view.bounds.size.width - 30 - 60, self.view.bounds.size.height, 200, 30);
        _distance.font = [UIFont systemFontOfSize:20];
        _distance.textColor = [UIColor whiteColor];
    }
    return _distance;
}


#pragma mark -- Action

- (void)action_LocPressed {
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow) {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        //        [_mapView setZoomLevel:15 animated:YES];
    }
}

- (void)action_tdBtnPressed {
    
    if (_mapView.cameraDegree == 0) {
        [_mapView setCameraDegree:90 animated:YES duration:0.3];
    }else {
        [_mapView setCameraDegree:0 animated:YES duration:0.3];
    }
    
}

- (void)action_rightBtnPressed {
    //构造上传数据对象
    AMapNearbyUploadInfo *info = [[AMapNearbyUploadInfo alloc] init];
    info.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"];//业务逻辑id
    info.coordinateType = AMapSearchCoordinateTypeAMap;//坐标系类型
    info.coordinate = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);//用户位置信息
    if ([_nearbyManager uploadNearbyInfo:info]) {
        NSLog(@"yes");
    }else {
        NSLog(@"no");
    }
    [self.navigationController pushViewController:[[LocalDogListViewController alloc] init] animated:YES];
    
    //构造AMapNearbySearchRequest对象，配置周边搜索参数
    AMapNearbySearchRequest *request = [[AMapNearbySearchRequest alloc] init];
    request.center = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude longitude:_mapView.userLocation.coordinate.longitude];//中心点
    request.radius = 1000;//搜索半径
    request.timeRange = 1000;//查询的时间
    request.searchType = AMapNearbySearchTypeLiner;//驾车距离，AMapNearbySearchTypeLiner表示直线距离
    //发起附近周边搜索
    [_search AMapNearbySearch:request];
    
}

- (void)action_startBtnPressed {
    
    self.isRecording = !self.isRecording;
    
    self.rightBtn.title = @"";
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    if (self.isRecording) {
        [_startBtn setImage:[UIImage imageNamed:@"icon_stop.png"] forState:UIControlStateNormal];
//        [self.view addSubview:self.detailView];
        self.recordBtn.hidden = YES;
//        self.navigationItem.rightBarButtonItem= YES;
        [UIView animateWithDuration:0.6 animations:^{
            self.mapView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 3 / 4);
            self.tabBarController.tabBar.hidden = YES;
            self.locationBtn.frame = CGRectMake(10, self.view.bounds.size.height * 3 / 4 - 85, 35, 35);
            self.tdBtn.frame = CGRectMake(10, self.view.bounds.size.height * 3 / 4 - 130, 35, 35);
            self.timeLable.frame = CGRectMake(30, SCREEN_HEIGHT * 9 / 12, 100, 44);
            self.distanceLable.frame = CGRectMake(self.view.bounds.size.width - 30 - 60, SCREEN_HEIGHT * 9 / 12, 100, 44);
            self.time.frame = CGRectMake(30, SCREEN_HEIGHT * 13 / 15, 200, 30);
            self.distance.frame = CGRectMake(self.view.bounds.size.width - 30 - 60, SCREEN_HEIGHT * 13 / 15, 200, 30);
            
        } completion:^(BOOL finished) {
            
        }];
        if (self.currentRecord == nil) {
            self.currentRecord = [[MepRecord alloc] init];
        }
    }else {
        
        self.rightBtn.title = @"附近的狗";
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        [self saveRoute];
        
        [self.mutablePolyline removeAllPoints];
        
        [self.mutableView referenceDidChange];
        
        [_startBtn setImage:[UIImage imageNamed:@"icon_play.png"] forState:UIControlStateNormal];
        
        self.recordBtn.hidden = NO;
        
        [UIView animateWithDuration:0.6 animations:^{
            self.mapView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            self.tabBarController.tabBar.hidden = NO;
            self.locationBtn.frame = CGRectMake(10, SCREEN_HEIGHT * 5 / 6, 35, 35);
            self.tdBtn.frame = CGRectMake(10, SCREEN_HEIGHT * 5 / 6 - 45, 35, 35);
            self.timeLable.frame = CGRectMake(30, self.view.bounds.size.height, 100, 44);
            self.distanceLable.frame = CGRectMake(self.view.bounds.size.width - 30 - 60, self.view.bounds.size.height, 100, 44);
            self.time.frame = CGRectMake(30, self.view.bounds.size.height, 200, 30);
            self.distance.frame = CGRectMake(self.view.bounds.size.width - 30 - 60, self.view.bounds.size.height, 200, 30);
           
        } completion:^(BOOL finished) {
            self.recordBtn.hidden = NO;
        }];
        
    }
    
}

- (void)action_recordBtnPressed {
    
    UIViewController *recordController = [[RecordViewController alloc] initWithNibName:nil bundle:nil];
    recordController.title = @"遛狗记录";
    
    [self.navigationController pushViewController:recordController animated:YES];
}

#pragma mark -- MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated {
    // 修改定位按钮状态
    if (mode == 0) {
        [_locationBtn setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    }else {
        [_locationBtn setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateNormal];
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    //当前位置更新后，赋值
    _currentLocation = [userLocation.location copy];
    if (!updatingLocation) {
        return;
    }
    
    if (self.isRecording) {
        
        //构造上传数据对象
        AMapNearbyUploadInfo *info2 = [[AMapNearbyUploadInfo alloc] init];
        info2.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"];//业务逻辑id
        info2.coordinateType = AMapSearchCoordinateTypeAMap;//坐标系类型
        info2.coordinate = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);//用户位置信息
        if ([_nearbyManager uploadNearbyInfo:info2]) {
            NSLog(@"yes");
        }else {
            NSLog(@"no");
        }
        //构造AMapNearbySearchRequest对象，配置周边搜索参数
        AMapNearbySearchRequest *request2 = [[AMapNearbySearchRequest alloc] init];
        request2.center = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude longitude:_mapView.userLocation.coordinate.longitude];//中心点
        request2.radius = 1000;//搜索半径
        request2.timeRange = 500;//查询的时间
        request2.searchType = AMapNearbySearchTypeLiner;//驾车距离，AMapNearbySearchTypeLiner表示直线距离
        //发起附近周边搜索
        [_search AMapNearbySearch:request2];
        
        
        if (userLocation.location.horizontalAccuracy < 40 && userLocation.location.horizontalAccuracy > 0)
        {
            [self.locationsArray addObject:userLocation.location];
            
            
            [self.currentRecord addLocation:userLocation.location];
            
            [self.mutablePolyline appendPoint: MAMapPointForCoordinate(userLocation.location.coordinate)];
            
            [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
            
            [self.mapView addOverlay:self.mutablePolyline];
            
            [self.mutableView referenceDidChange];
        }
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAMutablePolyline class]])
    {
        MAMutablePolylineView *render = [[MAMutablePolylineView alloc] initWithMutablePolyline:overlay];
        render.lineWidth = 8.0;
        render.strokeColor = [UIColor orangeColor];
        _mutableView = render;
        return render;
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *identify = @"222";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identify];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identify];
        }
        annotationView.image = [UIImage imageNamed:@"猫狗"];
        annotationView.canShowCallout = YES;
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}



#pragma mark -- AMapSearchDelegate

- (void)onNearbySearchDone:(AMapNearbySearchRequest *)request response:(AMapNearbySearchResponse *)response
{
    if(response.infos.count == 0) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"哦，糟了" message:@"附近好像没有人遛狗哦~" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:sureAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"1" object:response.infos];
    for (AMapNearbyUserInfo *info in response.infos) {
        MAPointAnnotation *anno = [[MAPointAnnotation alloc] init];
        anno.title = info.userID;
        anno.coordinate = CLLocationCoordinate2DMake(info.location.latitude, info.location.longitude);
        
        [_mapView addAnnotation:anno];
        [_annoArr addObject:anno];
    }
    
}

#pragma mark -- Save Route
- (void)saveRoute {
    if (self.currentRecord == nil)
    {
        return;
    }
    
    NSString *name = self.currentRecord.title;
    NSString *path = [FileHelper filePathWithName:name];
    
    [NSKeyedArchiver archiveRootObject:self.currentRecord toFile:path];
    
    self.currentRecord = nil;
}



@end
