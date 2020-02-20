//
//  LXYScrollView.h
//  LXYScrollViewDemo
//
//  Created by 刘学阳 on 2017/9/14.
//  Copyright © 2017年 刘学阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXYScrollViewCell.h"

@class LXYScrollView;
@protocol LXYScrollViewDelegate <NSObject, UIScrollViewDelegate>

@optional
- (CGFloat)scrollView:(LXYScrollView *_Nullable)scrollView heightForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;

- (void)scrollView:(LXYScrollView *_Nullable)scrollView didSelectRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;

- (void)scrollView:(LXYScrollView *_Nullable)scrollView didDeselectRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;
@end

@protocol LXYScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfRowsInScrollView:(LXYScrollView *_Nullable)scrollView;

- (LXYScrollViewCell *_Nullable)scrollView:(LXYScrollView *_Nullable)scrollView cellForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;

@end


@interface LXYScrollView : UIScrollView
// orientationType 分横向 和 竖向
@property (nonatomic, readonly) LXYScrollViewOrientation orientationType;
@property (nonatomic, weak, nullable) id <LXYScrollViewDelegate> delegate;
@property (nonatomic, weak, nullable) id <LXYScrollViewDataSource> dataSource;

// 返回的行数
@property (nonatomic, readonly) NSInteger numberOfRows;
// default is NO. Controls whether multiple rows can be selected simultaneously
@property (nonatomic, assign) BOOL allowsMultipleSelection;
// 允许多选情况下返回的 indexPath
//@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *indexPathsForSelectedRows;
// 获取可见的单元格
@property (nonatomic, readonly, nullable) NSMutableArray<__kindof LXYScrollViewCell *> *visibleCells;
// 获取可见行的 indexPath
@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *indexPathsForVisibleRows;

- (instancetype _Nullable )initWithFrame:(CGRect)frame orientationType:(LXYScrollViewOrientation)type;


- (nullable __kindof LXYScrollViewCell *)dequeueReusableCellWithIdentifier:(NSString *_Nullable)identifier;
- (void)reloadData;

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *_Nullable)indexPaths;

/**
 * 获取某个cell
 * 如果超过
 * @param indexPath indexPath
 */
- (nullable __kindof LXYScrollViewCell *)cellForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;
//如果无效 返回nil
- (nullable NSArray<NSIndexPath *> *)indexPathsForRowsInRect:(CGRect)rect;
@end
