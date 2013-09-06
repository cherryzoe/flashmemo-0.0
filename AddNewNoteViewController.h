//
//  AddNewNoteViewController.h
//  Notebook

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface AddNewNoteViewController : UIViewController
{
    sqlite3 *newNoteDB;
    NSString *newDatabasePath;
}
@property (retain, nonatomic) IBOutlet UITextView *newText;

- (IBAction)saveNote:(id)sender;

@end

