

#import "BankSelectViewCell.h"


@interface BankSelectViewCell()

@property(strong, nonatomic)UILabel *nameLabel;
@property(strong, nonatomic)UILabel *typeLabel;
@property(strong, nonatomic)UIImageView *bgImageView;
@property(strong, nonatomic)UIImageView *headImageView;
@property(strong, nonatomic)UILabel *cardNumLabel;

@end

@implementation BankSelectViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    
    _bgImageView = [[UIImageView alloc]init];
//    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_bgImageView];
    
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.layer.cornerRadius = STWidth(35/2);
    _headImageView.layer.masksToBounds = YES;
    [_bgImageView addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:cwhite backgroundColor:nil multiLine:NO];
    [_nameLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(15)]];
    [_bgImageView addSubview:_nameLabel];
    
    _typeLabel = [[UILabel alloc]initWithFont:STFont(12) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:cwhite backgroundColor:nil multiLine:NO];
    [_bgImageView addSubview:_typeLabel];
    
    _cardNumLabel = [[UILabel alloc]initWithFont:STFont(12) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:cwhite backgroundColor:nil multiLine:NO];
    [_bgImageView addSubview:_cardNumLabel];
    
    _selectImageView = [[UIImageView alloc]init];
    _selectImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_selectImageView];
}

-(void)updateData:(BankModel *)model{
    if(model.isPublic == 2){
        //微信UI
        _bgImageView.frame = CGRectMake(STWidth(22), STHeight(10),STWidth(303) , STHeight(90));
        _bgImageView.image = [UIImage imageNamed:IMAGE_BANK_WECHAT_BG];
        
        _selectImageView.frame = CGRectMake(ScreenWidth - STWidth(31), (STHeight(90) - STWidth(16))/2, STWidth(16), STWidth(16));
        
        if(!IS_NS_STRING_EMPTY(model.headUrl)){
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
        }else{
            _headImageView.image = [UIImage imageNamed:IMAGE_WECHAT_DEFAULT];
        }
        _headImageView.frame = CGRectMake(STWidth(15), (STHeight(90) - STWidth(35))/2, STWidth(35), STWidth(35));
        
        _nameLabel.text = model.bankName;
        CGSize nameSize = [_nameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        _nameLabel.frame = CGRectMake(STWidth(60), STHeight(26), nameSize.width, STHeight(21));
        
        _typeLabel.text = model.accountName;
        CGSize typeSize = [_typeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(12)];
        _typeLabel.frame = CGRectMake(STWidth(60), STHeight(46), typeSize.width, STHeight(17));
    }else{
        //银行卡UI
        _bgImageView.frame = CGRectMake(STWidth(22), STHeight(10),STWidth(303) , STHeight(114));
        _bgImageView.image = [UIImage imageNamed:IMAGE_BANK_BANK_BG];
        
        _selectImageView.frame = CGRectMake(ScreenWidth - STWidth(31), (STHeight(114) - STWidth(16))/2, STWidth(16), STWidth(16));
        
        _headImageView.frame = CGRectMake(STWidth(15), STHeight(22), STWidth(35), STWidth(35));
        _headImageView.image = [UIImage imageNamed:IMAGE_BANK_DEFAULT];
        
        _nameLabel.text = model.bankName;
        CGSize nameSize = [_nameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        _nameLabel.frame = CGRectMake(STWidth(60), STHeight(20), nameSize.width, STHeight(21));
        
        if(model.isPublic == 1){
            _typeLabel.text = MSG_BK_DUIGONG_TYPE;
        }else{
            _typeLabel.text = MSG_BK_GEREN_TYPE;
        }
        CGSize typeSize = [_typeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(12)];
        _typeLabel.frame = CGRectMake(STWidth(60), STHeight(40), typeSize.width, STHeight(17));
        
        NSString *bankId = model.bankId;
        if(!IS_NS_STRING_EMPTY(bankId) && bankId.length > 4){
            _cardNumLabel.text = [NSString stringWithFormat:@"• • • •  • • • •  • • • •  %@",[bankId substringWithRange:NSMakeRange(bankId.length-4, 4)]];
            CGSize cardNumSize = [_cardNumLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(12)];
            _cardNumLabel.frame = CGRectMake(STWidth(15), STHeight(77), cardNumSize.width, STHeight(17));
        }
    }

    if(model.isSelect){
        _selectImageView.image = [UIImage imageNamed:IMAGE_SELECT_ALL];
    }else{
        _selectImageView.image = [UIImage imageNamed:IMAGE_SELECT_NOAMAL];
    }
    
}

+(NSString *)identify{
    return NSStringFromClass([BankSelectViewCell class]);
}

@end
