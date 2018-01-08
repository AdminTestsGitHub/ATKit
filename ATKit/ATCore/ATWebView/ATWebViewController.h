//
//  ATWebViewController.h
//  MiLin
//
//  Created by AdminTest on 2017/9/22.
//Copyright © 2017年 AdminTest. All rights reserved.
//

@interface ATWebViewController : ATCommonViewController

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) BOOL hiddenMenu;

- (instancetype)initWithURLString:(NSString *)urlString hiddenMenu:(BOOL)hidden;
@end
