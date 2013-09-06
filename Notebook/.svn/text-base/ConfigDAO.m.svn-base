//
//  ConfigDAO.m
//  BuleBoard
//


#import "ConfigDAO.h"
#import "Config.h"

@implementation ConfigDAO

- (BOOL) insert:(NSObject *)obj
{
    if (obj == nil) {
        return FALSE;
    }
    
    Config * con = (Config *)obj;
    NSString *sql = [NSString stringWithFormat: @"INSERT INTO CONFIG (KEYWORD, VALUE) VALUES ('%@', '%@')", [self convertNilString:con.keyword], [self convertNilString:con.value]];
    BOOL result = [self executeSQL:sql];
    if (result) {
        con.dbId = [self getLastInsertRowID];
    }
    
    return result;
}

- (BOOL) update:(NSObject *)obj
{
    if (obj == nil) {
        return FALSE;
    }
    
    Config * con = (Config *)obj;
    NSString *sql = [NSString stringWithFormat: @"UPDATE CONFIG SET VALUE = '%@' WHERE ID = %d", [self convertNilString:con.value], con.dbId];
    return [self executeSQL:sql];
}

- (NSObject *) readObject:(sqlite3_stmt *) statement
{
    if (nil == statement) {
        return nil;
    }
    Config *con = [[Config alloc] init];
    con.dbId = sqlite3_column_int(statement, 0);
    con.keyword = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
    con.value = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
    
    return con;
}

- (NSString *) getTableName
{
    return @" CONFIG ";
}

- (NSString *) getSelectSql
{
    return @"SELECT ID, KEYWORD, VALUE FROM CONFIG ";
}

-(Config *)getObjectOfKeyword:(NSString *) key
{
    NSMutableArray * res = [self selectWhere:[NSString stringWithFormat:@"keyword='%@'", key] OrderBy:nil];
    if (res != nil && [res count] > 0) {
        return [res objectAtIndex:0];
    }
    
    return nil;
}

-(NSString *)getValueOfKeyword:(NSString *) key
{
    Config * con = [self getObjectOfKeyword:key];
    
    if (con) {
        return con.value;
    }
    
    return nil;
}

@end
