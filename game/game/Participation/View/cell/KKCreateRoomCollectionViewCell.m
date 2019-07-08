//
//  KKCreateRoomCollectionViewCell.m
//  game
//
//  Created by GKK on 2018/10/17.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKCreateRoomCollectionViewCell.h"
#import "KKChoiceControl.h"
@interface KKCreateRoomCollectionViewCell()
@property (weak, nonatomic) IBOutlet KKChoiceControl *leftControl;
@property (weak, nonatomic) IBOutlet KKChoiceControl *rightControl;

@end
@implementation KKCreateRoomCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftControl.imgView.image = [UIImage imageNamed:@"publishMatch"];
    self.rightControl.imgView.image = [UIImage imageNamed:@"joinMatch"];
    self.leftControl.titleLabel.text = @"发布对战";
    self.rightControl.titleLabel.text = @"加入对战";
    self.leftControl.subtitleLabel.text = @"邀请好友一起游戏";
    self.rightControl.subtitleLabel.text = @"使用对战房间号码";
}
- (IBAction)clickControl:(UIView *)sender {
    if (sender.tag == 0) {
        if (self.createRoomBlock) {
            self.createRoomBlock();
        }
    } else {
        if (self.joinRoomBlock) {
            self.joinRoomBlock();
        }
    }
}

@end
