//
//  TFXunFeiAudioInputView.h
//  IsrDemo
//
//  Created by 牛萌 on 16/2/23.
//  Copyright © 2016年 Tianjin TianFang Science and Technology Development Co.,Ltd. All rights reserved.
//

/*
 需要导入以下 framework。
 
 - iflyMSC.framework
 - libz.dylib
 - AVFoundation.framework
 - SystemConfiguration.framework
 - Foundation.framework
 - CoreTelephoney.framework
 - AudioToolbox.framework
 - UIKit.framework
 - CoreLocation.framework
 - AddressBook.framework
 - QuartzCore.framework
 - CoreGraphics.framework
 */
#import <UIKit/UIKit.h>

#import <iflyMSC/iflyMSC.h>



@class TFXunFeiAudioInputView;

@protocol TFXunFeiAudioInputViewDelegate <NSObject>

- (void)audioInputView:(TFXunFeiAudioInputView *)audioInputView speechInput:(NSString *)inputString;

/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode = 0 听写正确
 error.errorCode = other 听写出错
 ****/
- (void)audioInputView:(TFXunFeiAudioInputView *)audioInputView onError:(IFlySpeechError *)error;

@end

@interface TFXunFeiAudioInputView : UIView

@property (nonatomic, assign) id<TFXunFeiAudioInputViewDelegate> delegate;

- (void)viewWillDisappear;

@end
