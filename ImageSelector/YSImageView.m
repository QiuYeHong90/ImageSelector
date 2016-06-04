//
//  YSImageView.m
//  ImageSelector
//
//  Created by mac on 16/6/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "YSImageView.h"

@implementation YSImageView

- (instancetype)initWithFrame:(CGRect)frame WithBlock:(void(^)(YSImageView* img,UIButton* btn))block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        float btW = 24;
        _button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(frame)-btW, 0, btW, btW )];
        _button.backgroundColor = [UIColor blackColor];
        [self addSubview:_button];
        
        [_button addTarget:self action:@selector(buttocClick:) forControlEvents:UIControlEventTouchUpInside];
        self.buttClickBlock = block;
        
    }
    return self;
}
-(void)buttocClick:(UIButton*)butn
{
    self.buttClickBlock(self,butn);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
