//
//  DetailViewController.h
//  Notebook
//
//  Created by yueting zhao on 8/26/13.
//  Copyright (c) 2013 smk. All rights reserved.
//

#import "SearchNoteViewController.h"


@interface DetailViewController : UIViewController

@property (strong, nonatomic) NewNotebookInfo * detailItem;

@property (retain, nonatomic) IBOutlet UITextView *detailText;



@end
