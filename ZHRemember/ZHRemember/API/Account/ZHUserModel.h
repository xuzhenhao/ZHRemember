//
//  ZHUserModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/6.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

typedef enum : NSUInteger {
    ZHCustomFontSn = 1,
    ZHCustomFontJYY,
    ZHCustomFontGirl,
    ZHCustomFontCat,
} ZHCustomFontType;

/**用户扩展表名*/
extern NSString *const UserExtClassName;
/**用户id键名*/
extern NSString *const UserExtUserIdKey;
/**用户昵称键名*/
extern NSString *const UserExtNickNameKey;
/**用户代币键名*/
extern NSString *const UserExtMoneyKey;
/**用户头像键名*/
extern NSString *const UserExtAvatarKey;
/**用户签到日期键名*/
extern NSString *const UserExtSignKey;
/**用户发表日记日期键名*/
extern NSString *const UserExtPublishKey;
/**用户购买了去广告服务键名*/
extern NSString *const UserExtDisableAdsKey;
/**用户购买了自定义主题色键名*/
extern NSString *const UserExtCustomColorKey;
/**用户购买了付费信纸键名*/
extern NSString *const UserExtUnlockLetterKey;
/**用户购买了小猫体*/
extern NSString *const UserExtUnlockFontCatKey;
/**用户购买了华康少女体*/
extern NSString *const UserExtUnlockFontGirlKey;
/**用户购买了字体简雅艺*/
extern NSString *const UserExtUnlockFontJYYKey;
/**用户购买了字体Sn*/
extern NSString *const UserExtUnlockFontSnKey;
/**用户购买了字体颜色*/
extern NSString *const UserExtUnlockFontColorKey;

@interface ZHUserModel : MTLModel<MTLJSONSerializing>
/** 对象id*/
@property (nonatomic, copy)     NSString    *objectId;
/** 用户id*/
@property (nonatomic, copy)     NSString    *userId;
/** 昵称*/
@property (nonatomic, copy)     NSString    *nickName;
/** 代币*/
@property (nonatomic, copy)     NSString    *money;
/** 头像*/
@property (nonatomic, copy)     NSString    *avatarURL;
/** 最近签到日期,mm-dd*/
@property (nonatomic, copy)     NSString    *signTime;
/** 最近发表日记时间,mm-dd*/
@property (nonatomic, copy)     NSString    *publishTime;
/** 是否去广告*/
@property (nonatomic, assign)   BOOL      isDisableAd;
/** 是否解锁自定义主题色*/
@property (nonatomic, assign)   BOOL      isEnableCustomColor;
/** 是否解锁了付费信纸*/
@property (nonatomic, assign)   BOOL      isUnlockLetter;

/** 是否解锁了小猫体*/
@property (nonatomic, assign)   BOOL      isUnlockCatFont;
/** 是否解锁了华康少女体*/
@property (nonatomic, assign)   BOOL      isUnlockGirlFont;
/** 是否解锁了迷你简雅艺字体*/
@property (nonatomic, assign)   BOOL      isUnlockJYYFont;
/** 是否解锁了SnFont字体*/
@property (nonatomic, assign)   BOOL      isUnlockSnFont;
/** 是否解锁了自定义字体颜色*/
@property (nonatomic, assign)   BOOL      isUnlockFontColor;

@end
