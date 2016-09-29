//
//  VideoRecordController.m
//  TestDemo
//
//  Created by Fantasy on 16/9/27.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "VideoRecordController.h"
#import "VCapture.h"

const float colormatrix_lomo[] = {
    1.7f,  0.1f, 0.1f, 0, -73.1f,
    0,  1.7f, 0.1f, 0, -73.1f,
    0,  0.1f, 1.6f, 0, -73.1f,
    0,  0, 0, 1.0f, 0 };

//黑白
const float colormatrix_heibai[] = {
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0,  0, 0, 1.0f, 0 };

//怀旧
const float colormatrix_huaijiu[] = {
    0.2f,0.5f, 0.1f, 0, 40.8f,
    0.2f, 0.5f, 0.1f, 0, 40.8f,
    0.2f,0.5f, 0.1f, 0, 40.8f,
    0, 0, 0, 1, 0 };

//哥特
const float colormatrix_gete[] = {
    1.9f,-0.3f, -0.2f, 0,-87.0f,
    -0.2f, 1.7f, -0.1f, 0, -87.0f,
    -0.1f,-0.6f, 2.0f, 0, -87.0f,
    0, 0, 0, 1.0f, 0 };

//锐化
const float colormatrix_ruise[] = {
    4.8f,-1.0f, -0.1f, 0,-388.4f,
    -0.5f,4.4f, -0.1f, 0,-388.4f,
    -0.5f,-1.0f, 5.2f, 0,-388.4f,
    0, 0, 0, 1.0f, 0 };


//淡雅
const float colormatrix_danya[] = {
    0.6f,0.3f, 0.1f, 0,73.3f,
    0.2f,0.7f, 0.1f, 0,73.3f,
    0.2f,0.3f, 0.4f, 0,73.3f,
    0, 0, 0, 1.0f, 0 };

//酒红
const float colormatrix_jiuhong[] = {
    1.2f,0.0f, 0.0f, 0.0f,0.0f,
    0.0f,0.9f, 0.0f, 0.0f,0.0f,
    0.0f,0.0f, 0.8f, 0.0f,0.0f,
    0, 0, 0, 1.0f, 0 };

//清宁
const float colormatrix_qingning[] = {
    0.9f, 0, 0, 0, 0,
    0, 1.1f,0, 0, 0,
    0, 0, 0.9f, 0, 0,
    0, 0, 0, 1.0f, 0 };

//浪漫
const float colormatrix_langman[] = {
    0.9f, 0, 0, 0, 63.0f,
    0, 0.9f,0, 0, 63.0f,
    0, 0, 0.9f, 0, 63.0f,
    0, 0, 0, 1.0f, 0 };

//光晕
const float colormatrix_guangyun[] = {
    0.9f, 0, 0,  0, 64.9f,
    0, 0.9f,0,  0, 64.9f,
    0, 0, 0.9f,  0, 64.9f,
    0, 0, 0, 1.0f, 0 };

//蓝调
const float colormatrix_landiao[] = {
    2.1f, -1.4f, 0.6f, 0.0f, -31.0f,
    -0.3f, 2.0f, -0.3f, 0.0f, -31.0f,
    -1.1f, -0.2f, 2.6f, 0.0f, -31.0f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

//梦幻
const float colormatrix_menghuan[] = {
    0.8f, 0.3f, 0.1f, 0.0f, 46.5f,
    0.1f, 0.9f, 0.0f, 0.0f, 46.5f,
    0.1f, 0.3f, 0.7f, 0.0f, 46.5f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

//夜色
const float colormatrix_yese[] = {
    1.0f, 0.0f, 0.0f, 0.0f, -66.6f,
    0.0f, 1.1f, 0.0f, 0.0f, -66.6f,
    0.0f, 0.0f, 1.0f, 0.0f, -66.6f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

@interface VideoRecordController ()
<
    VCaptureDelegate
>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) VCapture *capture;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation VideoRecordController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(originAni) name:UIDeviceOrientationDidChangeNotification object:nil];
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.imageView];
    self.capture = [[VCapture alloc] init];
    self.capture.delegate = self;
    __weak typeof(self) weakSelf = self;
    [self.capture setEffectBufferHandler:^(CVImageBufferRef buffer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf effectWithBuffer:buffer];
    }];
    
//    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.capture.session];
//    self.previewLayer.frame = self.view.bounds;
//    [self.view.layer addSublayer:self.previewLayer];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [self.capture startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.capture stopRunning];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [super viewWillDisappear:animated];
}

- (void)effectWithBuffer:(CVImageBufferRef)buffer {
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
//    size_t width = CVPixelBufferGetWidth(buffer);
//    size_t height = CVPixelBufferGetHeight(buffer);
//    unsigned char *baseAddress = CVPixelBufferGetBaseAddress(buffer);
//    for (size_t i = 0; i < height; i++) {
//        for (size_t j = 0; j < width; j += 4) {
//            NSInteger offset = i * bytesPerRow + j * 4;
//            
////            UInt8 red = (unsigned char)baseAddress[offset];
////            UInt8 green = (unsigned char)baseAddress[offset+1];
////            UInt8 blue = (unsigned char)baseAddress[offset+2];
////            UInt8 alpha = (unsigned char)baseAddress[offset+3];
//            
//            int red = (unsigned char)baseAddress[offset];
//            int green = (unsigned char)baseAddress[offset+1];
//            int blue = (unsigned char)baseAddress[offset+2];
//            int alpha = (unsigned char)baseAddress[offset+3];
//            red = (UInt8)MAX((red + 100), 255);
//            green = (UInt8)MAX((green + 100), 255);
//            blue = (UInt8)MAX((blue + 100), 255);
////            NSLog(@"AAAA : %d : %d : %d : %d",red,green,blue,alpha);
////            changeRGBA(&red, &green, &blue, &alpha, colormatrix_heibai);
////            NSLog(@"BBBB : %d : %d : %d : %d",red,green,blue,alpha);
//            baseAddress[offset] = red;
//            baseAddress[offset+1] = green;
//            baseAddress[offset+2] = blue;
//            baseAddress[offset+3] = alpha;
//        }
//    }
}

static void changeRGBA(int *red,int *green,int *blue,int *alpha, const float* f)//修改RGB的值
{
    int redV = *red;
    int greenV = *green;
    int blueV = *blue;
    int alphaV = *alpha;
    *red = f[0] * redV + f[1] * greenV + f[2] * blueV + f[3] * alphaV + f[4];
    *green = f[0+5] * redV + f[1+5] * greenV + f[2+5] * blueV + f[3+5] * alphaV + f[4+5];
    *blue = f[0+5*2] * redV + f[1+5*2] * greenV + f[2+5*2] * blueV + f[3+5*2] * alphaV + f[4+5*2];
    *alpha = f[0+5*3] * redV + f[1+5*3] * greenV + f[2+5*3] * blueV + f[3+5*3] * alphaV + f[4+5*3];
    
    if (*red > 255)
    {
        *red = 255;
    }
    if(*red < 0)
    {
        *red = 0;
    }
    if (*green > 255)
    {
        *green = 255;
    }
    if (*green < 0)
    {
        *green = 0;
    }
    if (*blue > 255)
    {
        *blue = 255;
    }
    if (*blue < 0)
    {
        *blue = 0;
    }
    if (*alpha > 255)
    {
        *alpha = 255;
    }
    if (*alpha < 0)
    {
        *alpha = 0;
    }
}

- (void) captureImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void) originAni {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self.capture updateOrientation:self.interfaceOrientation];
//    AVCaptureConnection *connect = self.previewLayer.connection;
//    connect.videoOrientation = (AVCaptureVideoOrientation)self.interfaceOrientation;
    self.imageView.frame = self.view.bounds;
}

@end
