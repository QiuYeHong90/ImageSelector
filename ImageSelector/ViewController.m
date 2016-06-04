//
//  ViewController.m
//  ImageSelector
//
//  Created by mac on 16/6/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "YSImageView.h"
#import "YSPictureSelector.h"
@interface ViewController ()<YSPictureSelectorDataSource,YSPictureSelectorDelegate>
{
    YSPictureSelector * _picSec ;
    NSMutableArray * _dataArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _dataArray = [[NSMutableArray alloc]init];
    for (int i =0; i<5; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"drink_%02d.jpg",i+1]];
        [_dataArray addObject:image];
    }
    _picSec = [[YSPictureSelector alloc]initWithFrame:CGRectMake(5, 100, CGRectGetWidth(self.view.frame)-10,CGRectGetWidth(self.view.frame)) WithDeleteimgName:@"more_weibo@2x.png" AddBtnImageName:@"more_weibo@2x.png"];
    _picSec.dataSource = self;
    _picSec.delegate = self;
    [_picSec.addBtn setBackgroundImage:[UIImage imageNamed:@"more_weibo"] forState:UIControlStateNormal];
    [_picSec.addBtn addTarget:self action:@selector(buttonCLik) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_picSec];
    
    
}


//添加
-(void)buttonCLik
{
    
    UIImage * image = [UIImage imageNamed:@"drink_01.jpg"];
    [_dataArray addObject:image];
    [_picSec reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [_picSec setNeedsLayout];
}
-(NSInteger)pictureSelector:(YSPictureSelector*)pictureSelectorNumberOfImageView
{
    return _dataArray.count;
}
-(UIImage*)pictureSelector:(YSPictureSelector*)pictureSelector ImageForItemIndex:(int)index
{
    return _dataArray[index];
}
//删除
-(void)pictureSelector:(YSPictureSelector*)pictureSelector delegateItemAtIndex:(NSInteger)index
{
    
    [_dataArray removeObjectAtIndex:index];
    [pictureSelector reloadData];
}

//移动
-(void)pictureSelector:(YSPictureSelector *)pictureSelector MoveItemAtIndex:(NSInteger)index DistanceIndex:(NSInteger)distanceIndex
{
     UIImage * image  = _dataArray[index];
    [_dataArray removeObjectAtIndex:index];
    [_dataArray insertObject:image atIndex:distanceIndex];
    [pictureSelector reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
