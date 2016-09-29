//
//  UIKit+Extension.m
//  dailycare
//
//  Created by 若懿 on 15/12/16.
//  Copyright © 2015年 ruoyi. All rights reserved.
//

#import "UIKit+RYTool.h"

#import <objc/runtime.h>

#pragma mark - UITableView

@implementation UITableView (RYTool)

- (void)setModelMatchCell:(NSDictionary *)modelMatchCell{
	for (NSString *cellNameStr in [modelMatchCell allValues]) {
		[self ry_registerCellClass:NSClassFromString(cellNameStr)];
	}
	objc_setAssociatedObject(self, @selector(modelMatchCell), modelMatchCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)modelMatchCell {
	return objc_getAssociatedObject(self, @selector(modelMatchCell));
}

- (void)ry_registerCellClass:(nullable Class)aClass modelName:(NSString *)modelName {
	NSMutableDictionary *tempDic = [self.modelMatchCell mutableCopy];
	[tempDic setObject:modelName forKey:NSStringFromClass(aClass)];
	self.modelMatchCell = tempDic;
	[self ry_registerCellClass:aClass];
}

- (void)ry_registerCellClass:(nullable Class)aClass {
	[self registerClass:aClass forCellReuseIdentifier:NSStringFromClass(aClass)];
}

- (void)ry_registerHeaderFooterViewClass:(nullable Class)aClass {
	[self registerClass:aClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(aClass)];
}

@end


#pragma mark - UIView

@implementation UIView (RYTool)

- (void)ry_setCornerRadius:(CGFloat)roundRadius {
    self.layer.cornerRadius = roundRadius;
    [self.layer setMasksToBounds:YES];
}

- (void)ry_setBorderEdge:(RYViewBorderEdge )edge width:(CGFloat )width color:(UIColor *)color{
      [self ry_setBorderEdge:edge width:width color:color layer:[CALayer new]];
}


- (void)ry_setBorderEdge:(RYViewBorderEdge )edge width:(CGFloat )width color:(UIColor *)color layer:(CALayer *)border {
    CGRect frame;
    switch (edge) {
        case RYViewBorderEdgeTop:
            frame = CGRectMake(0, 0, self.frame.size.width, width);
            break;
        case RYViewBorderEdgeLeft:
            frame = CGRectMake(0, 0, width, self.frame.size.height);
            break;
        case RYViewBorderEdgeBottom:
            frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width);
            break;
        case RYViewBorderEdgeRight:
            frame = CGRectMake( self.frame.size.width - width,0, width, self.frame.size.height);
            break;
        default:
            frame = CGRectZero;
            break;
    };
	border.frame = frame;
    [self.layer layoutIfNeeded];
    border.backgroundColor = color.CGColor;
    [self.layer addSublayer:border];
}

- (void)ry_setBorderWith:(CGFloat )aWith color:(UIColor *)aColor cornerRadius:(float )aRadius{
    self.layer.borderWidth  = aWith;
    self.layer.borderColor = aColor.CGColor;
    self.layer.cornerRadius = aRadius;
    [self.layer setMasksToBounds:YES];
}

+ (instancetype)ry_loadWithNibName:(NSString *)name owner:(id)owner {
    UIView *view = [[NSBundle mainBundle] loadNibNamed:name owner:owner options:nil].firstObject;
    return view;
}

@end

#pragma mark - UIViewController

@implementation UIViewController (RYTool)

- (void)setRy_NaviBarColor:(UIColor *)ry_NaviBarColor{
	objc_setAssociatedObject(self, @selector(ry_NaviBarColor), ry_NaviBarColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self ry_reSetNaviBarbackColor:ry_NaviBarColor];
}

- (UIColor *)ry_NaviBarColor {
    UIColor *temp = objc_getAssociatedObject(self, @selector(ry_NaviBarColor));
    if (!temp) {
        temp = [UINavigationBar new].tintColor;
    }
    return temp;
}

- (void)setRy_HiddenNaviShadow:(BOOL)ry_HiddenNaviShadow {
    objc_setAssociatedObject(self, @selector(ry_HiddenNaviShadow), @(ry_HiddenNaviShadow), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ry_HiddenNaviShadow {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRy_HiddenNavBar:(BOOL)ry_HiddenNavBar {
    objc_setAssociatedObject(self, @selector(ry_HiddenNavBar), @(ry_HiddenNavBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ry_HiddenNavBar {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Method ry_viewAppear = class_getInstanceMethod([self class], @selector(ry_viewWillAppear:));
		Method viewAppear = class_getInstanceMethod([self class], @selector(viewWillAppear:));
		method_exchangeImplementations(viewAppear, ry_viewAppear);
	});
}

- (void)ry_viewWillAppear:(BOOL)animated {
    [self ry_reSetNaviBarbackColor:self.ry_NaviBarColor ];
	[self ry_viewWillAppear:animated];
}

- (void)ry_reSetNaviBarbackColor:(UIColor *)backColor {
    UINavigationBar *navigationbar = self.navigationController.navigationBar;
    UIView *backView = [navigationbar valueForKey:@"_backgroundView"];
    backView.backgroundColor = backColor;
    UIImageView *image = [backView valueForKey:@"_shadowView"];
    image.hidden = self.ry_HiddenNaviShadow;
    navigationbar.hidden = self.ry_HiddenNavBar;
    UIView *blur;
    blur = [backView valueForKey:@"_adaptiveBackdrop"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=10.0) {
        blur = [backView valueForKey:@"_backgroundEffectView"];
    }else {
        blur = [backView valueForKey:@"_adaptiveBackdrop"];
    }
    blur.hidden = YES;
}

- (BOOL)ry_isRootController {
    BOOL isRoot = NO;
    if (self.navigationController) {
        UIViewController *vc = self.navigationController.viewControllers.firstObject;
        if (vc == self) {
            isRoot = YES;
        }
    }
    return isRoot;
}


@end

#pragma mark - UIImage

@implementation UIImage (RYTool)
+ (UIImage *)ry_ImageNamed:(NSString *)imageName {
    return [UIImage imageNamed:imageName];
}

+ (UIImage*)ry_imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

#pragma mark - UIButton

@implementation UIButton (RYTool)

- (void)setTitleNormal:(NSString *)titleNormal {
    [self setTitle:titleNormal forState:UIControlStateNormal];
}

- (NSString *)titleNormal {
	return [self titleForState:UIControlStateNormal];
}

- (void)setTitleColorNormal:(UIColor *)titleColorNormal {
    [self setTitleColor:titleColorNormal forState:UIControlStateNormal];
}

- (UIColor *)titleColorNormal {
    return [self titleColorForState:UIControlStateNormal];
}

- (void)ry_setContentLayout:(RYBtnContentLayout)layout {
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeZero];
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    if (layout == RYBtnContentLayoutHTitleLeft) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width);
    } else if (layout == RYBtnContentLayoutVImageTop) {
        CGFloat totalHeight = imageSize.height + titleSize.height + 6;
        self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width);
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(totalHeight-titleSize.height), 0.0);
    }
}

+ (instancetype)ry_buttonTitle:(NSString *)title
						 color:(UIColor *)color
						  font:(UIFont *)font {
	return [self ry_buttonTitle:title color:color font:font image:nil];

}

+ (instancetype)ry_buttonTitle:(NSString *)title
						 color:(UIColor *)color
						  font:(UIFont *)font
						 image:(UIImage *)image{
	UIButton *btn = [UIButton new];
	if (title) {
		[btn setTitle:title forState:UIControlStateNormal];
	}
	if(color) {
		[btn setTitleColor:color forState:UIControlStateNormal];
	}
	if (font) {
		btn.titleLabel.font = font;
	}
	if (image) {
		[btn setImage:image forState:UIControlStateNormal];
	}
	return btn;
}

@end

#pragma mark - UILabel

@implementation UILabel (RYTool)

- (void)ry_setAttributeText:(NSString *)str color:(UIColor *)color font:(UIFont *)font{
    if (str.length<1) {
        return;
    }
    NSRange range = [self.attributedText.string rangeOfString:str options:NSCaseInsensitiveSearch];
    NSMutableAttributedString *as = [self.attributedText mutableCopy];
    if (font) {
        [as addAttribute:NSFontAttributeName
                   value:font
                   range:range];
    }
    if (color) {
        [as addAttribute:NSForegroundColorAttributeName
                   value:color
                   range:range];
    }
    self.attributedText = as;
}

- (void)ry_setImage:(nonnull UIImage *)image position:(RYLabelImagePosition)direction {
    [self ry_setImage:image position:direction adjustPosition:CGPointZero];
}

- (void)ry_setImage:(nonnull UIImage *)image position:(RYLabelImagePosition)direction adjustPosition:(CGPoint)adjustPosition{
    [self sizeToFit];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(adjustPosition.x, adjustPosition.y, image.size.width, image.size.height);
    NSMutableAttributedString *attrStr = [self.attributedText mutableCopy];
    NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:textAttachment];
    NSUInteger index = 0;
    if (direction == RYLabelImagePositionEnd) {
        index = self.text.length;
    }
    [attrStr insertAttributedString:att atIndex:index];
    self.attributedText = attrStr;
}

+ (instancetype)ry_labelWithFont:(UIFont *)font textColor:(UIColor *)color {
    return [self ry_labelWithFont:font textColor:color textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)ry_labelWithFont:(UIFont *)font textColor:(UIColor *)color textAlignment:(NSTextAlignment )alignment{
	return [self ry_labelWithFrame:CGRectZero font:font textColor:color text:nil textAlignment:NSTextAlignmentLeft];

}

+ (instancetype)ry_labelWithFont:(UIFont *)font
                    textColor:(UIColor *)color
                         text:(NSString *)text {
    
    return [self ry_labelWithFrame:CGRectZero font:font textColor:color text:text];
}

+ (instancetype)ry_labelWithFrame:(CGRect)frame
                          font:(UIFont *)font
                     textColor:(UIColor *)color {
    return [self ry_labelWithFrame:frame font:font textColor:color text:nil];
}

+ (instancetype)ry_labelWithFrame:(CGRect)frame
                          font:(UIFont *)font
                     textColor:(UIColor *)color
                          text:(NSString *)text {

    return [self ry_labelWithFrame:frame font:font textColor:color text:text textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)ry_labelWithFrame:(CGRect)frame
							 font:(UIFont *)font
						textColor:(UIColor *)color
							 text:(NSString *)text
					textAlignment:(NSTextAlignment )alignment{

	UILabel *label = [[self alloc]initWithFrame:frame];
	label.textAlignment = alignment;
    [label ry_setFont:font textColor:color];
	if (text) {
		label.text = text;
	}
	return label;
}

- (void)ry_setFont:(nullable UIFont *)font textColor:(nullable UIColor *)color {
    if (font) {
        self.font = font;
    }
    if (color) {
        self.textColor = color;
    }
}

@end


@implementation UIStoryboard (RYTool)

+ (instancetype)ry_mainSB {
    return [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
}

@end

