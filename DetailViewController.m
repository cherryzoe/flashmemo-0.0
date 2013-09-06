//
//  DetailViewController.m
//  Notebook
//
//  Created by yueting zhao on 8/26/13.
//  Copyright (c) 2013 smk. All rights reserved.
//

#import "DetailViewController.h"
#import "SearchNoteViewController.h" 

@interface DetailViewController ()


@end

@implementation DetailViewController;

@synthesize detailItem = _detailItem;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.detailText.text = _detailItem.newText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_detailText release];
    [super dealloc];
}

@end
