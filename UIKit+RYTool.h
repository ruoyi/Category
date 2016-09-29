//
//  UIKit+Extension.h
//  dailycare
//
//  Created by 若懿 on 15/12/16.
//  Copyright © 2015年 ruoyi. All rights reserved.
//


#import <UIKit/UIKit.h>

static inline CGFloat ry_resizeWidth(CGSize size, CGFloat height) {
    return size.width*height/size.height;
}

static inline CGFloat ry_resizeHeight(CGSize size, CGFloat width) {
    return size.height*width/size.width;
}

typedef NS_ENUM(NSUInteger, RYViewBorderEdge) {
    RYViewBorderEdgeTop,
    RYViewBorderEdgeLeft,
    RYViewBorderEdgeBottom,
    RYViewBorderEdgeRight,
};

typedef NS_ENUM(NSUInteger, RYLabelImagePosition) {
    RYLabelImagePositionBegin,
    RYLabelImagePositionEnd,
};

typedef NS_ENUM(NSInteger, RYBtnContentLayout) {
    RYBtnContentLayoutHTitleLeft, //文字+图片
    RYBtnContentLayoutVImageTop //图片在上，文字在下
};


#pragma mark - protocol

@protocol RYTableViewCellDate <NSObject>

@property (nonatomic, strong, nullable) id ry_cellData;

@property (nonatomic, weak, nullable) id ry_delegate;

@end

@protocol RYTableSectionViewProtocol <NSObject>

@property (nonatomic, strong, nullable) id ry_sectionData;

@property (nonatomic, weak, nullable) id ry_delegate;

- (CGFloat )ry_sectionHeight;

@end

#pragma mark - UITableView

@interface UITableView (RYTool)

@property (nonatomic, copy, nullable) NSDictionary *modelMatchCell;

- (void)ry_registerCellClass:(nullable Class)aClass modelName:(nullable NSString *)modelName;

- (void)ry_registerHeaderFooterViewClass:(nullable Class)aClass;


@end

#pragma mark - UIView

@interface UIView (RYTool)

+ (nullable instancetype)ry_loadWithNibName:(nullable NSString *)name owner:(nullable id)owner;

- (void)ry_setBorderEdge:(RYViewBorderEdge )edge width:(CGFloat )width color:(nullable UIColor *)color;

- (void)ry_setBorderEdge:(RYViewBorderEdge )edge width:(CGFloat )width color:(nullable UIColor *)color layer:(nullable CALayer *)border;

- (void)ry_setBorderWith:(CGFloat )aWith color:(nullable UIColor *)aColor cornerRadius:(float )aRadius;


@end

#pragma mark - UIViewController

@interface UIViewController (RYTool)

@property (nonatomic, strong, nullable) UIColor *ry_NaviBarColor;

@property (nonatomic, assign) BOOL ry_HiddenNaviShadow;

@property (nonatomic, assign) BOOL ry_HiddenNavBar;

- (BOOL)ry_isRootController;

@end

#pragma mark - UIImage

@interface UIImage (RYTool)

+ (nullable UIImage *)ry_ImageNamed:(nullable NSString *)imageName;

+ (nullable UIImage*)ry_imageWithColor:(nullable UIColor*)color;

@end

#pragma mark - UIButton

@interface UIButton (RYTool)

@property (nonatomic, copy, nullable) NSString *titleNormal;

@property (nonatomic, strong, nullable) UIColor *titleColorNormal;

//调用之前必须设置好文字与图片
- (void)ry_setContentLayout:(RYBtnContentLayout)layout;

+ (nullable instancetype)ry_buttonTitle:(nullable NSString * )title
						 color:(nullable UIColor *)color
						  font:(nullable UIFont *)font;

@end

#pragma mark - UILabel

@interface UILabel (RYTool)

- (void)ry_setAttributeText:(nullable NSString *)str color:(nullable UIColor *)color font:(nullable UIFont *)font;

- (void)ry_setImage:(nonnull UIImage *)image position:(RYLabelImagePosition)direction;

+ (nullable instancetype)ry_labelWithFont:(nullable UIFont *)font textColor:(nullable UIColor *)color;

+ (nullable instancetype)ry_labelWithFont:(nullable UIFont *)font
					   textColor:(nullable UIColor *)color
							text:(nullable NSString *)text;

+ (nullable instancetype)ry_labelWithFrame:(CGRect)frame
							 font:(nullable UIFont *)font
						textColor:(nullable UIColor *)color;

+ (nullable instancetype)ry_labelWithFrame:(CGRect)frame
                          font:(nullable UIFont *)font
                     textColor:(nullable UIColor *)color
                          text:(nullable NSString *)text;

@end


@interface UIStoryboard (RYTool)

+ (nullable instancetype)ry_mainSB;

@end


