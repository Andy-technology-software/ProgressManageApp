//
//  RegistrationDetailViewController.m
//  ProgressManage
//
//  Created by lingnet on 2017/5/22.
//  Copyright © 2017年 xurenqinag. All rights reserved.
//

#import "RegistrationDetailViewController.h"

#import "RegistrationDetail0Model.h"

#import "RegistrationDetail0TableViewCell.h"

#import "RegistrationDetail1Model.h"

#import "RegistrationDetail1TableViewCell.h"

#import "RegistrationDetail2Model.h"

#import "RegistrationDetail2TableViewCell.h"

#import "RegistrationDetail3Model.h"

#import "RegistrationDetail3TableViewCell.h"

#import "AuditOpinionViewController.h"
@interface RegistrationDetailViewController ()<UITableViewDataSource,UITableViewDelegate,RegistrationDetail2TableViewCellDelegate,MWPhotoBrowserDelegate,RegistrationDetail3TableViewCellDelegate,AuditOpinionViewControllerDelegate>{
    UITableView* _tableView;
}
@property(nonatomic,strong)NSMutableArray* dataSourceArr0;
@property(nonatomic,strong)NSMutableArray* dataSourceArr1;
@property(nonatomic,strong)NSMutableArray* dataSourceArr2;
@property(nonatomic,strong)NSMutableArray* dataSourceArr3;

@property (strong, nonatomic) UINavigationController *photoNavigationController;
@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (strong, nonatomic) UIWindow *keyWindow;
@property(nonatomic,retain)NSMutableArray* photos;

@property(nonatomic,copy)NSString* _token;
@property(nonatomic,copy)NSString* _errorCode;
@end

@implementation RegistrationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [MyController colorWithHexString:DEFAULTCOLOR];
    self.dataSourceArr0 = [[NSMutableArray alloc] init];
    self.dataSourceArr1 = [[NSMutableArray alloc] init];
    self.dataSourceArr2 = [[NSMutableArray alloc] init];
    self.dataSourceArr3 = [[NSMutableArray alloc] init];
    
    [self createTableView];
    
    if (self.isNeedAudit) {
        [self makeAuditUI];
    }
    
    [self getDetail];
}

- (void)sendBackChanged:(BOOL)changed {
    if (changed) {
        self.dataSourceArr0 = [[NSMutableArray alloc] init];
        self.dataSourceArr1 = [[NSMutableArray alloc] init];
        self.dataSourceArr2 = [[NSMutableArray alloc] init];
        self.dataSourceArr3 = [[NSMutableArray alloc] init];
        [self getDetail];
    }
}

#pragma mark - 获取审核详情
- (void)getDetail {
    [requestService postCreateTokenWithUserId:[MyController getUserid] cname:[MyController getCName] complate:^(id responseObject) {
        if ([responseObject[@"result"] intValue]) {
            NSDictionary* souDic = [MyController dictionaryWithJsonString:responseObject[@"data"]];
            self._token = souDic[@"token"];
            self._errorCode = souDic[@"errorCode"];
            
            [requestService postDetailWithUserId:[MyController getUserid] id:self._id type:self._type token:self._token complate:^(id responseObject) {
                NSLog(@"%@",responseObject[@"data"]);
                if ([responseObject[@"result"] intValue]) {
                    NSDictionary* souDic = [MyController dictionaryWithJsonString:responseObject[@"data"]];
                    
                    RegistrationDetail0Model* model0 = [[RegistrationDetail0Model alloc] init];
                    model0.name = [MyController returnStr:souDic[@"userName"]];
                    if ([souDic[@"state"] intValue] == 1) {
                        model0.state = @"待审核";
                    }else if ([souDic[@"state"] intValue] == 2) {
                        model0.state = @"已同意";
                    }else if ([souDic[@"state"] intValue] == 3) {
                        model0.state = @"已拒绝";
                    }
                    [self.dataSourceArr0 addObject:model0];
                    
                    
                    RegistrationDetail1Model* model10 = [[RegistrationDetail1Model alloc] init];
                    model10.leftTitle = @"审批编号";
                    model10.rightTitle = [MyController returnStr:souDic[@"auditNumber"]];
                    [self.dataSourceArr1 addObject:model10];
                    
                    RegistrationDetail1Model* model11 = [[RegistrationDetail1Model alloc] init];
                    model11.leftTitle = @"所在部门";
                    model11.rightTitle = [MyController returnStr:souDic[@"deptName"]];
                    [self.dataSourceArr1 addObject:model11];
                    
                    RegistrationDetail1Model* model12 = [[RegistrationDetail1Model alloc] init];
                    model12.leftTitle = @"请假类型";
                    model12.rightTitle = [MyController returnStr:souDic[@"leaveTypeDesc"]];
                    [self.dataSourceArr1 addObject:model12];
                    
                    RegistrationDetail1Model* model13 = [[RegistrationDetail1Model alloc] init];
                    model13.leftTitle = @"开始时间";
                    model13.rightTitle = [MyController returnStr:souDic[@"stime"]];
                    [self.dataSourceArr1 addObject:model13];
                    
                    RegistrationDetail1Model* model14 = [[RegistrationDetail1Model alloc] init];
                    model14.leftTitle = @"结束时间";
                    model14.rightTitle = [MyController returnStr:souDic[@"etime"]];
                    [self.dataSourceArr1 addObject:model14];
                    
                    RegistrationDetail1Model* model15 = [[RegistrationDetail1Model alloc] init];
                    model15.leftTitle = @"时长（天）";
                    model15.rightTitle = [MyController returnStr:[NSString stringWithFormat:@"%.2f",[souDic[@"duration"] floatValue]]];
                    [self.dataSourceArr1 addObject:model15];
                    
                    RegistrationDetail1Model* model16 = [[RegistrationDetail1Model alloc] init];
                    model16.leftTitle = @"请假事由";
                    model16.rightTitle = [MyController returnStr:souDic[@"due"]];
                    [self.dataSourceArr1 addObject:model16];
                    
                    RegistrationDetail2Model* model2 = [[RegistrationDetail2Model alloc] init];
                    model2.image = [MyController returnStr:souDic[@"leaveImg"]];
                    [self.dataSourceArr2 addObject:model2];
                    
                    self.photos = [[NSMutableArray alloc] init];
                    [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:model2.image]]];
                    
                    
                    NSArray* temArr = souDic[@"details"];
                    for (NSDictionary* dic in temArr) {
                        RegistrationDetail3Model* model31 = [[RegistrationDetail3Model alloc] init];
                        model31.name = [MyController returnStr:dic[@"auditPers"]];
                        model31.time = [MyController returnStr:dic[@"auditTime"]];//@"2017-05-01 09:00";
                        if ([dic[@"state"] intValue] == 1) {
                            model31.state = @"发起申请";
                        }else if ([dic[@"state"] intValue] == 2) {
                            model31.state = @"申请通过";
                        }else if ([dic[@"state"] intValue] == 3) {
                            model31.state = @"申请被拒绝";
                        }
                        model31.opinion = [MyController returnStr:dic[@"options"]];
                        [self.dataSourceArr3 addObject:model31];
                    }
                    
//                    RegistrationDetail3Model* model3 = [[RegistrationDetail3Model alloc] init];
//                    model3.name = @"皮卡丘";
//                    model3.time = @"2017-05-01 09:00";
//                    model3.state = @"发起申请";
//                    model3.image = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495515553658&di=91fd237bb9ac3671f5d89772788d64b6&imgtype=0&src=http%3A%2F%2Fcdn2.ettoday.net%2Fimages%2F907%2Fd907901.jpg";
//                    model3.opinion = @"加油!!!!";
//                    [self.dataSourceArr3 addObject:model3];
                    
                    [_tableView reloadData];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)makeAuditUI{
    UIButton* yesBtn = [MyController createButtonWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), [MyController getScreenWidth]/2, 50) ImageName:nil Target:self Action:@selector(yesBtnClick) Title:@"同  意"];
    [yesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    yesBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [yesBtn setBackgroundColor:[MyController colorWithHexString:@"4c89f0"]];
    [self.view addSubview:yesBtn];
    
    UIButton* noBtn = [MyController createButtonWithFrame:CGRectMake([MyController getScreenWidth]/2, CGRectGetMaxY(_tableView.frame), [MyController getScreenWidth]/2, 50) ImageName:nil Target:self Action:@selector(noBtnClick) Title:@"拒  绝"];
    [noBtn setTitleColor:[MyController colorWithHexString:@"ff582c"] forState:UIControlStateNormal];
    noBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [noBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:noBtn];
}

- (void)yesBtnClick{
    NSLog(@"同意");
    AuditOpinionViewController* vc = [[AuditOpinionViewController alloc] init];
    vc.title = @"审批意见";
    vc._id = self._id;
    vc._state = @"2";
    vc.AuditOpinionViewControllerDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)noBtnClick{
    NSLog(@"不同意");
    AuditOpinionViewController* vc = [[AuditOpinionViewController alloc] init];
    vc.title = @"审批意见";
    vc._id = self._id;
    vc._state = @"3";
    vc.AuditOpinionViewControllerDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 初始化tableView
- (void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.isNeedAudit) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [MyController isIOS7], self.view.frame.size.width, [MyController getScreenHeight] - [MyController isIOS7] - 50) style:UITableViewStylePlain];
    }else{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [MyController isIOS7], self.view.frame.size.width, [MyController getScreenHeight] - [MyController isIOS7]) style:UITableViewStylePlain];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    //分割线类型
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

#pragma mark - tableView行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (0 == section) {
        return self.dataSourceArr0.count;
    }else if (1 == section){
        return self.dataSourceArr1.count;
    }else if (2 == section){
        return self.dataSourceArr2.count;
    }
    return self.dataSourceArr3.count;
}

#pragma mark - 自定义tableView
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.section) {
        NSString *cellIdentifier = @"RegistrationDetail0TableViewCell";
        RegistrationDetail0TableViewCell *celll = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!celll) {
            celll = [[RegistrationDetail0TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        celll.selectionStyle = UITableViewCellSelectionStyleNone;
        RegistrationDetail0Model* model = self.dataSourceArr0[indexPath.row];
        [celll configCellWithModel:model];
        return celll;
    }else if (1 == indexPath.section){
        NSString *cellIdentifier = @"RegistrationDetail1TableViewCell";
        RegistrationDetail1TableViewCell *celll = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!celll) {
            celll = [[RegistrationDetail1TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        celll.selectionStyle = UITableViewCellSelectionStyleNone;
        RegistrationDetail1Model* model = self.dataSourceArr1[indexPath.row];
        [celll configCellWithModel:model];
        return celll;
    }else if (2 == indexPath.section){
        NSString *cellIdentifier = @"RegistrationDetail2TableViewCell";
        RegistrationDetail2TableViewCell *celll = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!celll) {
            celll = [[RegistrationDetail2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        celll.selectionStyle = UITableViewCellSelectionStyleNone;
        RegistrationDetail2Model* model = self.dataSourceArr2[indexPath.row];
        celll.RegistrationDetail2TableViewCellDelegate = self;
        [celll configCellWithModel:model];
        return celll;
    }
    
    NSString *cellIdentifier = @"RegistrationDetail3TableViewCell";
    RegistrationDetail3TableViewCell *celll = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!celll) {
        celll = [[RegistrationDetail3TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    celll.selectionStyle = UITableViewCellSelectionStyleNone;
    celll.RegistrationDetail3TableViewCellDelegate = self;
    celll.cellIndex = indexPath.row;
    RegistrationDetail3Model* model = self.dataSourceArr3[indexPath.row];
    [celll configCellWithModel:model];
    return celll;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

#pragma mark - tableView行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.section) {
//        return 71;
        RegistrationDetail0Model *model = nil;
        if (indexPath.row < self.dataSourceArr0.count) {
            model = [self.dataSourceArr0 objectAtIndex:indexPath.row];
        }
        
        return [RegistrationDetail0TableViewCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
            RegistrationDetail0TableViewCell *cell = (RegistrationDetail0TableViewCell *)sourceCell;
            [cell configCellWithModel:model];
        }];
    }else if (1 == indexPath.section){
//        return 43;
        RegistrationDetail1Model *model = nil;
        if (indexPath.row < self.dataSourceArr1.count) {
            model = [self.dataSourceArr1 objectAtIndex:indexPath.row];
        }
        
        return [RegistrationDetail1TableViewCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
            RegistrationDetail1TableViewCell *cell = (RegistrationDetail1TableViewCell *)sourceCell;
            [cell configCellWithModel:model];
        }];
    }else if (2 == indexPath.section){
//        return 125;
        RegistrationDetail2Model *model = nil;
        if (indexPath.row < self.dataSourceArr2.count) {
            model = [self.dataSourceArr2 objectAtIndex:indexPath.row];
        }
        
        return [RegistrationDetail2TableViewCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
            RegistrationDetail2TableViewCell *cell = (RegistrationDetail2TableViewCell *)sourceCell;
            [cell configCellWithModel:model];
        }];
    }
    
    RegistrationDetail3Model *model = nil;
    if (indexPath.row < self.dataSourceArr3.count) {
        model = [self.dataSourceArr3 objectAtIndex:indexPath.row];
    }
    
    return [RegistrationDetail3TableViewCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        RegistrationDetail3TableViewCell *cell = (RegistrationDetail3TableViewCell *)sourceCell;
        [cell configCellWithModel:model];
    }];
}


/**
 查看图片
 */
- (void)sendBackCheckImage{
    NSLog(@"看图");
    UIViewController *rootController = [self.keyWindow rootViewController];
    [rootController presentViewController:self.photoNavigationController animated:YES completion:nil];
    [_photoBrowser setCurrentPhotoIndex:0];
}

#pragma mark - getter 创建一个显示图片的window
- (UIWindow *)keyWindow{
    if(_keyWindow == nil){
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    return _keyWindow;
}
#pragma mark - 初始化MWPhotoBrowser
- (MWPhotoBrowser *)photoBrowser{
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.wantsFullScreenLayout = YES;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
    }
    return _photoBrowser;
}

- (UINavigationController *)photoNavigationController{
    if (_photoNavigationController == nil) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    [self.photoBrowser reloadData];
    return _photoNavigationController;
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return [self.photos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.photos.count){
        return [self.photos objectAtIndex:index];
    }
    return nil;
}


/**
 cell3查看图片

 @param cellIndex 第N个cell的图
 */
- (void)sendBackCheckImage:(NSInteger)cellIndex{
    RegistrationDetail3Model* model = self.dataSourceArr3[cellIndex];
    self.photos = [[NSMutableArray alloc] init];
    [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:model.image]]];
    
    UIViewController *rootController = [self.keyWindow rootViewController];
    [rootController presentViewController:self.photoNavigationController animated:YES completion:nil];
    [_photoBrowser setCurrentPhotoIndex:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end