//
//  RImageColorBtn.h
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

@interface RImageColorBtn : UIButton
-(id)initWithFrameImageColorTitle:(CGRect)frame btnImage:(NSString *)imageName btnColor:(UIColor *)btnColor titleColor:(UIColor *)titleColor btnTitle:(NSString *)title;
@end
