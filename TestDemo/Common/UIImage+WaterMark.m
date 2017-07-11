//
//  UIImage+WaterMark.m
//  WaterMark
//
//  Created by Fantasy on 17/2/14.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "UIImage+WaterMark.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

@implementation WaterMarkAttribute

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setupDefaultProperty];
    }
    return self;
}

- (void) setupDefaultProperty {
    self.fontSize = 16.f;
    self.color = [UIColor whiteColor];
}

- (void) setFontSize:(CGFloat)fontSize {
    if (fontSize <= 0) {
        _fontSize = 16.f;
    }
    _fontSize = fontSize;
}

- (void) setColor:(UIColor *)color {
    if (color == nil) {
        _color = [UIColor whiteColor];
    }
    _color = [color copy];
}

@end

@implementation UIImage (WaterMark)

- (WaterMarkAttribute *)waterMarkAttribute {
    WaterMarkAttribute *attr = objc_getAssociatedObject(self, "waterMarkAttribute");
    if (attr == nil) {
        attr = [[WaterMarkAttribute alloc] init];
        objc_setAssociatedObject(self, "waterMarkAttribute", attr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return attr;
}
- (UIImage *)watermarkImageWithText:(NSString *)text {
    UIImage *maskImage = [self maskImageWithText:text];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions(self.size ,NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    } else {
        UIGraphicsBeginImageContext(self.size);
    }
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    [maskImage drawInRect:CGRectMake(self.size.width - maskImage.size.width,
                                     self.size.height - maskImage.size.height,
                                     maskImage.size.width,
                                     maskImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (CGRect) drawRectWithTextSize:(CGSize)textSize
                      attribute:(WaterMarkAttribute *)attribute
{
    CGPoint offset = CGPointZero;
    if (CGRectEqualToRect(attribute.drawRect, CGRectZero)) {
        offset = attribute.offset;
    } else {
        CGPoint offset = CGPointZero;
        if (CGRectGetMaxX(attribute.drawRect) > self.size.width) {
            offset.x = attribute.offset.x;
        }
        if (CGRectGetMaxY(attribute.drawRect) > self.size.height) {
            offset.y = attribute.offset.y;
        }
    }
    if (CGRectEqualToRect(attribute.drawRect, CGRectZero)) {
        return CGRectMake(self.size.width - textSize.width - attribute.offset.x,
                          self.size.height - textSize.height - attribute.offset.y,
                          textSize.width,
                          textSize.height);

    } else {
        return attribute.drawRect;
    }
}

- (UIImage *) maskImageWithText:(NSString *)text {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    //文字的属性
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:self.waterMarkAttribute.fontSize],
                          NSParagraphStyleAttributeName:style,
                          NSForegroundColorAttributeName:self.waterMarkAttribute.color,
                          NSBackgroundColorAttributeName : [UIColor clearColor]
                          };
    CGSize textSize = self.waterMarkAttribute.drawRect.size;
    if (CGSizeEqualToSize(textSize, CGSizeZero)) {
        textSize = [text sizeWithAttributes:dic];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions(textSize ,NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    } else {
        UIGraphicsBeginImageContext(textSize);
    }
    [text drawInRect:CGRectMake(0.f, 0.f, textSize.width, textSize.height) withAttributes:dic];
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return maskImage;
}

//- (UIImage *) addText:(NSString *)text {
//    int w = self.size.width;
//    int h = self.size.height;
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    CGContextRef context = CGBitmapContextCreate(NULL,
//                                                 w,
//                                                 h,
//                                                 8,
//                                                 4 * w,
//                                                 colorSpace,
//                                                 kCGImageAlphaPremultipliedFirst);
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
//    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1.0);
//    char *charText = (char *)[text cStringUsingEncoding:NSASCIIStringEncoding];
//    CGContextSelectFont(context, "Georgia", 30, kCGEncodingMacRoman);
////    CTFontDrawGlyphs(<#CTFontRef  _Nonnull font#>, <#const CGGlyph *glyphs#>, <#const CGPoint *positions#>, <#size_t count#>, context);
//    CGContextSetTextDrawingMode(context, kCGTextFill);//设置字体绘制方式
//    CGContextSetRGBFillColor(context, 255, 0, 0, 1);//设置字体绘制的颜色
//    CGContextShowTextAtPoint(context, w/2-strlen(charText)*5, h/2, charText, strlen(charText));//设置字体绘制的位置
//    //Create image ref from the context
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);//创建CGImage
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    return [UIImage imageWithCGImage:imageMasked];//获得添加水印后的图片
//}

-(UIImage *)addTextImage:(UIImage *)logo
{
    //get image width and height
    int w = self.size.width;
    int h = self.size.height;
    int logoWidth = logo.size.width;
    int logoHeight = logo.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
//    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, self.size.width / 2.f, self.size.height / 2.f);
    CGContextRotateCTM(context, M_PI_4);
    CGContextDrawImage(context, CGRectMake(- logoWidth / 2.f, -logoHeight / 2.f, logoWidth, logoHeight), [logo CGImage]);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
    // CGContextDrawImage(contextRef, CGRectMake(100, 50, 200, 80), [smallImg CGImage]);
}

- (UIImage *)watermarkImageWithName:(NSString *)name
{
    int w = self.size.width;
    int h = self.size.height;
    int hypotenuse = 0;//画布对角边长
    float font = self.waterMarkAttribute.fontSize;
    hypotenuse = sqrt(w*w + h*h);
    name = [name stringByAppendingString:@""];
    int i = 0;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    //文字的属性
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:font * (w / [[UIScreen mainScreen] bounds].size.width)],
                          NSParagraphStyleAttributeName:style,
                          NSForegroundColorAttributeName:self.waterMarkAttribute.color,
                          NSBackgroundColorAttributeName : [UIColor clearColor]
                          };
    
    while (i < 10)
    {//水印循环布满整个屏幕
        i++;
        
        CGSize detailSize = [name sizeWithAttributes:dic];
        if (detailSize.width > hypotenuse)
        {
            break;
        }
        name = [name stringByAppendingString:name];
    }
    
    
    UIGraphicsBeginImageContext(self.size);
    
    
    [self drawInRect:CGRectMake(0, 0, w, h)];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    MyDrawText(context, CGRectMake(0, 0, w, h),name,font);
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}


void MyDrawText (CGContextRef myContext, CGRect contextRect ,NSString *waterStr,float font) // 1


{
    CGFloat w, h;
    w = contextRect.size.width;
    h = contextRect.size.height;
     // 2
    CGContextSetCharacterSpacing (myContext, 0); // 4
    CGContextSetTextDrawingMode (myContext, kCGTextFillStroke); // 5
    CGContextSetRGBFillColor (myContext, 0, 0, 1, 0.55); // 6
    CGContextSetRGBStrokeColor (myContext, 0, 0, 1, 0.55); // 7
    CGAffineTransform myTextTransform =CGAffineTransformMakeRotation ((M_PI * 0.25)); // 8选择文字M_PI为π-180°
    CGContextSetTextMatrix (myContext, myTextTransform); // 9
    //
    UniChar *characters;
    CGGlyph *glyphs;
    CFIndex count;
    CTFontRef ctFont = CTFontCreateWithName(CFSTR("STHeitiSC-Light"), font, NULL);//
    CTFontDescriptorRef ctFontDesRef = CTFontCopyFontDescriptor(ctFont);
    CFNumberRef pointSizeRef = (CFNumberRef)CTFontDescriptorCopyAttribute(ctFontDesRef,kCTFontSizeAttribute);
    CGFontRef cgFont = CTFontCopyGraphicsFont(ctFont,&ctFontDesRef );
    CGContextSetFont(myContext, cgFont);
    CGFloat fontSize = font;
    NSString* str2 = waterStr;
    CFNumberGetValue(pointSizeRef, kCFNumberCGFloatType,&fontSize);
    CGContextSetFontSize(myContext, fontSize * (w / [[UIScreen mainScreen] bounds].size.width));//z字体大小并不是字号
    CGContextSetAlpha(myContext, 0.55);
    count = CFStringGetLength((CFStringRef)str2);
    characters = (UniChar *)malloc(sizeof(UniChar) * count);
    glyphs = (CGGlyph *)malloc(sizeof(CGGlyph) * count);
    CFStringGetCharacters((CFStringRef)str2, CFRangeMake(0, count), characters);
    CTFontGetGlyphsForCharacters(ctFont, characters, glyphs, count);
    CGContextScaleCTM(myContext, 1, -1);//画出来的文字会颠倒，使用这个方法给倒回来，参数意思为真正绘图坐标 = 参数*设置的坐标
    CGContextMoveToPoint(myContext, w/2, h/2);
    CGContextShowGlyphsAtPoint(myContext, 0, -h/2, glyphs, str2.length);
    CGContextShowGlyphsAtPoint(myContext, 0, -h, glyphs, str2.length);
    CGContextShowGlyphsAtPoint(myContext, h /2, -h, glyphs, str2.length);
    free(characters);
    free(glyphs);//
    //CGContextShowTextAtPoint(myContext, 40, 40, "only english", 9); // 10
}

@end
