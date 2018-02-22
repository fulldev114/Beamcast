//
//  UILabel+Boldify.m
//  JKAlertDialog
//
//  Created by PKS on 4/21/15.
//  Copyright (c) 2015 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UILabel+Boldify.h"

@implementation UILabel (Boldify)
- (void)boldRange:(NSRange)range {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font.pointSize]} range:range];
    self.attributedText = attributedText;
}

- (void)boldSubstring:(NSString*)substring {
    if (substring.length == 0) {
        return;
    }
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range];
}
@end