//
//  HandwriteController.m
//  TestDemo
//
//  Created by Fantasy on 17/3/16.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "HandwriteController.h"

@interface HandwriteController ()

@end

@implementation HandwriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//插入数据库
//- (int)insertChar:(CharacterModel *)model {
//    int charId = 0;
//    [self.hanziDb executeUpdate:@"insert into characters(chinese, pinyin, pointsString) values(?,?,?)", model.chinese, model.pinyin, model.pointsString];
//    
//    NSString *queryString = [NSString stringWithFormat:@"select id from characters where chinese = '%@'", model.chinese];
//    FMResultSet* set = [self.hanziDb executeQuery:queryString];
//    
//    if([set next]) {
//        charId = [set intForColumn:@"id"];
//    }
//    for (int i=0; i<model.inputPointGrids.count; i++) {
//        NSArray *aStroke = model.inputPointGrids[i];
//        for (NSValue *aPointValue in aStroke) {
//            CGPoint aPoint = [aPointValue CGPointValue];
//            [self.hanziDb executeUpdate:@"insert into points(id, pointX, pointY, strokeid) values(?,?,?,?)", [NSNumber numberWithInt:charId],[NSNumber numberWithInt:(int)aPoint.x],[NSNumber numberWithInt:(int)aPoint.y], [NSNumber numberWithInt:i+1]];
//        }
//    }
//    return charId;
//}

//- (NSString *)query:(NSArray *)array {
//    NSString *queryString4 = [NSString stringWithFormat:@"select a.strokeid as strokeid,a.samecount as samecount,a.ucount as ucount,a.pcount as pcount from ( select strokeid, count(*) as samecount, (select count(*) from input_points where id=p.id and strokeid= %d ) as ucount, (select count(*) from points where id=p.id and strokeid=p.strokeid) as pcount from points p where exists(select * from input_points u where u.id=p.id and u.strokeid=%d and (abs(u.pointX-p.pointX) + abs(u.pointY-p.pointY))<2 ) and p.strokeid not in (%@) and p.id=%d group by strokeid ) a order by abs(a.pcount - a.samecount) asc", j, j, hasStrokeid, model.charID];
//}

@end
