//
//  AddNoteViewController.h
//  Notebook
///Users/smk/Documents/Notebook/AddNoteViewController.h


#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface AddNoteViewController : UIViewController
{
    sqlite3 *noteDB;
    NSString *databasePath;
}

@property (retain, nonatomic) IBOutlet UITextField *whenField;
@property (retain, nonatomic) IBOutlet UITextField *whereField;
@property (retain, nonatomic) IBOutlet UITextField *whatField;
@property (retain, nonatomic) IBOutlet UITextField *whoField;
@property (retain, nonatomic) IBOutlet UITextView *noteView;
- (IBAction)addNote:(id)sender;

@end
