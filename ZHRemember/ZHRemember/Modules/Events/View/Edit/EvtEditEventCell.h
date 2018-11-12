//
//  EvtEditEventCell.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/25.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventHeader.h"

typedef enum : NSUInteger {
    EvtEditEventInit = 0,
    EvtEditEventInputChanged,
    EvtEditEventInputFinish,
} EvtEditEvent;

@interface EvtEditEventCell : UITableViewCell

- (void)showEditStateView;
- (void)hideEditStateView;

@end
