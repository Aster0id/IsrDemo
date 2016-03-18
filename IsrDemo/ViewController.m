//
//  ViewController.m
//  IsrDemo
//
//  Created by 牛萌 on 16/2/23.
//  Copyright © 2016年 Tianjin TianFang Science and Technology Development Co.,Ltd. All rights reserved.
//

#import "ViewController.h"
#import "TFXunFeiAudioInputView.h"

@interface ViewController () <TFXunFeiAudioInputViewDelegate, UITextViewDelegate>

@property (nonatomic, weak) IBOutlet TFXunFeiAudioInputView *inputView;

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.inputView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    self.inputView.delegate = self;
    
    self.textView.delegate = self;

}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.inputView viewWillDisappear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)audioInputView:(TFXunFeiAudioInputView *)audioInputView onError:(IFlySpeechError *)error {

}

- (void)audioInputView:(TFXunFeiAudioInputView *)audioInputView speechInput:(NSString *)inputString {

    NSMutableString *_text = [[NSMutableString alloc] initWithString:self.textView.text];
    [_text appendString:inputString];
    self.textView.text = _text;
    
}

@end
