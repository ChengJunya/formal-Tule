//
//  RImageBtn.h
//  HiddenTalk
//
//  Created by Rainbow on 8/12/13.
//  Copyright (c) 2013 MST. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////// MST INC //////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
//          ____________      ____________     ________________  ____     _________________________   //
//         /            \    /           /    /    ___________ \/   /    /                        /   //
//        /____          \  /       ____/    |    /           \____/    /   _____       _____    /    //
//            /   /\      \/   /|   |        |    |_______________     /___/    /      /    /___/     //
//           /   /  \         / |   |        |                    \            /      /               //
//          /   /    \       /  |   |         \________________    |          /      /                //
//     ____/   /____  \     /___|   |____     ____             |   |     ____/      /____             //
//    /            /   \   //           /    /    \____________/   |    /               /             //
//   /____________/     \_//___________/    /___/\________________/    /_______________/              //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////// Copyright (c) 2014 MST Inc. All rights reserved. /////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>

@interface RImageBtn : UIButton

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) NSDictionary *itemData;

-(id)initWithFrameImageTitle:(CGRect)frame btnImage:(NSString *)imageName btnTitle:(NSString *)title;
-(id)initWithFrameImage:(CGRect)frame btnImage:(UIImage *)image btnTitle:(NSString *)title;

-(id)initWithFrameImageStateTitle:(CGRect)frame btnImage:(NSString *)imageName selectedImage:(NSString *)selectedImageName highLightedImage:(NSString *)highLightedImageName btnTitle:(NSString *)title;
-(id)initWithFrameImageStateTitle:(CGRect)frame btnImage:(NSString *)imageName selectedImage:(NSString *)selectedImageName highLightedImage:(NSString *)highLightedImageName btnTitle:(NSString *)title titleColor:(UIColor *)titleColor titleTextAlignment:(NSInteger)textAlign;
-(void)changeTitleImage:(NSString*)title image:(NSString*)imageName;
-(id)initWithFrameImageATitle:(CGRect)frame btnImage:(NSString *)imageName btnTitle:(NSMutableAttributedString *)title;

@end
