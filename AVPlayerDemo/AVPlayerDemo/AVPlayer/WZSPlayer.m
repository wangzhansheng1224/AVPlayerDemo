//
//  WZSPlayer.m
//  AVPlayerDemo
//
//  Created by 王战胜 on 2017/10/25.
//  Copyright © 2017年 gocomtech. All rights reserved.
//

#import "WZSPlayer.h"

@interface WZSPlayer ()
@property (nonatomic,strong,readonly) AVPlayerLayer *playerLayer;
//当前播放url
@property (nonatomic,strong) NSURL *url;
@end

@implementation WZSPlayer

-(instancetype)initWithUrl:(NSURL *)url{
    self = [super init];
    if (self) {
        _url = url;
        [self setupPlayerUI];
        [self assetWithURL:url];
    }
    return self;
}

- (void)setupPlayerUI{
    
}

-(void)assetWithURL:(NSURL *)url{
    //如果创建AVURLAsset时传入的AVURLAssetPreferPreciseDurationAndTimingKey值为NO(不传默认为NO)，duration会取一个估计值，计算量比较小。反之如果为YES，duration需要返回一个精确值，计算量会比较大，耗时比较长。
    NSDictionary *options = @{ AVURLAssetPreferPreciseDurationAndTimingKey : @YES };
    self.anAsset = [[AVURLAsset alloc]initWithURL:url options:options];
    NSArray *keys = @[@"duration"];
    
    
    //由于多媒体文件一般比较大，获取或计算出Asset中的属性非常耗时，apple对Asset的属性采用了懒惰加载模式。在创建AVAsset的时候，只生成一个实例，并不初始化属性。只有当第一次访问属性时，系统才会根据多媒体中的数据初始化这个属性。由于不用同时加载所有属性，耗时问题得到了一定缓解。但是属性加载在计算量比较大的时候仍旧可能会阻塞线程。为了解决这个问题，AVFoundation提供了AVAsynchronousKeyValueLoading协议，可以异步加载属性：
    [self.anAsset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        NSError *error = nil;
        AVKeyValueStatus tracksStatus = [self.anAsset statusOfValueForKey:@"duration" error:&error];
        switch (tracksStatus) {
            case AVKeyValueStatusLoaded:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!CMTIME_IS_INDEFINITE(self.anAsset.duration)) {
                        CGFloat second = self.anAsset.duration.value / self.anAsset.duration.timescale;
                        self.controlView.totalTime = [self convertTime:second];
                        self.controlView.minValue = 0;
                        self.controlView.maxValue = second;
                    }
                });
            }
                break;
            case AVKeyValueStatusFailed:
            {
                //NSLog(@"AVKeyValueStatusFailed失败,请检查网络,或查看plist中是否添加App Transport Security Settings");
            }
                break;
            case AVKeyValueStatusCancelled:
            {
                NSLog(@"AVKeyValueStatusCancelled取消");
            }
                break;
            case AVKeyValueStatusUnknown:
            {
                NSLog(@"AVKeyValueStatusUnknown未知");
            }
                break;
            case AVKeyValueStatusLoading:
            {
                NSLog(@"AVKeyValueStatusLoading正在加载");
            }
                break;
        }
    }];
}
@end




















