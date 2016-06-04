//
//  YSPictureSelector.h
//  ImageSelector
//
//  Created by mac on 16/6/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSPictureSelector,YSImageView;

@protocol YSPictureSelectorDataSource <NSObject>
@required
-(NSInteger)pictureSelector:(YSPictureSelector*)pictureSelectorNumberOfImageView;
-(UIImage*)pictureSelector:(YSPictureSelector*)pictureSelector ImageForItemIndex:(int)index;
@end
@protocol YSPictureSelectorDelegate <NSObject>
@optional
//删除项目
-(void)pictureSelector:(YSPictureSelector*)pictureSelector delegateItemAtIndex:(NSInteger)index;
//移动的协议方法
-(void)pictureSelector:(YSPictureSelector*)pictureSelector MoveItemAtIndex:(NSInteger)index DistanceIndex:(NSInteger)distanceIndex;

@end
@interface YSPictureSelector : UIView
{
    NSInteger _number;
    NSInteger _count;
    BOOL _isMove;
}
@property (nonatomic,strong)NSMutableArray <YSImageView*>* AllImageViewAarray;
@property (nonatomic,strong)NSMutableArray <YSImageView*>*appearImgArray;
@property (nonatomic,strong)NSMutableArray <NSValue*>* pointArray;
@property (nonatomic,assign) id<YSPictureSelectorDataSource>dataSource;
@property(nonatomic,assign) id <YSPictureSelectorDelegate>delegate;
@property (nonatomic,strong) UIButton * addBtn;
@property (nonatomic,copy) NSString * deletBtnImageName;
@property (nonatomic,copy) NSString * addBtnImageName;
- (instancetype)initWithFrame:(CGRect)frame WithDeleteimgName:(NSString *)deleteImgeName AddBtnImageName:(NSString*)addBtnImageName;
-(void)reloadData;
@end
