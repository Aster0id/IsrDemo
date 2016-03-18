//
//  TFXunFeiAudioInputView.m
//  IsrDemo
//
//  Created by 牛萌 on 16/2/23.
//  Copyright © 2016年 Tianjin TianFang Science and Technology Development Co.,Ltd. All rights reserved.
//

#import "TFXunFeiAudioInputView.h"
#import "PulsingHaloLayer.h"
#import <AVFoundation/AVFoundation.h>

@interface TFXunFeiAudioInputView () <IFlySpeechRecognizerDelegate>

@property (nonatomic, strong) UIButton *audioInputButton;
@property (nonatomic, strong) UIButton *languageButton;
@property (nonatomic, strong) UILabel *xunFeiTitle;
@property (nonatomic, weak) PulsingHaloLayer *halo;

/// 不带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end


@implementation TFXunFeiAudioInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initialize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.audioInputButton.frame = CGRectMake(CGRectGetMidX(self.bounds) - 36, CGRectGetMidY(self.bounds) - 36, 72, 72);
    
    self.halo.position = self.audioInputButton.center;
    
    self.xunFeiTitle.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 44, 60, 44);
    
    self.languageButton.frame = CGRectMake(0, self.frame.size.height - 44, 60, 44);
}


#pragma mark - Public Methods

- (void)viewWillDisappear {
    // 销毁
    [_iFlySpeechRecognizer cancel]; //取消识别
    [_iFlySpeechRecognizer setDelegate:nil];
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
}

#pragma mark - Initialize Data

- (void)initialize {
    
    // *** 设置语言输入按钮 ***
    self.audioInputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.audioInputButton setImage:[UIImage imageNamed:@"edit_voiceinput"] forState:UIControlStateNormal];
    [self.audioInputButton addTarget:self action:@selector(clickAudioInputButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.audioInputButton];
    
    // *** 设置语音输入动画 ***
    PulsingHaloLayer *layer = [PulsingHaloLayer layer];
    self.halo = layer;
    self.halo.haloLayerNumber = 5;
    self.halo.radius = 80;
    self.halo.animationDuration = 5;
    UIColor *color = [UIColor colorWithRed:0 green:0.455 blue:0.756 alpha:1.0];
    [self.halo setBackgroundColor:color.CGColor];
    self.halo.hidden = YES;
    [self.audioInputButton.superview.layer insertSublayer:self.halo below:self.audioInputButton.layer];
    
    // *** 设置语音按钮 ***
    self.languageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.languageButton setTitleColor:[UIColor colorWithRed:0.631 green:0.631 blue:0.631 alpha:1.0] forState:UIControlStateNormal];
    [self.languageButton setTitle:@"普通话" forState:UIControlStateNormal];
    [self.languageButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:self.languageButton];
    
    // *** 设置讯飞标题 ***
    self.xunFeiTitle = [[UILabel alloc] init];
    self.xunFeiTitle.text = @"科大讯飞";
    self.xunFeiTitle.font = [UIFont systemFontOfSize:13.0];
    self.xunFeiTitle.textColor = [UIColor colorWithRed:0.631 green:0.631 blue:0.631 alpha:1.0];
    self.xunFeiTitle.frame = CGRectMake(0, 0, 55, 20);
    [self addSubview:self.xunFeiTitle];
}

- (void)initRecognizer {
    
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    
    _iFlySpeechRecognizer.delegate = self;
    
    //IATConfig *instance = [IATConfig sharedInstance];
    
    //设置最长录音时间
    //[_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    //设置后端点
    //[_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
    //设置前端点
    //[_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
    
    //网络等待时间
    [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
    
    //设置采样率，推荐使用16K
    //[_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    /*
     if ([instance.language isEqualToString:[IATConfig chinese]]) {
     //设置语言
     [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
     //设置方言
     [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
     }else if ([instance.language isEqualToString:[IATConfig english]]) {
     [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
     }
     */
    //设置是否返回标点符号
    //[_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
    
}

- (void)clickAudioInputButton {
    if (![_iFlySpeechRecognizer isListening]) {
        // NSLog(@"开启服务");
        [self startListening];
    } else {
        // NSLog(@"关闭服务");
        [self stopListening];
    }
}

- (void)startListening {
    
    if(_iFlySpeechRecognizer == nil) {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    if (ret) {
    }else{
        NSLog(@"启动识别服务失败，请稍后重试");
        // "启动识别服务失败，请稍后重试"
        // 可能是上次请求未结束，暂不支持多路并发
    }
    
}

- (void)stopListening {
    [_iFlySpeechRecognizer stopListening];
}

#pragma mark - IFlySpeechRecognizerDelegate

/**
 音量回调函数
 volume 0－30
 ****/
- (void)onVolumeChanged:(int)volume {
    //NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    //NSLog(@"%@",vol);
    self.halo.haloLayerNumber = MAX(2,volume/3);
    
}

/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech {
    self.halo.hidden = NO;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MicrophoneTurnOn" ofType:@"mp3"]] error:nil];
    [_audioPlayer play];
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech {
    self.halo.hidden = YES;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MicrophoneTurnOff" ofType:@"mp3"]] error:nil];
    [_audioPlayer play];
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void)onError:(IFlySpeechError *)error {
    // NSLog(@"%s",__func__);
    NSString *text ;
    if (error.errorCode == 0 ) {
        text = @"识别成功";
    }else {
        text = [NSString stringWithFormat:@"发生错误：%d %@", error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioInputView:onError:)]) {
            [self.delegate audioInputView:self onError:error];
        }
    }
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void)onResults:(NSArray *)results isLast:(BOOL)isLast {
    //NSLog(@"results=%@",results);
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    // NSLog(@"results=%@",resultString);
    NSString *resultFromJson = [TFXunFeiAudioInputView stringFromJson:resultString];
    // NSLog(@"resultFromJson=%@",resultFromJson);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioInputView:speechInput:)]) {
        [self.delegate audioInputView:self speechInput:resultFromJson];
    }
}

/**
 听写取消回调
 ****/
- (void)onCancel {
    NSLog(@"识别取消");
}

#pragma mark - Private Methods

+ (NSString *)stringFromJson:(NSString*)params {
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}


@end
