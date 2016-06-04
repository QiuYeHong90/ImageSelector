//
//  YSImageView.h
//  ImageSelector
//
//  Created by mac on 16/6/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSImageView : UIImageView
@property (nonatomic,strong)UIButton * button;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) NSInteger startIndex;
@property (nonatomic,assign) NSInteger endIndex;
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGPoint startCenter;
@property (nonatomic,assign) CGPoint endPoint;


@property (nonatomic,copy) void (^buttClickBlock)(YSImageView*,UIButton*);
- (instancetype)initWithFrame:(CGRect)frame WithBlock:(void(^)(YSImageView* img,UIButton* btn))block;
@end
