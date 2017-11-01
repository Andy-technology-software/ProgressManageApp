//
//  SelfViewController.m
//  ProgressManage
//
//  Created by lingnet on 2017/5/4.
//  Copyright © 2017年 xurenqinag. All rights reserved.
//

#import "SelfViewController.h"

#import "SelfHeadModel.h"

#import "SelfHeadTableViewCell.h"

#import "SignIndexViewController.h"

#import "DailyViewController.h"

#import "RegistrationViewController.h"

#import "AuditViewController.h"

#import "ChartPartIndexViewController.h"

#import "SeetingViewController.h"

#import "RealtimePositioningViewController.h"

#import "WeizhiViewController.h"
@interface SelfViewController ()<UITableViewDataSource,UITableViewDelegate,YBImgPickerViewControllerDelegate,selfCellDelegate,WeizhiViewControllerDelegate>{
    UITableView* _tableView;
}
@property(nonatomic,strong)NSMutableArray* dataSourceArr;

@property(nonatomic,assign)BOOL isNotFir;

@property(nonatomic,copy)NSString* _token;
@property(nonatomic,copy)NSString* _errorCode;
@end

@implementation SelfViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults*userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* _nickName = [userDefaults objectForKey:@"nickName"];
    NSString* _companyName = [userDefaults objectForKey:@"enterprise"];
    
    self.view.backgroundColor  =[MyController colorWithHexString:DEFAULTCOLOR];
    self.dataSourceArr = [[NSMutableArray alloc] init];
    
    SelfHeadModel* model = [[SelfHeadModel alloc] init];
    model.headImage = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493870730701&di=fb0a663047512be34727ad693ff80b8f&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fd4628535e5dde7112bd4ba00a5efce1b9c1661c6.jpg";
    model.cname = _companyName;
    model.name = _nickName;
    [self.dataSourceArr addObject:model];
    
    if (self.isNotFir) {
        [_tableView reloadData];
    }
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isNotFir = YES;
    [self createTableView];
}

#pragma mark - 初始化tableView
- (void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //分割线类型
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

#pragma mark - tableView行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
#pragma mark - tableVie点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - 自定义tableView
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"headcell";
    SelfHeadTableViewCell *celll = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!celll) {
        celll = [[SelfHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    celll.selectionStyle = UITableViewCellSelectionStyleNone;
    SelfHeadModel* model = self.dataSourceArr[indexPath.row];
    celll.selfCellDelegate = self;
    [celll configCellWithModel:model];
    return celll;
}

#pragma mark - tableView行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelfHeadModel *model = nil;
    if (indexPath.row < self.dataSourceArr.count) {
        model = [self.dataSourceArr objectAtIndex:indexPath.row];
    }
    
    NSString *stateKey = nil;
    if (model.isExpand) {
        stateKey = @"expanded";
    } else {
        stateKey = @"unexpanded";
    }
    
    return [SelfHeadTableViewCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        SelfHeadTableViewCell *cell = (SelfHeadTableViewCell *)sourceCell;
        [cell configCellWithModel:model];
    } cache:^NSDictionary *{
        return @{kHYBCacheUniqueKey: [NSString stringWithFormat:@"%d", model.uid],
                 kHYBCacheStateKey : stateKey,
                 kHYBRecalculateForStateKey : @(NO)
                 };
    }];

}

- (void)sendBackSelectNum:(NSInteger)seleIndex{
    if (0 == seleIndex) {
        NSLog(@"签到");
        SignIndexViewController* vc = [[SignIndexViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (1 == seleIndex){
        NSLog(@"日报");
        DailyViewController* vc = [[DailyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (2 == seleIndex){
        NSLog(@"统计");
        ChartPartIndexViewController* vc = [[ChartPartIndexViewController alloc] init];
        vc.title = @"统计分析";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (3 == seleIndex){
        NSLog(@"设置");
        SeetingViewController* vc = [[SeetingViewController alloc] init];
        vc.title = @"设置";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (4 == seleIndex){
        NSLog(@"外出");
        RegistrationViewController* vc = [[RegistrationViewController alloc] init];
        vc._type = @"0";
        vc.title = @"外出登记";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (5 == seleIndex){
        NSLog(@"请假");
        RegistrationViewController* vc = [[RegistrationViewController alloc] init];
        vc._type = @"1";
        vc.title = @"请假登记";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (6 == seleIndex){
        NSLog(@"审核");
        AuditViewController* vc = [[AuditViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 查看位置轨迹代理
- (void)sendBackNoGuiji:(BOOL)noguiji{
    [HUD hide];
    if (noguiji) {
        [HUD warning:@"暂无轨迹可查看"];
    }
}

- (void)sendBackChangeIamge{
    YBImgPickerViewController * next = [[YBImgPickerViewController alloc]init];
    [next showInViewContrller:self choosenNum:0 delegate:self];
}

- (void)YBImagePickerDidFinishWithImages:(NSArray *)imageArray {
    NSLog(@"----%@",imageArray);
    for (UIImage * image in imageArray) {
        
        NSData *data = UIImageJPEGRepresentation(image, 1.0f);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        [requestService postCreateTokenWithUserId:[MyController getUserid] cname:[MyController getCName] complate:^(id responseObject) {
            if ([responseObject[@"result"] intValue]) {
                NSDictionary* souDic = [MyController dictionaryWithJsonString:responseObject[@"data"]];
                self._token = souDic[@"token"];
                self._errorCode = souDic[@"errorCode"];
                
                [requestService postInfoUpdateHeadImgWithUserId:[MyController getUserid] headImg:encodedImageStr token:self._token complate:^(id responseObject) {
                    if ([responseObject[@"result"] intValue]) {
                        NSDictionary* dic = [MyController dictionaryWithJsonString:responseObject[@"data"]];
                        SelfHeadModel* model = [self.dataSourceArr lastObject];
                        model.headImage = dic[@"headImg"];
                        
                        NSUserDefaults *accountDefault2 = [NSUserDefaults standardUserDefaults];
                        [accountDefault2 setObject:dic[@"headImg"] forKey:@"headImg"];
                        
                        [HUD success:responseObject[@"msg"]];
                        [_tableView reloadData];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        } failure:^(NSError *error) {
            
        }];
    }
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