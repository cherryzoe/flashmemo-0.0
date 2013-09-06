//
//  AddNewNoteViewController.m
//  Notebook
//
//  Created by yueting zhao on 8/5/13.
//

#import "AddNewNoteViewController.h"

@interface AddNewNoteViewController ()

@end

@implementation AddNewNoteViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    
    
    //为屏幕增加手势，以隐藏键盘
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    recognizer.cancelsTouchesInView = NO;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:recognizer];
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    //获取document目录
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSLog(@"NewDocsDir-------:%@",docsDir);
    //构造数据库文件路径
    newDatabasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"NewNotebook.sqlite"]];
    NSLog(@"NewDatabasePath------:%@",newDatabasePath);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:newDatabasePath]==NO) {
        const char *dbpath = [newDatabasePath UTF8String];
        
        //创建数据库，并打开数据库
        //SQLite的策略是如果有该文件就打开,如果没有就创建文件,也就是创建数据库
        NSLog(@"22222222222");
        
        if (sqlite3_open(dbpath, &newNoteDB)==SQLITE_OK) {
            char *errMsg;
            const char *sql_str = "CREATE TABLE IF NOT EXISTS NewNotebook (ID INTEGER PRIMARY KEY AUTOINCREMENT,NewText TEXT)";
            //创建数据表Notebook
            if (sqlite3_exec(newNoteDB, sql_str, nil, nil, &errMsg) != SQLITE_OK) {
                NSLog(@"failed to create table");
            }
            //关闭数据库
            sqlite3_close(newNoteDB);
        }else{
            NSLog(@"failed to open/create database");
        }
    }
    self.title = @"新增资产";
}

// 点击return隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//点击屏幕其他位置隐藏键盘
- (void)hideKeyboard:(UITapGestureRecognizer *)recognizer
{
    [self.newText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_newText release];
    [super dealloc];
}


-(void)save{
char *errMsg;
const char *dbpath = [newDatabasePath UTF8String];
if (sqlite3_open(dbpath, &newNoteDB)==SQLITE_OK) {
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO NewNotebook(NewText)VALUES(\"%@\")",self.newText.text];
    const char *insert_stmt = [insertSQL UTF8String];
    if (sqlite3_exec(newNoteDB, insert_stmt, NULL, NULL, &errMsg)==SQLITE_OK) {
        self.newText.text = @"";
        
        [self doAlert:@"保存成功"];
    }else{
        NSLog(@"出入记录错误：%s",errMsg);
        sqlite3_free(errMsg);
    }
    sqlite3_close(newNoteDB);
}
}

- (IBAction)saveNote:(id)sender {
    [self save];
}

-(void)doAlert :(NSString *)inMessage{
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]initWithTitle:@"提示信息" message:inMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertDialog show];
}
@end
