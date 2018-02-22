//
//  UILabel+Boldify.h
//  JKAlertDialog
//
//  Created by PKS on 4/21/15.
//  Copyright (c) 2015 www.skyfox.org. All rights reserved.
//

#ifndef JKAlertDialog_UILabel_Boldify_h
#define JKAlertDialog_UILabel_Boldify_h
#import <UIKit/UIKit.h>

@interface UILabel (Boldify)
- (void) boldSubstring: (NSString*) substring;
- (void) boldRange: (NSRange) range;
@end

#endif
