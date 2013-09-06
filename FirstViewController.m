//
//  FirstViewController.m
//  Notebook
//
//  Created by yueting zhao on 8/20/13.
//  Copyright (c) 2013 smk. All rights reserved.
//

#import "FirstViewController.h"


#import "KxMenu.h"


@interface FirstViewController ()
@end

@implementation FirstViewController 

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    

    
    //[KxMenu setTintColor: [UIColor colorWithRed:15/255.0f green:97/255.0f blue:33/255.0f alpha:1.0]];
    //[KxMenu setTitleFont:[UIFont systemFontOfSize:14]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    

    

}

- (void) pushMenuItem:(id)sender
{
    // NSLog(@"%@", sender);
}


- (IBAction)buttonPressed:(UIButton *)sender {
    
    
    NSArray *menuItems =
    @[
            
      [KxMenuItem menuItem:@"文本"
                     image:[UIImage imageNamed:@"text.png"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"语音"
                     image:[UIImage imageNamed:@"microphone.png"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"拍照"
                     image:[UIImage imageNamed:@"webcam.png"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"附件"
                     image:[UIImage imageNamed:@"attachment1.png"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      ];
    
    KxMenuItem *first = menuItems[1];
    //first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detailController =segue.destinationViewController;
    NewNotebookInfo * bug = [self.noteArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailController.detailItem = bug;
}

@end
