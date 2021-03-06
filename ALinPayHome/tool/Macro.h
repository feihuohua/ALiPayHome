//
//  Macro.h
//  ALinPayHome
//
//  Created by Qing Chang on 2017/6/7.
//  Copyright © 2017年 Qing Chang. All rights reserved.
//

#import "MJRefresh.h"
#import "UIView+LoadNib.h"

#define kFBaseHeight [[UIScreen mainScreen]bounds].size.height
#define kFBaseWidth [[UIScreen mainScreen]bounds].size.width

#define kFRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:255.0/255.0]

#define kFMainColor kFRGB(67, 130, 195)

#define KFMainBackColor kFRGB(242, 242, 242);

#define KFAppHeight 230

#define kWeakSelf(type)   __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;
