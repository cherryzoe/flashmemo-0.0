//
//  AddNoteViewController.m
//  Notebook
//


#import "AddNoteViewController.h"

@interface AddNoteViewController ()

@end

@implementation AddNoteViewController


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
    NSLog(@"docsDir-------:%@",docsDir);
    //构造数据库文件路径
    databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"Notebook.sqlite"]];
    NSLog(@"databasePath------:%@",databasePath);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:databasePath]==NO) {
        const char *dbpath = [databasePath UTF8String];
        
        //创建数据库，并打开数据库
        //SQLite的策略是如果有该文件就打开,如果没有就创建文件,也就是创建数据库
        NSLog(@"1111111111111");
        
        if (sqlite3_open(dbpath, &noteDB)==SQLITE_OK) {
            char *errMsg;
            const char *sql_str = "CREATE TABLE IF NOT EXISTS Notebook (ID INTEGER PRIMARY KEY AUTOINCREMENT,Whattime Text,Address TEXT, What TEXT,Who TEXT,NOTE TEXT)";
            //创建数据表Notebook
            if (sqlite3_exec(noteDB, sql_str, nil, nil, &errMsg) != SQLITE_OK) {
                NSLog(@"failed to create table");
            }
            //关闭数据库
            sqlite3_close(noteDB);
        }else{
            NSLog(@"failed to open/create database");
        }
    }
    self.title = @"新增记事日志";
}

// 点击return隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//点击屏幕其他位置隐藏键盘
- (void)hideKeyboard:(UITapGestureRecognizer *)recognizer
{
    [self.whatField resignFirstResponder];
    [self.whereField resignFirstResponder];
    [self.whoField resignFirstResponder];
    [self.whenField resignFirstResponder];
    [self.noteView resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_whenField release];
    [_whereField release];
    [_whatField release];
    [_whoField release];
    [_noteView release];
    [super dealloc];
}
- (IBAction)addNote:(id)sender {
    char *errMsg;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &noteDB)==SQLITE_OK) {
          NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Notebook(Whattime,Address,What,Who,Note)VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",self.whenField.text,self.whereField.text,self.whatField.text,self.whoField.text,self.noteView.text];
        const char *insert_stmt = [insertSQL UTF8String];
        if (sqlite3_exec(noteDB, insert_stmt, NULL, NULL, &errMsg)==SQLITE_OK) {
            self.whenField.text = @"";
            self.whereField.text = @"";
            self.whoField.text = @"";
            self.whatField.text = @"";
            self.noteView.text = @"";
            [self doAlert:@"添加成功"];
        }else{
            NSLog(@"出入记录错误：%s",errMsg);
            sqlite3_free(errMsg);
        }
        sqlite3_close(noteDB);
    }
     
}
-(void)doAlert :(NSString *)inMessage{
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]initWithTitle:@"提示信息" message:inMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertDialog show];
}



@end
