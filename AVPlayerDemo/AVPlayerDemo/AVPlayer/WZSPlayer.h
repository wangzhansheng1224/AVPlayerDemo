//
//  WZSPlayer.h
//  AVPlayerDemo
//
//  Created by 王战胜 on 2017/10/25.
//  Copyright © 2017年 gocomtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface WZSPlayer : UIView
//AVPlayer
@property (nonatomic,strong) AVPlayer *player;
//AVPlayer的播放item
@property (nonatomic,strong) AVPlayerItem *item;
//总时长
@property (nonatomic,assign) CMTime totalTime;
//当前时间
@property (nonatomic,assign) CMTime currentTime;
//资产AVURLAsset
@property (nonatomic,strong) AVURLAsset *anAsset;
//播放器Playback Rate
@property (nonatomic,assign) CGFloat rate;
@end
