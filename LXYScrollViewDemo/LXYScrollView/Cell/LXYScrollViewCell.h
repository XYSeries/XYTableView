//
//  LXYScrollViewCell.h
//  LXYScrollViewDemo
//
//  Created by 刘学阳 on 2017/9/14.
//  Copyright © 2017年 刘学阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
typedef NS_ENUM(NSInteger, LXYScrollViewOrientation) {
    LXYScrollViewOrientationLandscape = 0, //横向
    LXYScrollViewOrientationPortrait,  //竖向
};
@interface LXYScrollViewCell : UIView
@property (nonatomic, strong, nonnull) NSIndexPath *indexPath;
@property (nonatomic, strong, nonnull) NSString *reuseIdentifier;
@property (nonatomic, assign) LXYScrollViewOrientation orientationType;

- (instancetype _Nullable )initWithReuseIdentifier:(nullable NSString *)reuseIdentifier indexPath:(NSIndexPath *_Nullable)indexPath;
@end
