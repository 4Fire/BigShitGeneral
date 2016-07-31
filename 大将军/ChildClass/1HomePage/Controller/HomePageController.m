//
//  HomePageController.m
//  大将军
//
//  Created by 石燚 on 16/7/6.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "HomePageController.h"
#import "CalendarView.h"
#import "DoggyCollectionView.h"
#import "InfomationTableView.h"
#import "Owner.h"
#import "Dog.h"
#import "Context.h"
#import "DoggyModel.h"
#import "DoggyInfoController.h"
#import "TableCellInfoController.h"

@interface HomePageController ()<CalendarDelegate,doggyCollectionDelegate,InfomationTableDelegate>

//日历
@property (nonatomic, strong) CalendarView *calendar;
//doggy
@property (nonatomic, strong) DoggyCollectionView *doggyCollection;
//信息
@property (nonatomic, strong) InfomationTableView *infomationTable;
//狗狗信息
@property (nonatomic, strong) DoggyInfoController *doggyInfoController;

//用户信息
@property (nonatomic, strong) Owner *owner;

//信息字典
@property (nonatomic, strong) NSArray *infoMationArray;

//移动到今天
@property (nonatomic, strong) UIButton *todayBtn;
@property (nonatomic, strong) UIBarButtonItem *todayItem;

@end

@implementation HomePageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //导航栏透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    //狗狗视图刷新
    [self.doggyCollection.collection reloadData];

    //分割线 透明
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //设置左边的个人中心按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"将军府" style:(UIBarButtonItemStyleDone) target:self action:@selector(didLeftBtn)];

}
//点击个人中心按钮
- (void)didLeftBtn {
    if ([self.delegate respondsToSelector:@selector(clickLeftBtn)]) {
        [self.delegate clickLeftBtn];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserDataSource];
    [self initUserInterface];
    
}

//初始化数据源
- (void)initUserDataSource {
   
}

//初始化界面
- (void)initUserInterface {
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    //添加日历
    [self.view addSubview:self.calendar];
    
    [self.navigationController.navigationBar setTintColor:COLOR(255, 255, 255)];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR(250, 205, 174),NSFontAttributeName:[UIFont boldSystemFontOfSize:28]}];
    
    //添加doggy
    [self.view addSubview:self.doggyCollection];
    
    //添加信息
    [self.view addSubview:self.infomationTable];



}

#pragma mark - method
//将今天的CELL放到中间
- (void)returnToday {
    [self.calendar scrollToCenter];
}

#pragma mark - delegate
//点击日历的代理
- (void)didselectDate {
//    self.tabBarController.selectedIndex = 1;
}

//点击infomation代理事件
- (void)InfomationTableView:(UITableView *)infoTable didSelectIndepathForCell:(NSIndexPath *)indexPath {
#warning 夏雨---
    TableCellInfoController *TCC = [[TableCellInfoController alloc]init];
    TCC.infoDic = self.infoMationArray[indexPath.row];
    [self.navigationController pushViewController:TCC animated:YES];
    
    
}

//点击选择了哪只狗狗的代理
- (void)didselectDoggy:(Dog *)dog {
    self.doggyInfoController.dog = dog;
    [self.navigationController pushViewController:self.doggyInfoController animated:YES];
}

#pragma mark - getter
//日历视图
- (CalendarView *)calendar {
    if (!_calendar) {
        _calendar = [[CalendarView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT / 7)];
        _calendar.delegate = self;
    }
    return _calendar;
}

//狗狗collection
- (DoggyCollectionView *)doggyCollection {
    if (!_doggyCollection) {
        
        NSArray *test = [DoggyModel getAllDogsWithCurrentOwner];
        _doggyCollection = [[DoggyCollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.25, SCREEN_WIDTH, SCREEN_HEIGHT * 0.25) WithDoggyArray:test];
        _doggyCollection.delegate = self;
    }
    return _doggyCollection;
}

//信息的tableveiw
- (InfomationTableView *)infomationTable {
    if (!_infomationTable) {
        _infomationTable = [[InfomationTableView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.5, SCREEN_WIDTH, SCREEN_HEIGHT / 2 - self.tabBarController.tabBar.bounds.size.height)];
        _infomationTable.backgroundColor = BACKGROUNDCOLOR;
        _infomationTable.delegate = self;
        
    }
    return _infomationTable;
}

//主人
- (Owner *)owner {
    if (!_owner) {
        _owner = [DoggyModel getOwnerInfo];
    }
    return _owner;
}

//狗狗详细信息的页面
- (DoggyInfoController *)doggyInfoController {
    if (!_doggyInfoController) {
        _doggyInfoController = [[DoggyInfoController alloc]init];
    }
    return _doggyInfoController;
}

-(NSArray *)infoMationArray {
    if (!_infoMationArray) {
        
        _infoMationArray = @[
                             @{@"title":@"关于狗狗的16个冷知识",@"body":@[@"１：狗狗睡觉时总是爱蜷缩起        来，这其实是它们一个很古老的生存本能，这么做不仅可以保暖，也可以让它们的重要器官得到保护。",@"２：通    过抚摸你的狗狗，就可以降低血压。",@"３：狗狗的平均智商相当于两岁的儿童，它们能够学会多达250个单词和手势，数数可以数到5，还能进行简单的数学计算。",@"４：如果给你们家汪星人穿上你的衣服，那么残留在衣服上你的气味可以安抚它们焦躁的情绪。",@"５：你知道狗狗湿哒哒滑溜溜的鼻子上那些纹路是有什么用的吗？这其实和人类的指纹一样，可以起到识别的作用!",@"６：拉便便的时候，狗狗们很喜欢沿着地球的南北磁线拉。嘿嘿，这个很神奇吧。另外狗狗方便完之后扒地，其实是用它们爪子上的香腺来霸占领地。",@"７：狗的嗅觉比人类高10000多倍……",@"８：之前就觉得导盲犬强大，知道它们原来可以听命令来便便更是佩服得五体投地。有的狗狗经常是忍着不上厕所来延长遛狗的时间，非常有心机。",@"９：比格犬是最吵的狗狗。(还以为吉娃娃之类的小型犬才最吵闹呢。)",@"10：如果你看到你的狗狗在追着自己的尾巴咬，那么一定是因为下面几个原因：对尾巴好奇、锻炼身体、天生的，或者因为他们的尾巴上有跳蚤了。",@"11：斑点狗的宝宝刚生下来时全身都是白色的，雪白雪白的哦！到十多二十天左右那些黑点才慢慢地显现出来的。",@"12：狗狗在晚上能看到的东西，比人类多得多。",@"13：而且，狗狗能听到声音的距离是人类的4倍。",@"14：此外，狗狗还可以识别超过150个单词，不可思议吧！",@"15：很多人都认为拉布拉多是犬类中最出色的，因此成为了全球饲养率最高的犬种。",@"16：狗狗在喝水的时候会将舌头弯曲起来，变成一个小勺子在舀水，而不是我们平常认为的那样在舔啊舔的。"]},
                             @{@"title":@"夏日养狗要注意!",@"body":@[@"1、防止狗狗中暑：千万不要把毛孩独自留在汽车内。每年都有许多动物因中暑而导致大脑损伤，甚至死亡，就是因为主人在炎热的夏天将它们独自留在车内所致",@" 2、防止狗狗中毒：夏天里人们往往在草坪上和在花园里施肥、杀虫等，要特别注意这些东西。许多植物营养剂、化肥和杀虫剂都对动物有毒害作用，误食会引起中毒甚至死亡",@" 3、防止同类咬伤：在夏天里人和狗狗在外面活动的时间多，狗狗咬人和狗咬狗的情况屡屡发生。带狗狗出门应加强注意和戒备。给毛孩做绝育的话可以使它们的性格变温顺，会大大减少狗咬的机会，并且对它们本身健康方面也有很多的好处",@"4、防止寄生虫：夏天还需更加注意狗狗的驱虫问题，如跳蚤、蜱虫、心丝虫、蛔虫病和钩虫病等的预防，驱虫药不能间断，不要心存侥幸心理。心丝虫寄生在心脏内，会引起毛孩的死亡。跳蚤会引发许多皮肤问题。蜱虫还会感染各种血液疾病，严重会导致死亡",@"5、勤给新鲜干净的水与食物：当毛孩在户外奔跑玩耍之余，要注意给它们提供干净的饮用水和阴凉的地方。需要根据它们的运动量给予足够的水。并且因气温较高，狗狗的食物不要过夜，喜欢自制的家长们更要多多注意食物的质量问题，不要让毛孩误食变质的食物"]},
                             @{@"title":@"狗语翻译机",@"body":@[@"大多数的狗狗都非常善于叫，从低沉的呜咽到起伏的咆哮，直至特有的吠叫，狗狗用声音表达着自己的情绪，或告诉主人发生的状况，或震慑对方不要轻举妄动。总之，狗狗吠叫的原因有很多种，而且分别代表着不同的含义，如果主人能理解狗狗吠叫的含义，那就能避免很多麻烦。",@"1、持续性的急速吠叫，中音调---含义：“快来啊，有人侵入我们的领域！”这是狗狗的一种警报。",@"2、两声尖锐短促的吠叫，中音调---含义：“嗨，你好。”这是典型的打招呼的声音",@"3、单一尖锐短促的吠叫，音调较高---含义：“这是什么？”这是代表惊讶的意思，如果重复2-3遍，即是呼唤主人过去看看",@"4、冗长或者不间断的吠叫，其中间隔一段不算短的时间---含义：“有人在吗？我很孤单！”这是狗狗被关起来或落单以后最常见的反应。",@"5、单一尖锐短促的吠叫，低音调---含义：“别再那样做！”通常是母犬正在训导小狗时的声音，但也有可能是对其他的狗狗感到厌烦或者被主人弄疼（例如梳理毛发）时发出的声音。"]},
                             @{@"title":@"狗狗的“耳语”",@"body":@[@"有极少的人能够主动控制自己的耳朵动起来，这甚至可以作为炫耀的资本。但是，这在狗看来，这简直是可笑的。每只狗都可以轻松控制自己耳朵的形态和姿势。这是它们赖以生存的交流本领，因为它们无法像人类一样进行语言沟通。从某种意义上说，狗的耳朵是能够说话的。当然，狗耳朵语言是要配合身体其它部位的状态来表现的。最容易理解和判断耳朵语言的是直立的耳朵，让我们从直立耳开始了解这种奇妙的语言吧。",@"语言1：怎么了？——它被周围新的声音或现象吸引，聚精会神地观察。表现形态：耳朵直立，或者稍微向前倾",@"语言2：真有趣！——观察的同时，还在享受新的刺激。表现形态：耳朵直立前倾，头部倾斜或放松，嘴巴微张。",@"语言3：什么？——对新事物表示疑问。表现形态：合上嘴巴，眼睛半闭，尾巴可能还会低垂轻微摆动。",@"语言4：我准备开战，你考虑一下。——发布进攻的威胁信号。表现形态：皱起鼻子，露出牙齿。",@"语言5：我喜欢你，你很强大。——希望和平，表示屈从。表现形态：面部表情平和，耳朵向后平贴头顶。",@"语言6：我没有威胁，别伤害我。--明显的甘拜下风。表现形态：耳朵后贴的同时，后躯放低，尾巴大幅度摆动。",@"语言7：嘿，在这儿，我们一起玩玩！——友好的邀请。表现形态：张开嘴巴，眨动眼睛，高耸尾巴，也许还有时断时续的吠叫",@"语言8：我害怕，别再威胁我，否则我要反击。——恐慌，焦躁不安。表现形态：暴露牙齿。",@"语言9：我只是四处走走，不要对我有敌意。——举棋不定，更加恐惧和屈从，而且希望和平的愿望更强烈一些。表现形态：耳朵不停颤动，通常先向前伸，片刻向后向下伸。",]},
                             @{@"title":@"为啥狗狗老喜欢问屁股呢?",@"body":@[@" 虽然大家都知道狗的嗅觉比人类强!但是到底有多强? 实际上狗的嗅觉大约比人类还要敏感 1~10 万倍!这也是为什么狗狗可以利用超强嗅觉协助我们在灾区寻找生还者和在机场堵截追緝违禁品!",@"既然如此，为何要用超强的鼻子去闻彼此的屁屁呢? 答案是在”收集资讯”。 狗狗藉由闻彼此的味道来判断彼此的饮食、情绪、性別，等资讯。这就好像是气味在告诉其他人目前的状况。看来在狗狗的世界，个资跟本藏不住!",@"事实上在生物界有许多这类的，例如：蚂蚁、蜜蜂。1975年时，一位名为乔治普雷帝(Geogre Preti)的博士研究狗和野生狼的肛门分泌物，后门两侧各有一个小囊叫做肛门囊(anal sac)，这些囊內有许多的排泄腺体专门负责分泌化学物质好让其他的狗来了解对方，我们所闻到的狗气味主要就是从这个区域的大汗腺体(apocrine gland)和皮脂腺(sebaceous gland)所分泌出来的化学物质。",@" 产生狗气味的主要化学成分是三甲胺(trimethylamie)和一些短链酸(如：戊酸(valeric acid)、醋酸(acetic acid)、丙酸(propionic acid)、丁酸(butyric acid),等)。这些成分混合后会产生一种很浓厚、强烈、酸的气味;随着品种、饮食、及当时的情況状况的不同，他们的免疫系統也会影响这种气味的化学变化。",@"既然要判断的气味这么复杂，狗狗会不会被其他物质的气味影响?应该很难，因为狗狗超强的鼻子內有一个辅助嗅觉系統叫做“梨鼻器(Jacobson’s Organ)”，它专门就是用于化学讯息沟通!梨鼻器的神经会将接收的讯息直接传达至大脑，所以不会被其他气味给干饶。",@" 当饲主看到自己养的狗和其他狗在互闻时，先別急着打扰他们，那只是狗狗之间了解彼此的方式!"]}];
        
    }
    return _infoMationArray;
}

@end






