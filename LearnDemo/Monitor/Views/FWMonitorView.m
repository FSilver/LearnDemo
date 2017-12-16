//
//  FWMonitorView.m
//  LearnDemo
//
//  Created by Lizhi on 2017/12/15.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import "FWMonitorView.h"
#import "FWMonitorMgr.h"


typedef enum {
    ViewStatusPanel = 1,
    ViewStatusTable = 2,
    ViewStatusText = 3
}ViewStatus;

@interface  FWMonitorView()<UITableViewDelegate,UITableViewDataSource>
{
    //Moved
    BOOL _canMove;
    CGPoint _lastPoint;
    
    //性能面板
    UILabel *_panelLabel;
    
    //卡顿tableView
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    //UITextView
    UITextView *_textView;
    
    //status
    ViewStatus _status;
}
@end

@implementation FWMonitorView

+(instancetype)monitor
{
    FWMonitorView  *view = [[FWMonitorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-120, 100, 120, 80)];
    return view;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self)return nil;
    _status = ViewStatusPanel;
    [self createTableView];
    [self cteatTextView];
    [self createLabel];
    [self start];
    return self;
}

#pragma mark  - careteViews

-(void)createLabel
{
    _panelLabel = [[UILabel alloc]initWithFrame:self.bounds];
    _panelLabel.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.2];
    _panelLabel.numberOfLines = 0;
    _panelLabel.font = [UIFont systemFontOfSize:16];
    _panelLabel.userInteractionEnabled = YES;
    [self addSubview:_panelLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked)];
    tap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tap];
    
}

-(void)tapClicked
{
    switch (_status) {
        case ViewStatusPanel:
        {
            _tableView.hidden = NO;
            _textView.hidden = YES;
            _status = ViewStatusTable;
        }
            break;
        case ViewStatusTable:
        {
            _tableView.hidden = YES;
            _textView.hidden = YES;
            _status = ViewStatusPanel;
        }
            break;
        case ViewStatusText:
        {
            _tableView.hidden = NO;
            _textView.hidden = YES;
            _status = ViewStatusTable;
        }
            break;
            
        default:
            break;
    }
    _tableView.frame = self.superview.bounds;
    _textView.frame = self.superview.bounds;
    [self.superview addSubview:_tableView];
    [self.superview addSubview:_textView];
    [self.superview addSubview:self];
}

#pragma mark  - tableView

-(void)createTableView
{
    _dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    _tableView.backgroundColor = [UIColor redColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FWANRInfoTableCell"];
    _tableView.separatorColor = [UIColor redColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FWANRInfoTableCell" forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines = 0;
    NSString *anrStr = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = anrStr;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *anrStr = [_dataArray objectAtIndex:indexPath.row];
    _textView.text = anrStr;
    _textView.hidden = NO;
}

#pragma mark  - textView
-(void)cteatTextView
{
    _textView = [[UITextView alloc]init];
    _textView.editable = NO;
    _textView.hidden = YES;
    _status = ViewStatusText;
}

#pragma mark  - 接入数据
-(void)start {
    
    FWMonitorMgr *mgr = [FWMonitorMgr sharedInstance];
    [mgr reciveInfo:^(FWPerformanceInfo *info) {
        [self updateWithInfo:info];
    }];
    [mgr reciveANR:^(NSArray *anrs) {
        [self updateANR:anrs];
    }];
    [mgr start];
}

-(void)updateWithInfo:(FWPerformanceInfo*)info
{
    _panelLabel.text = [info descriptionInMultiLines];
}

-(void)updateANR:(NSArray*)array
{
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:array];
    [_tableView reloadData];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
}


@end
