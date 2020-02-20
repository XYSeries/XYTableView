//
//  LXYScrollViewCell.m
//  LXYScrollViewDemo
//
//  Created by 刘学阳 on 2017/9/14.
//  Copyright © 2017年 刘学阳. All rights reserved.
//

#import "LXYScrollViewCell.h"

@implementation LXYScrollViewCell
- (instancetype _Nullable )initWithReuseIdentifier:(nullable NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        _indexPath = indexPath;
    
        
    }
    return self;
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSString *descr = [NSString stringWithFormat:@"%@ -- indexPath:%@",self,self.indexPath];
    return descr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
