//
//  RegistrationDetailViewController.h
//  ProgressManage
//
//  Created by lingnet on 2017/5/22.
//  Copyright © 2017年 xurenqinag. All rights reserved.
//

#import "BaseViewController.h"

@interface RegistrationDetailViewController : BaseViewController
@property(nonatomic,assign)BOOL isNeedAudit;
@property(nonatomic,copy)NSString* _id;
@property(nonatomic,copy)NSString* _type;

@end