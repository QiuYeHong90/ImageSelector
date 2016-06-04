//
//  YSPictureSelector.m
//  ImageSelector
//
//  Created by mac on 16/6/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "YSPictureSelector.h"
#import "YSImageView.h"
@implementation YSPictureSelector
- (instancetype)initWithFrame:(CGRect)frame WithDeleteimgName:(NSString *)deleteImgeName AddBtnImageName:(NSString*)addBtnImageName
{
    self = [super initWithFrame:frame];
    if (self) {
        _appearImgArray = [[NSMutableArray alloc]init];
        _AllImageViewAarray = [[NSMutableArray alloc]init];
        _pointArray = [[NSMutableArray alloc]init];
        _addBtn = [[UIButton alloc]init];
        _addBtn.backgroundColor = [UIColor blueColor];
        _addBtn.hidden = YES;
        [_addBtn setBackgroundImage:[UIImage imageNamed:addBtnImageName] forState:UIControlStateNormal];
        [_addBtn addTarget: self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addBtn];
        
        for (int i = 0; i<9; i++) {
            
            float imgW = CGRectGetWidth(frame)/3-5;
            YSImageView * imageView = [[YSImageView alloc]initWithFrame:CGRectMake((imgW+5)*(i%3), (imgW+5)*(i/3), imgW, imgW) WithBlock:^(YSImageView *img, UIButton *btn) {
                img.hidden = YES;
                
                [self btnDlegate:img];
            }];
            [imageView.button setBackgroundImage:[UIImage imageNamed:deleteImgeName] forState:UIControlStateNormal];
            UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPress:)];
            [imageView addGestureRecognizer:longPress];
            imageView.hidden = YES;
            imageView.backgroundColor = [UIColor redColor];
            [self addSubview:imageView];
            NSValue * poitValue = [NSValue valueWithCGPoint:imageView.center];
            [_pointArray addObject:poitValue];
            [_AllImageViewAarray addObject:imageView];
        }
    }
    return self;
}

#pragma mark --添加项目按钮
-(void)addClick
{
    //调协议方法
    
}



-(void)addSubview:(UIView *)view
{
    [super addSubview:view];
    
}

-(void)LongPress:(UILongPressGestureRecognizer*)longPre
{
    YSImageView * imgView = (YSImageView*)longPre.view;
    NSLog(@"====%@",imgView);
    switch (longPre.state) {
        case UIGestureRecognizerStateBegan:
        {
            _isMove = YES;
            
//            imgView.transform = CGAffineTransformMakeScale(1.002,1.002);
            imgView.alpha = 0.5;
            imgView.startPoint = [longPre locationInView:self];
            imgView.startCenter = imgView.center;
            imgView.endPoint = imgView.center;
            
            imgView.endIndex = imgView.index;
            imgView.startIndex = imgView.index;
            [self bringSubviewToFront:imgView];
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint centerPoint = imgView.center;
            CGPoint point = [longPre locationInView:self];
            centerPoint.y = imgView.startCenter.y + point.y-imgView.startPoint.y;
            centerPoint.x = imgView.startCenter.x + point.x-imgView.startPoint.x;
            
            imgView.center = centerPoint;
             __block int isChange = -1;
            [_appearImgArray enumerateObjectsUsingBlock:^(YSImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj!=imgView) {
                    if (CGRectContainsPoint(obj.frame, imgView.center)) {
                        
                        isChange = (int)obj.index;
                        //交换位置
                        *stop = YES;
                    }
                }
            }];
            
            if (isChange != -1) {
                [_appearImgArray removeObject:imgView];
                [_appearImgArray insertObject:imgView atIndex:isChange];
//                YSImageView * chageImage  = _appearImgArray[isChange];
                imgView.endIndex = isChange;
                imgView.endPoint = [_pointArray[isChange] CGPointValue];
                
                [UIView animateWithDuration:0.3 animations:^{
                    [_appearImgArray enumerateObjectsUsingBlock:^(YSImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.index = idx;
                        if (obj!= imgView) {
                             obj.center = [_pointArray[idx] CGPointValue];
                        }
                        
                        
                    }];

                   
                }];
                
                
                
            }
            
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            
            
           imgView.center= imgView.endPoint ;
            longPre.view.alpha = 1;
            _isMove = NO;
            //更新数据移动
            if ([self.delegate respondsToSelector:@selector(pictureSelector:MoveItemAtIndex:DistanceIndex:)]) {
                [self.delegate pictureSelector:self MoveItemAtIndex:imgView.startIndex DistanceIndex:imgView.endIndex];

            }
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- 删除项目

-(void)btnDlegate:(YSImageView*)imgView
{
    _isMove = YES;
    _count = 0;
    [_appearImgArray removeObject:imgView];
    if (_appearImgArray.count == 0) {
        if ([self.delegate respondsToSelector:@selector(pictureSelector:delegateItemAtIndex:)]) {
             [self.delegate pictureSelector:self delegateItemAtIndex:imgView.index];
        }
       
    }
    
    
    [_appearImgArray enumerateObjectsUsingBlock:^(YSImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
         obj.index = idx;
         [self imageViewAnimationWithPoint:[_pointArray[idx] CGPointValue] imageView:obj index:imgView.index];
       
    }];
    //把索引传出去
    
    NSLog(@"===第%ld个被删除了",imgView.index);
    [self buttonChangeFrame];
    
    
}

-(void)buttonChangeFrame
{
    
    if (_appearImgArray.count==0||_appearImgArray.count==9) {
        _addBtn.hidden = YES;
    }else{
        
        YSImageView * imgView  = [_appearImgArray lastObject];
       _addBtn.hidden = NO;
        
      
      
       
        [UIView animateWithDuration:0.3 animations:^{
              float imgW = CGRectGetWidth(self.frame)/3-5;
            _addBtn.frame =CGRectMake((imgW+5)*((imgView.index+1)%3), (imgW+5)*((imgView.index+1)/3), imgW, imgW);
            
        }];
    }
}

-(void)reloadData
{
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //获取数据的数量
    if (_isMove == NO) {
        _number  = [self.dataSource pictureSelector:self];
        [_appearImgArray removeAllObjects];
        
        [_AllImageViewAarray enumerateObjectsUsingBlock:^(YSImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //先全部隐藏 为了防止再次刷新
            obj.hidden = YES;
            if (idx<_number) {
                UIImage *img = [self.dataSource pictureSelector:self ImageForItemIndex:idx];
                obj.hidden = NO;
                if (![_appearImgArray containsObject:obj]) {
                    
                    
                    [_appearImgArray addObject:obj];
                    obj.index = idx;
                    
                    obj.image = img;
                    obj.center
                    = [_pointArray[idx] CGPointValue];
                    
                }
            }else{
                *stop = YES;
            }
            
        }];
        [self buttonChangeFrame];

    }
   //    if (_appearImgArray.count==0) {
//        _addBtn.frame = CGRectZero;
//    }else{
//         YSImageView * imgView  = [_appearImgArray lastObject];
//        _addBtn.bounds = imgView.bounds;
//        _addBtn.center = CGPointMake(imgView.center.x+ CGRectGetWidth(imgView.frame)+5, imgView.center.y);
//    }
  
    
    
}

-(void)imageViewAnimationWithPoint:(CGPoint)point imageView:(YSImageView*)imageView index:(NSInteger)index
{
    [UIView animateWithDuration:0.3 animations:^{
        imageView.center = point;
    } completion:^(BOOL finished) {
        if (_count==_appearImgArray.count-1) {
            _isMove = NO;
            if ([self.delegate respondsToSelector:@selector(pictureSelector:delegateItemAtIndex:)]) {
                [self.delegate pictureSelector:self delegateItemAtIndex:index];
            }
            
            NSLog(@"=========");
        }
        _count ++;
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
