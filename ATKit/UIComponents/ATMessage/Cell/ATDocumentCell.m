//
//  ATDocumentCell.m
//  MiLin
//
//  Created by AdminTest on 2017/8/15.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATDocumentCell.h"
#import "ATFileManager.h"

static CGFloat kMarginLeft = 115;

@interface ATDocumentCell ()

@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *fileNameLabel;
@property (nonatomic, weak) UILabel *sizeLabel;

@end


@implementation ATDocumentCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"docCell";
    ATDocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ATDocumentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

// 这里name是拼接后的全称
- (void)setName:(NSString *)name
{
    _name = name;
    
    NSString *type = [name pathExtension];
    NSString *path = [[ATFileManager fileMainPath] stringByAppendingPathComponent:name];
    self.filePath = path;

#warning admintest to do
    
//    self.fileNameLabel.text = [name originName];
//    self.sizeLabel.text = [ATFileManager filesize:path];
//    NSNumber *num = [ICMessageHelper fileType:type];
//    if (num == nil) {
//        self.imageV.image = [UIImage imageNamed:@"iconfont-wenjian"];
//    } else {
//        self.imageV.image = [ICMessageHelper allocationImage:[num intValue]];
//    }
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.selectBtn.frame = CGRectMake(15, 30, 20, 20);
    self.imageV.frame    = CGRectMake(55, 15, 50, 50);
    self.fileNameLabel.frame = CGRectMake(_imageV.maxX+10, 15, SCREEN_WIDTH-_imageV.maxX-10-40, 16);
    [_fileNameLabel sizeToFit];
    self.sizeLabel.frame = CGRectMake(_imageV.maxX+10,_imageV.maxY-15 , 100, 15);
    [_sizeLabel sizeToFit];
}


- (void)selectBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(chatCellClicked:)]) {
        [self.delegate chatCellClicked:sender];
    }
}

#pragma mark - Getter

- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        _selectBtn = btn;
        [_selectBtn setImage:[UIImage imageNamed:@"App_select_dis"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"App_select"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIImageView *)imageV
{
    if (!_imageV) {
        UIImageView *imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:imageV];
        _imageV = imageV;
    }
    return _imageV;
}

- (UILabel *)fileNameLabel
{
    if (!_fileNameLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        _fileNameLabel = label;
        _fileNameLabel.font = [UIFont systemFontOfSize:15.0];
        _fileNameLabel.numberOfLines = 2;
        _fileNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _fileNameLabel.textColor = UIColorMakeWithHex(@"000000");
    }
    return _fileNameLabel;
}

- (UILabel *)sizeLabel
{
    if (!_sizeLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        _sizeLabel = label;
        _sizeLabel.font = [UIFont systemFontOfSize:11.0];
        _sizeLabel.textColor = UIColorMakeWithHex(@"7e7e7e");
    }
    return _sizeLabel;
}



@end
