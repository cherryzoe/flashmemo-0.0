//
//  SearchNoteViewController.m
//  Notebook


#import "SearchNoteViewController.h"
#import "DetailViewController.h"


@interface SearchNoteViewController ()

@end

@implementation SearchNoteViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *docsDir;
    NSArray *dirPaths;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    newDatabasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"NewNotebook.sqlite"]];
    NSLog(@"dddddd");
    [self initializeDataToDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.noteArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"noteCell";
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = ((NewNotebookInfo *)[self.noteArray objectAtIndex:indexPath.row]).newText;
    cell.detailTextLabel.text = ((NewNotebookInfo *)[self.noteArray objectAtIndex:indexPath.row]).newText;
    
    NSLog(@"tableView");
    
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NewNotebookInfo *notebookInfo = [self.noteArray objectAtIndex:indexPath.row];
        [self removeNotebook:notebookInfo];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    [self.navigationController pushViewController:nil animated:YES];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

-(void)removeNotebook:(NewNotebookInfo *)notebookInfo
{
    sqlite3_stmt *statement;
    const char *sql = "delete from NewNotebook where id =?";
    
    //编译SQL语句，创建statement对象
    if (sqlite3_prepare_v2(newNoteDB, sql, -1, &statement, NULL)!=SQLITE_OK) {////////
        NSAssert1(0, @"Erroe while creating delete statement '%s'", sqlite3_errmsg(newNoteDB));
    }
    
    sqlite3_bind_int(statement, 1, notebookInfo.pk_id);
    if (sqlite3_step(statement)!=SQLITE_DONE) {
        NSAssert1(0, @"Error while deleting '%s'", sqlite3_errmsg(newNoteDB));
    }
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    
    [self.noteArray removeObject:notebookInfo];
}

-(void)initializeDataToDisplay
{
    self.noteArray = [[NSMutableArray alloc]init];
    const char *dbpath = [newDatabasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &newNoteDB)==SQLITE_OK) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT id,newText FROM NewNotebook"];
        const char *query_stmt = [querySql UTF8String];
        if (sqlite3_prepare_v2(newNoteDB, query_stmt, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NewNotebookInfo *notebookInfo = [[NewNotebookInfo alloc]init];
                notebookInfo.pk_id = sqlite3_column_int(statement, 0);
                notebookInfo.newText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [self.noteArray addObject:notebookInfo];
            }
        }else{
            NSLog(@"Problem with prepare statement is %s",sqlite3_errmsg(newNoteDB));
        }
        sqlite3_finalize(statement);
    }
}

- (void)dealloc {
   
    [super dealloc];
}






- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"test");
    DetailViewController *detailController =segue.destinationViewController;
    NewNotebookInfo * bug = [self.noteArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailController.detailItem = bug;
}





@end
