//
//  ViewController.m
//  01-索引表
//
//  Created by qingyun on 15/12/4.
//  Copyright (c) 2015年 阿六. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) NSArray *keys;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDictFromFile];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    //设置数据源和代理
    tableView.dataSource = self;
    tableView.delegate = self;
    //当行数超过sectionIndexMinimumDisplayRowCount的时候显示右边的索引
    tableView.sectionIndexMinimumDisplayRowCount = 1000;
    //设置索引的颜色
    tableView.sectionIndexColor = [UIColor cyanColor];
    //设置背景颜色
    tableView.sectionIndexBackgroundColor = [UIColor lightGrayColor];
    
}
- (void)loadDictFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sortednames" ofType:@"plist"];
    _dict = [NSDictionary dictionaryWithContentsOfFile:path];
    //取出字典中所有的键
    NSArray *keys = _dict.allKeys;
    //对取出的keys重新排序
    _keys = [keys sortedArrayUsingSelector:@selector(compare:)];
}
#pragma mark - UITableViewDataSource
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _keys.count;
}
//每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //先取出section对应的key
    NSString *key = _keys[section];
    //取section对应的数组
    NSArray *array = _dict[key];
    return array.count;
}
//每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *key = _keys[indexPath.section];
    NSArray *array = _dict[key];
    cell.textLabel.text = array[indexPath.row];
    return cell;
    
}
//section的头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _keys[section];
}
//设置索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}
// 当点击索引条上的相关字母后，返回相应的section索引
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
