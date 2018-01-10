//
//  BABulletModel.m
//  BulletAnalyzer
//
//  Created by Zj on 17/6/3.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "BABulletModel.h"
#import "MJExtension.h"

@interface BABulletModel()
@property (nonatomic, assign, getter=isStatusReady) BOOL statusReady;

@end

@implementation BABulletModel

MJExtensionCodingImplementation

+ (NSArray *)mj_ignoredCodingPropertyNames{
    return @[@"statusReady"];
}

- (void)setIc:(NSString *)ic{
    _ic = ic;
    
    if (_ic.length) {
        NSString *urlStr = [ic stringByReplacingOccurrencesOfString:@"@S" withString:@"/"];
        urlStr = [BADouyuImgBaicUrl stringByAppendingString:urlStr];
        _iconSmall = [urlStr stringByAppendingString:BADouyuImgSmallSuffix];
        _iconMiddle = [urlStr stringByAppendingString:BADouyuImgMiddleSuffix];
        _iconBig = [urlStr stringByAppendingString:BADouyuImgBigSuffix];
    }
}


- (void)setNn:(NSString *)nn{
    _nn = [nn stringByReplacingOccurrencesOfString:@"@S" withString:@"/"];
    
    if (nn.length) {
        self.statusReady = _txt.length;
    }
}


- (void)setTxt:(NSString *)txt{
    _txt = txt;
    
    if (txt.length) {
        self.statusReady = _nn.length;
    }
}


- (void)setStatusReady:(BOOL)statusReady{
    _statusReady = statusReady;
    
    if (statusReady) {
        
        NSAttributedString *nameAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: ", _nn] attributes:@{
                                                                                                                 NSFontAttributeName : [UIFont systemFontOfSize:13],
                                                                                                                 NSForegroundColorAttributeName : [BAWhiteColor colorWithAlphaComponent:0.4],
                                                                                                                 NSBaselineOffsetAttributeName : @0.5
                                                                                                                 }];
        
        NSAttributedString *textAttr = [[NSAttributedString alloc] initWithString:_txt attributes:@{
                                                                                                   NSFontAttributeName : [UIFont systemFontOfSize:15],
                                                                                                   NSForegroundColorAttributeName : BAWhiteColor
                                                                                                   }];
        
        NSMutableAttributedString *contentAttr = [[NSMutableAttributedString alloc] init];
        [contentAttr appendAttributedString:nameAttr];
        [contentAttr appendAttributedString:textAttr];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [contentAttr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentAttr length])];
        
        _bulletContent = contentAttr;
        
        CGRect contentLabelRect = [contentAttr boundingRectWithSize:CGSizeMake(BAScreenWidth - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        _bulletContentHeight = contentLabelRect.size.height;
    }
}



@end
