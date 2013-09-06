//
//  BaseDAO.m
//  h4h
//
//  Created by Hui Chen on 1/31/12.
//  Copyright (c) 2012 Wayne State University. All rights reserved.
//

#import "GeneralDAO.h"
#import "GeneralEntity.h"

@implementation GeneralDAO
@synthesize databaseManager;

- (id) init
{
    self = [super init];
    if (self) {
        databaseManager = [DatabaseManager newInstance];
    }
    
    return self;
}

- (BOOL) insert:(NSObject *)obj
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"insert method is not overrided %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil]; 
}

- (BOOL) update:(NSObject *)obj
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"update method is not overrided %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL) remove:(NSObject *) obj
{
    if ([obj respondsToSelector:@selector(getDbId:)]) {
        return FALSE;
    }
    
    id<GeneralEntity> ge = (id<GeneralEntity>)obj;
    NSString *sql = [NSString stringWithFormat: @"DELETE FROM %@ WHERE ID = %d", [self getTableName], [ge getDbId]];
    return [self executeSQL:sql];        
}

- (BOOL) removeAllObject
{
    NSString *sql = [NSString stringWithFormat: @"DELETE FROM %@", [self getTableName]];
    return [self executeSQL:sql];        
}

-(BOOL)removeByCondition:(NSString *) conds
{
    if (conds) {
        NSString *sql = [NSString stringWithFormat: @"DELETE FROM %@ WHERE %@", [self getTableName], conds];
        return [self executeSQL:sql];
    }
    
    return FALSE;
}

- (NSObject *) findById:(NSInteger) objid
{
    NSString *sql = [NSString stringWithFormat: @"%@ WHERE ID = %d", [self getSelectSql],objid];
    NSMutableArray * objArray = [self executeSearchSQL:sql];
    if(objArray.count > 0)
        return [objArray objectAtIndex:0];
    else
        return nil;
}

- (NSMutableArray *) getAllObject
{
    NSString *sql = [NSString stringWithFormat: @"%@ ", [self getSelectSql]];    
    return [self executeSearchSQL: sql];
}

- (NSMutableArray *) search:(NSMutableDictionary *) conditions byOrder:(NSString *)order
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"search method is not overrided %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];    
}

/**
 * Execute a sql command. 
 * @sql : the sql command.
 * @return TRUE if success, FALSE if failed to execute.
 */
- (BOOL) executeSQL:(NSString *)sql
{
    if (sql == nil) {
        return FALSE;
    }
    
    sqlite3_stmt *statement;
//    NSLog(sql,NULL);
    int result = sqlite3_prepare_v2([databaseManager getDatabase], [sql UTF8String], -1, &statement, NULL);    
    if(SQLITE_OK == result)
    {
      result = sqlite3_step(statement);
      sqlite3_finalize(statement);    
      return (result == SQLITE_DONE);    
    }
    else
    {
        NSLog(@"Database error code : %d \n", result);  
        return  FALSE;
    }
}

- (NSMutableArray *) executeSearchSQL:(NSString *)sql
{
    if (sql == nil) {
        return FALSE;
    }
    
    sqlite3_stmt *statement;
    NSObject *obj;
    NSMutableArray *objArray = [[NSMutableArray alloc] init];
    int result = sqlite3_prepare_v2([databaseManager getDatabase], [sql UTF8String], -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
         while (sqlite3_step(statement) == SQLITE_ROW)
         {
             obj = [self readObject:statement];
             if (obj != nil) 
             {
                 [objArray addObject:obj];
             }
         }
         sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"Database error code : %d \n", result);  
    }
    
    return objArray;
}

- (NSObject *) readObject:(sqlite3_stmt *) statement
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"readObject method is not overrided %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];        
}

- (NSString *) getTableName;
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"getTableName method is not overrided %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];            
}

- (NSString *) getSelectSql
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"getSelectSql method is not overrided %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];                
}

- (NSString *) getOrderSql
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"getOrderSql method is not overrided %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];                    
}

- (NSInteger) totalCount
{
    NSString * sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", [self getTableName]];
    sqlite3_stmt *statement;
    NSInteger count = -1;
    
    if (sqlite3_prepare_v2([databaseManager getDatabase], [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            count = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    
    return count;
}

- (BOOL) startTransaction
{
    return sqlite3_exec([databaseManager getDatabase], "BEGIN EXCLUSIVE TRANSACTION", 0, 0, 0) == SQLITE_OK;
}

- (BOOL) commitTransation
{
    return sqlite3_exec([databaseManager getDatabase], "COMMIT", 0, 0, 0) == SQLITE_OK;    
}

- (BOOL) rollback
{
    return sqlite3_exec([databaseManager getDatabase], "ROLLBACK", 0, 0, 0) == SQLITE_OK;    
}

/*
 * Get the ID of the last inserted object.
 * This method should be invoked after an insert sql.
 */
- (NSInteger) getLastInsertRowID
{
    if ([databaseManager getDatabase] == NULL) {
        return -1;
    }
    
    NSString * sql = @"select last_insert_rowid()";
    sqlite3_stmt *statement;
    NSInteger lastid = -1;
    
    if (sqlite3_prepare_v2([databaseManager getDatabase], [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            lastid = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    
    return lastid;    
}

- (NSMutableArray *) selectWhere:(NSString *) clause OrderBy:(NSString *) order;
{
   NSMutableString * sql = [NSMutableString stringWithString: [self getSelectSql]];    
    if (clause != nil) {
        [sql appendFormat:@" WHERE %@ ", clause];
    }
    
    if (order != nil) {
        [sql appendFormat:@" ORDER BY %@ ",order];
    }
    
    return [self executeSearchSQL:[NSString stringWithString:sql]];
}

- (BOOL) emptyString:(NSString *)str
{
    if (str == nil || [str isEqualToString:@""]) {
        return TRUE;
    }
    
    return FALSE;
}

- (NSString *) convertNilString:(NSString *)str
{
    if (str == nil)
        return @"";
    else
        return str;
}
@end
