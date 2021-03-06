//
//  GJGCInformationMemeberShowCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCInformationMemeberShowCell.h"
#import "GJGCInformationMemberShowItem.h"

#define GJGCInformationMemeberShowCellHeadTag 1132441

@interface GJGCInformationMemeberShowCell ()

@property (nonatomic,assign) NSInteger addButtonTag;        // 邀请按钮tag值

@end

@implementation GJGCInformationMemeberShowCell

- (CGFloat)setupMemberHeadViewsWithUserHeads:(NSArray *)sHeads isGroupMember:(BOOL)isMember
{
    // 删除之前添加的按钮
    for (UIView *butView in self.baseContentView.subviews) {
        if ([butView isKindOfClass:[GJGCInformationMemberShowItem class]] && butView.tag >= GJGCInformationMemeberShowCellHeadTag) {
            [butView removeFromSuperview];
        }
    }
    
    NSInteger totalNum = 5;
    if (GJCFSystemiPhone6) {
        totalNum = 6;
    }
    else if (GJCFSystemiPhone6Plus) {
        totalNum = 7;
    }
    
    NSMutableArray *heads = [NSMutableArray arrayWithArray:sHeads];
    if (heads.count > totalNum) {
        do {
            [heads removeLastObject];
        } while (heads.count > totalNum);
    }
    
    for (int i = 0; i <= heads.count; i++) {
        if (i == totalNum || heads.count == 0) {
            break;
        }
        
        GJGCInformationMemberShowItem *memberItem = (GJGCInformationMemberShowItem *)[self.baseContentView viewWithTag:GJGCInformationMemeberShowCellHeadTag + i];
        if (!memberItem) {
            memberItem = [[GJGCInformationMemberShowItem alloc]init];
            memberItem.gjcf_top = self.contentLabel.gjcf_bottom + 13;
            memberItem.gjcf_left = self.contentLabel.gjcf_left + 36*i + 8*i;
            memberItem.gjcf_height = 36;
            memberItem.gjcf_width = 36;
            memberItem.userInteractionEnabled = NO;
            memberItem.tag = GJGCInformationMemeberShowCellHeadTag + i;
            //[memberItem addTarget:self action:@selector(tapOnInviteButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.baseContentView addSubview:memberItem];
        }
        
        // 群资料 显示群成员
        if (i <= heads.count - 1) {
            NSDictionary *dic = heads[i];
            NSString *userIdStr = [NSString stringWithFormat:@"%@",dic[@"userId"]];
        }
        
        // 如果非群成员 不显示邀请按钮
        if (isMember && i > (totalNum - 2) && i == heads.count -1) {
            _addButtonTag = memberItem.tag;
            [memberItem.headView setHiddenImageView:YES];
            memberItem.userInteractionEnabled = YES;
            [memberItem setBackgroundImage:GJCFQuickImage(@"群资料-邀请新成员-icon") forState:UIControlStateNormal];
            [memberItem setBackgroundImage:GJCFQuickImage(@"群资料-邀请新成员-icon-点击") forState:UIControlStateHighlighted];
            [memberItem addTarget:self action:@selector(tapOnInviteButton:) forControlEvents:UIControlEventTouchUpInside];
            self.baseContentView.userInteractionEnabled = YES;
            self.clipsToBounds = NO;
        }
        else if (isMember && i == heads.count) {
            [self setButtonAsInviteButton:memberItem];
        }
        
        if (i == heads.count || (i == heads.count - 1 && !isMember) || i == (totalNum - 1)) {
            return memberItem.gjcf_bottom;
        }
    }
    if (heads.count == 0 && isMember) {
        // 成员列表为空 只显示邀请按钮
        GJGCInformationMemberShowItem *memberItem = (GJGCInformationMemberShowItem *)[self.baseContentView viewWithTag:GJGCInformationMemeberShowCellHeadTag];
        if (!memberItem) {
            memberItem = [[GJGCInformationMemberShowItem alloc]init];
            memberItem.gjcf_top = self.contentLabel.gjcf_bottom + 13;
            memberItem.gjcf_left = self.contentLabel.gjcf_left;
            memberItem.gjcf_height = 36;
            memberItem.gjcf_width = 36;
            memberItem.tag = GJGCInformationMemeberShowCellHeadTag;
            [self.baseContentView addSubview:memberItem];
            
            _addButtonTag = memberItem.tag;
            [memberItem.headView setHiddenImageView:YES];
            [memberItem setBackgroundImage:GJCFQuickImage(@"群资料-邀请新成员-icon") forState:UIControlStateNormal];
            [memberItem setBackgroundImage:GJCFQuickImage(@"群资料-邀请新成员-icon-点击") forState:UIControlStateHighlighted];
            [memberItem addTarget:self action:@selector(tapOnInviteButton:) forControlEvents:UIControlEventTouchUpInside];
            self.baseContentView.userInteractionEnabled = YES;
            self.clipsToBounds = NO;
            return memberItem.gjcf_bottom;
        }
    }
    
    if (heads.count == 0 && !isMember) {
        return 42.0f;
    }
    return 0.f;
}

-(void)setButtonAsInviteButton:(GJGCInformationMemberShowItem*)memberItem
{
    _addButtonTag = memberItem.tag;
    [memberItem.headView setHiddenImageView:YES];
    memberItem.userInteractionEnabled = YES;
    [memberItem setBackgroundImage:GJCFQuickImage(@"群资料-邀请新成员-icon") forState:UIControlStateNormal];
    [memberItem setBackgroundImage:GJCFQuickImage(@"群资料-邀请新成员-icon-点击") forState:UIControlStateHighlighted];
    [memberItem addTarget:self action:@selector(tapOnInviteButton:) forControlEvents:UIControlEventTouchUpInside];
    self.baseContentView.userInteractionEnabled = YES;
    self.clipsToBounds = NO;
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIButton *addBut = (UIButton*)[self.baseContentView viewWithTag:_addButtonTag];
    UIView *touchView = [super hitTest:point withEvent:event];
    if ([touchView isKindOfClass:[UIButton class]]) {
        touchView = addBut;
    }
    return touchView;
}

- (void)tapOnInviteButton:(UIButton*)aBut
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(informationMemberShowCellDidTapOnInviteMember:)]) {
        [self.delegate informationMemberShowCellDidTapOnInviteMember:self];
    }
}

- (void)setContentInformationModel:(GJGCInformationBaseModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    [super setContentInformationModel:contentModel];
    
    GJGCInformationCellContentModel *informationModel = (GJGCInformationCellContentModel *)contentModel;

    if (informationModel.seprateStyle == GJGCInformationSeprateLineStyleTopFullBottomFull || informationModel.seprateStyle == GJGCInformationSeprateLineStyleTopNoneBottomFull) {
        self.tagLabel.gjcf_left = 16.f;
    }else{
        self.tagLabel.gjcf_left = self.baseSeprateLine.gjcf_left;
    }
    self.tagLabel.contentAttributedString = informationModel.tag;
    self.tagLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:informationModel.tag forBaseContentSize:self.tagLabel.contentBaseSize];
    
    self.contentLabel.contentAttributedString = informationModel.baseContent;
    self.contentLabel.gjcf_left = self.tagLabel.gjcf_right + self.contentMargin;
    self.contentLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:informationModel.baseContent forBaseContentSize:self.contentLabel.contentBaseSize];
    
    CGFloat headBottom = [self setupMemberHeadViewsWithUserHeads:informationModel.groupShowMemeberArray isGroupMember:informationModel.isGroupMember];

    self.baseContentView.gjcf_height = headBottom + 13;
    
    self.topSeprateLine.gjcf_top = informationModel.topLineMargin;
    self.baseContentView.gjcf_top = self.topSeprateLine.gjcf_bottom-0.5;
    self.baseSeprateLine.gjcf_bottom = self.baseContentView.gjcf_bottom;
    
    self.accessoryIndicatorView.gjcf_centerY = self.contentMargin + self.contentLabel.gjcf_height/2;
}

@end
