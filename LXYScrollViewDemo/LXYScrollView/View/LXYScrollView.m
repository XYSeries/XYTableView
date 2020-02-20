//
//  LXYScrollView.m
//  LXYScrollViewDemo
//
//  Created by 刘学阳 on 2017/9/14.
//  Copyright © 2017年 刘学阳. All rights reserved.
//

#import "LXYScrollView.h"
//typedef NS_ENUM(NSInteger, LXYScrollingDirection) {
//    LXYScrollingDirectionLeft = 0,
//    LXYScrollingDirectionRight,
//    LXYScrollingDirectionUp,
//    LXYScrollingDirectionDown
//};
@interface LXYScrollView()
{
    id <LXYScrollViewDelegate> _delegate;
}
//可重用个数
@property (nonatomic, assign) NSInteger reuseCount;
//用于存放cell的字典
@property (nonatomic, strong) NSMutableDictionary *reuseableCellInfo;

// 允许多选情况下返回的 indexPath
@property (nonatomic, strong, nullable) NSArray<NSIndexPath *> *indexPathsForSelectedRows;
// 获取可见的单元格
@property (nonatomic, strong, nullable) NSMutableArray<__kindof LXYScrollViewCell*> *visibleCells;
// 获取可见行的 indexPath
@property (nonatomic, strong, nullable) NSArray<NSIndexPath *> *indexPathsForVisibleRows;
// 滑动方向
//@property (nonatomic, assign) LXYScrollingDirection scrollingDirection;

//当前要刷新的indexPath的数组
@property (nonatomic, strong) NSMutableArray *curRefrishIndexPaths;

/**
 * 根据最小行高设置重用个数
 * @param minRowHeight 最小行高
 */
- (void)setReuseCountWithMinRowHeigh:(CGFloat)minRowHeight;

/**
 * 根据总行高设置 contentSize
 * @param sumRowHeight 总行高
 */
- (void)setContentSizeWithSumRowHeight:(CGFloat)sumRowHeight;

@end
@implementation LXYScrollView
@dynamic delegate;

#pragma mark - public method -
- (instancetype)initWithFrame:(CGRect)frame orientationType:(LXYScrollViewOrientation)type
{
    self = [self initWithFrame:frame];
    if (self) {
        self.bounces = YES;
        _orientationType = type;
//        if (_orientationType == LXYScrollViewOrientationLandscape) {//横向 默认往左滑动
//            _scrollingDirection = LXYScrollingDirectionLeft;
//        }else{ // 竖向 默认向上滑动
//            _scrollingDirection = LXYScrollingDirectionUp;
//        }
    }
    return self;
}

- (LXYScrollViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    LXYScrollViewCell *cell = nil;
    NSMutableArray<LXYScrollViewCell*> *cells = self.reuseableCellInfo[identifier];
    
    if (!cells) {
        cells = [[NSMutableArray alloc]init];
        [self.reuseableCellInfo setObject:cells forKey:identifier];
    }else{
        if (cells.count > 0) {
            cell = cells[0];
            [self removeCellFromReuseQueue:cell];
            cell.orientationType = self.orientationType;
            NSLog(@"self.reuseableCellInfo111:%@ -- cell1111:%@",self.reuseableCellInfo,cell);
        }
        
    }
    NSLog(@"self.reuseableCellInfo:%@ -- cell:%@",self.reuseableCellInfo,cell);
    return cell;
}

- (void)reloadData
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfRowsInScrollView:)])
    {
        _numberOfRows = [_dataSource numberOfRowsInScrollView:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(scrollView: heightForRowAtIndexPath:)])
    {
        CGFloat minRowHeight = 0;
        CGFloat sumRowHeight = 0;
        for (NSInteger i = 0; i < _numberOfRows; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            CGFloat rowHeight = [_delegate scrollView:self heightForRowAtIndexPath:indexPath];
            if (i == 0)
            {
                minRowHeight = rowHeight;
            }
            if (minRowHeight > rowHeight)
            {
                minRowHeight = rowHeight;
            }
            sumRowHeight += rowHeight;
        }
        
        [self setContentSizeWithSumRowHeight:sumRowHeight];
        [self setReuseCountWithMinRowHeigh:minRowHeight];
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(scrollView: cellForRowAtIndexPath:)])
           {
               CGRect visibleRect = self.bounds;
               self.indexPathsForVisibleRows = [self indexPathsForRowsInRect:visibleRect];
               [self reloadRowsAtIndexPaths:self.indexPathsForVisibleRows];
           }

    }

}
- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *_Nullable)indexPaths
{
    
    for (NSInteger i = 0; i < indexPaths.count; i++)
    {
        NSIndexPath *indexPath = indexPaths[i];
        if ([self.indexPathsForVisibleRows containsObject:indexPath])
        {
           LXYScrollViewCell *cell = [_dataSource scrollView:self cellForRowAtIndexPath:indexPath];
            if (![self.visibleCells containsObject:cell]) {
                [self.visibleCells addObject:cell];
            }
            cell.indexPath = indexPath;
            [self addSubview:cell];
            cell.frame = [self rectForRowAtIndexPath:indexPath];
            
        }
    }
 
     NSLog(@"self.visibleCells:%ld",self.visibleCells.count);
}
/**
 * 获取某个cell 返回可视范围内的cell 超过范围的返回nil
 * @param indexPath indexPath 需要修改
 */
- (nullable __kindof LXYScrollViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.indexPathsForVisibleRows containsObject:indexPath])
    {
        return nil;
    }
    LXYScrollViewCell *theCell = nil;
    for (NSInteger i = 0; i < self.visibleCells.count; i++)
    {
        LXYScrollViewCell *cell = self.visibleCells[i];
        if ([cell.indexPath isEqual:indexPath])
        {
            theCell = cell;
            break;
        }
    }
    return theCell;
}
- (CGRect)rectForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath
{
    CGFloat sumHeight = 0;
    CGFloat origin = 0;
    CGFloat theRowHeight = 0;
    for (NSInteger i = 0; i <= indexPath.row; i++)
    {
        NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CGFloat rowHeight = [_delegate scrollView:self heightForRowAtIndexPath:theIndexPath];
        sumHeight += rowHeight;
        if (i == indexPath.row) {
            origin = sumHeight - rowHeight;
            theRowHeight = rowHeight;
            break;
        }
        
    }
    CGRect rect;
    if (_orientationType == LXYScrollViewOrientationLandscape) //如果横向
    {
        rect = CGRectMake(origin, 0, theRowHeight, CGRectGetHeight(self.frame));
    }else{ //竖向
        rect = CGRectMake(0, origin, CGRectGetWidth(self.frame), theRowHeight);
    }
    return rect;

}
//如果无效返回nil
- (nullable NSArray<NSIndexPath *> *)indexPathsForRowsInRect:(CGRect)rect
{
    NSMutableArray *rows = [[NSMutableArray alloc]init];
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    for(NSInteger i = 0; i < _numberOfRows; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
        CGPoint leadPoint ,tailPoint;
        if (_orientationType == LXYScrollViewOrientationLandscape) //如果横向
        {
            leadPoint = cellRect.origin;
            tailPoint = CGPointMake(CGRectGetMaxX(cellRect), 0);
            if (tailPoint.x > minX && tailPoint.x < maxX)
            {
                [rows addObject:indexPath];
            }else if (leadPoint.x > minX && leadPoint.x < maxX){
                [rows addObject:indexPath];
                break;
            }
            
        }else{ //竖向
            leadPoint = cellRect.origin;
            tailPoint = CGPointMake(0, CGRectGetMaxY(cellRect));
            if (tailPoint.y > minY && tailPoint.y < maxY)
            {
                [rows addObject:indexPath];
            }else if (leadPoint.y > minY && leadPoint.y < maxY){
                [rows addObject:indexPath];
                break;
            }
        }

    }
    return [rows copy];
}
#pragma mark - private method -
/**
 * 根据最小行高设置重用个数
 * @param minRowHeight 最小行高
 */
- (void)setReuseCountWithMinRowHeigh:(CGFloat)minRowHeight
{
    CGFloat scrollHeight = 0;
    if (_orientationType == LXYScrollViewOrientationLandscape) //如果横向
    {
        scrollHeight = self.frame.size.width;
    }else{ //竖向
        scrollHeight = self.frame.size.height;
    }

    _reuseCount = ceilf(scrollHeight / minRowHeight) + 1;
}
/**
 * 根据总行高设置 contentSize
 * @param sumRowHeight 总行高
 */
- (void)setContentSizeWithSumRowHeight:(CGFloat)sumRowHeight
{
    if (_orientationType == LXYScrollViewOrientationLandscape) //如果横向
    {
        self.contentSize = CGSizeMake(sumRowHeight, 0);
    }else{ //竖向
        self.contentSize = CGSizeMake(0, sumRowHeight);
    }

}

#pragma mark - setter method -
- (void)setDelegate:(id<LXYScrollViewDelegate>)delegate
{
    _delegate = delegate;
    [super setDelegate:_delegate];
    if (_dataSource) {
        [self reloadData];
    }
    
}
- (void)setDataSource:(id<LXYScrollViewDataSource>)dataSource
{
    _dataSource = dataSource;
    if (_delegate) {
        [self reloadData];
    }
}

#pragma mark - getter method -
- (NSMutableDictionary *)reuseableCellInfo
{
    if (!_reuseableCellInfo) {
        _reuseableCellInfo = [[NSMutableDictionary alloc]init];
    }
    return _reuseableCellInfo;
}
//返回可视的单元格
- (NSMutableArray<LXYScrollViewCell *> *)visibleCells
{
    if (!_visibleCells) {
        _visibleCells = [[NSMutableArray alloc]init];
    }
    
    return  _visibleCells;
}
- (NSMutableArray<NSIndexPath *> *)curRefrishIndexPaths
{
    if (!_curRefrishIndexPaths) {
        _curRefrishIndexPaths = [[NSMutableArray alloc]init];
    }
    return _curRefrishIndexPaths;
}

#pragma mark - event method -
- (void)addCellToReuseQueue:(LXYScrollViewCell *)cell
{
    NSMutableArray<LXYScrollViewCell * > *cells = self.reuseableCellInfo[cell.reuseIdentifier];
    [cells addObject:cell];
    
}
- (void)removeCellFromReuseQueue:(LXYScrollViewCell *)cell
{
        
    NSMutableArray<LXYScrollViewCell * > *cells = self.reuseableCellInfo[cell.reuseIdentifier];
    [cells removeObject:cell];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect visibleRect = self.bounds;
    NSArray *newVisibleRows  = [self indexPathsForRowsInRect:visibleRect];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" NOT (SELF in %@)",self.indexPathsForVisibleRows];
    self.curRefrishIndexPaths = [[newVisibleRows filteredArrayUsingPredicate:predicate] mutableCopy];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@" NOT (SELF in %@)",newVisibleRows];
    NSArray *outScreenIndexPaths = [[self.indexPathsForVisibleRows filteredArrayUsingPredicate:predicate2] mutableCopy];
    if (outScreenIndexPaths.count > 0) {
             NSLog(@" -- outScreenIndexPaths:%@ -- newVisibleRows:%@ -- self.indexPathsForVisibleRows:%@,",outScreenIndexPaths,newVisibleRows,self.indexPathsForVisibleRows);
        }
        if (self.curRefrishIndexPaths.count > 0) {
            NSLog(@"self.curRefrishIndexPaths:%@ -- newVisibleRows:%@ -- self.indexPathsForVisibleRows:%@",self.curRefrishIndexPaths,newVisibleRows,self.indexPathsForVisibleRows);
        }
    if (outScreenIndexPaths.count > 0) {
        for (NSInteger i = 0; i < self.visibleCells.count; i++) {
            LXYScrollViewCell *cell = self.visibleCells[i];
                
            for (NSInteger j = 0; j < outScreenIndexPaths.count; j++)
            {
                NSIndexPath *outIndexPath = outScreenIndexPaths[j];
                if ([cell.indexPath isEqual:outIndexPath]) {
                    [self addCellToReuseQueue:cell];
                    [self.visibleCells removeObject:cell];
                    NSLog(@"remove");
                    i--;
                }
            }
                
        }
    }
    
        
    self.indexPathsForVisibleRows = newVisibleRows;
        
    [self reloadRowsAtIndexPaths:_curRefrishIndexPaths];
}

@end
