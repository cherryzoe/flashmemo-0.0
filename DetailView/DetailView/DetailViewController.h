//
//  DetailViewController.h
//  DetailView
//
//  Created by yueting zhao on 8/26/13.
//  Copyright (c) 2013 yt zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
