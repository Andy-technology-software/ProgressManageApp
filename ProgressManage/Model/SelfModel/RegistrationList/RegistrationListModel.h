//
//  RegistrationListModel.h
//  ProgressManage
//
//  Created by lingnet on 2017/5/22.
//  Copyright © 2017年 xurenqinag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistrationListModel : NSObject
@property(nonatomic,copy)NSString* userName;
@property(nonatomic,copy)NSString* due;
@property(nonatomic,copy)NSString* type;
@property(nonatomic,copy)NSString* leaveType;
@property(nonatomic,copy)NSString* stime;
@property(nonatomic,copy)NSString* etime;
@property(nonatomic,copy)NSString* state;
@property(nonatomic,copy)NSString* id;
@end