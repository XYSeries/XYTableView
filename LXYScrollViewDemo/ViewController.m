//
//  ViewController.m
//  LXYScrollViewDemo
//
//  Created by 刘学阳 on 2017/9/14.
//  Copyright © 2017年 刘学阳. All rights reserved.
//

#import "ViewController.h"
#import "LXYScrollView.h"
@interface ViewController ()<LXYScrollViewDelegate,LXYScrollViewDataSource>
@property (nonatomic, strong) LXYScrollView *myScrollView;

//下面是创建scrollView的方法
- (void)createScrollView;
@end

@implementation ViewController
//下面是创建scrollView的方法
- (void)createScrollView
{
    _myScrollView = [[LXYScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width , 200) orientationType:LXYScrollViewOrientationPortrait];
    _myScrollView.delegate = self;
    _myScrollView.dataSource = self;
    [self.view addSubview:_myScrollView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createScrollView];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}
- (void)tapAction
{
    [self.myScrollView reloadData];
}
- (NSInteger)numberOfRowsInScrollView:(LXYScrollView *)scrollView
{
    return 10;
}

- (LXYScrollViewCell *)scrollView:(LXYScrollView *)scrollView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    LXYScrollViewCell *cell = [scrollView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[LXYScrollViewCell alloc]initWithReuseIdentifier:cellId indexPath:indexPath];
    }
    switch (indexPath.row) {
        case 0:
            cell.backgroundColor = [UIColor redColor];
            break;
        case 1:
            cell.backgroundColor = [UIColor blueColor];
            break;
        case 2:
            cell.backgroundColor = [UIColor grayColor];
            break;
        case 3:
            cell.backgroundColor = [UIColor greenColor];
            break;
        case 4:
            cell.backgroundColor = [UIColor brownColor];
            break;
        case 5:
            cell.backgroundColor = [UIColor yellowColor];
            break;
        case 6:
            cell.backgroundColor = [UIColor blackColor];
            break;
        case 7:
            cell.backgroundColor = [UIColor brownColor];
            break;
        case 8:
            cell.backgroundColor = [UIColor lightGrayColor];
            break;
        case 9:
            cell.backgroundColor = [UIColor purpleColor];
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGFloat)scrollView:(LXYScrollView *)scrollView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 100;
    if (indexPath.row == 1 || indexPath.row == 3) {
        height = 50;
    }
    return height;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
