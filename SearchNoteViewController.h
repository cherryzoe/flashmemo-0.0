//
//  SearchNoteViewController.h
//  Notebook
//


#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "NotebookInfo.h"
#import "DetailViewController.h"



 
@interface SearchNoteViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    sqlite3 *newNoteDB;
    NSString *newDatabasePath;
}

@property(strong,nonatomic) NSMutableArray *noteArray;
@property (strong, nonatomic) NewNotebookInfo * detailItem;

@end
