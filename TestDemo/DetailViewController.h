//
//  DetailViewController.h
//  TestDemo
//
//  Created by Fantasy on 16/9/8.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

