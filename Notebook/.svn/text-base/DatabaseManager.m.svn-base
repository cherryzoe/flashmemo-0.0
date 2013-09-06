//
//  DatabaseManager.m
//  h4h
//
//  Created by Hui Chen on 2/1/12.
//  Copyright (c) 2012 Wayne State University. All rights reserved.
//

#import "DatabaseManager.h"
//define two private methods

@interface DatabaseManager()
+ (BOOL) initTables:(sqlite3 *) db;
+ (BOOL) initData:(sqlite3 *) db;
@end

@implementation DatabaseManager
//the singleton instance of DatabaseManager object
static DatabaseManager *instance = nil;
NSString * const DATABASENAME = @"db.sqlite";
NSString * const DEFAULTPASSWORD = @"P@ssw0rd$_CodeBag";
/**
 * Create the instance of DatabaseManagement object. All the objects
 * that use DatabaseManagement class must get the singleton instance
 * from this method.
 */
+ (DatabaseManager *)newInstance{
    @synchronized(self) {
        if (nil == instance){
            instance = [[DatabaseManager alloc]init];
        }
    }

    return instance;

}

/**
 * Create the database and initialize the tables with default data.
 */
+ (BOOL)createDatabase;
{
    return [self createDatabase:FALSE withName:DATABASENAME];
}

+(NSString *)databasePath:(NSString *)dbname
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbname];
    
    return dbPath;
}

/**
 * Create the database and initialize the tables with default data.
 * Used for Test.
 * @forceCreate : if TRUE force recreate the database
 * @databaseName : database name
 */
+ (BOOL)createDatabase:(BOOL) forceCreate withName:(NSString *) databaseName;
{
    if (databaseName == nil) {
        databaseName = DATABASENAME;
    }

    NSString *databasePath = [DatabaseManager databasePath:databaseName];
    NSFileManager * fileManager = [NSFileManager defaultManager];

    sqlite3 * db;
    BOOL result = TRUE;
    BOOL exists = [fileManager fileExistsAtPath:databasePath];
    //check whether the database exists
    if (!exists || forceCreate)
    {
        //delete the old database is force create
        if (exists && forceCreate) {
            [fileManager removeItemAtPath:databasePath error:NULL];
        }

        NSString * sql = [NSString stringWithFormat:@"PRAGMA key = '%@'", DEFAULTPASSWORD];
        NSString * sqltab = @"SELECT count(*) FROM sqlite_master";
        NSInteger code;
        if ((code = sqlite3_open([databasePath UTF8String], &db)) == SQLITE_OK)
        {
            sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL);
            if (sqlite3_exec(db, [sqltab UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
                // password is correct, or, database has been initialized
                result = [self initTables:db];
                if(result) result &= [self initData:db];
            } else {
                result = FALSE;
            }
            sqlite3_close(db);
        }
        else
        {
            result = FALSE;
        }
    }

    if (!result) {
        //delete the file if failed to create the database
        [fileManager removeItemAtPath:databasePath error:NULL];
    }
    return result;
}

/**
 * deprecated - This method is never required as h4h-ghunit should use the default h4h.db, instead of creating a new one.
 * Create the tables of the database.
 *
 */
+ (BOOL) initTables:(sqlite3 *) db
{
    if (nil == db) {
        return FALSE;
    }

    const char *configSql = "CREATE TABLE CONFIG ( ID INTEGER PRIMARY KEY AUTOINCREMENT, KEYWORD TEXT, VALUE TEXT)";    
    const char *usageSql = "CREATE TABLE BARCODE (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, TYPE INTEGER, CATEGORY INTEGER, DESC TEXT, CODE TEXT, EXPIRETIME REAL)";
    const char *catSql = "CREATE TABLE CATEGORY (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ORDERNUM INTEGER, USERDEFINED INTEGER)";
    
    if(sqlite3_exec(db, configSql, NULL, NULL, NULL) > 0) {
        return FALSE;
    }
    if(sqlite3_exec(db, usageSql, NULL, NULL, NULL) > 0) {
        return FALSE;
    }
    if(sqlite3_exec(db, catSql, NULL, NULL, NULL) > 0) {
        return FALSE;
    }
    
    return TRUE;
}

/**
 * Insert the default data of the database.
 */
+ (BOOL) initData:(sqlite3 *) db
{
    const char * sql = "INSERT INTO CATEGORY (NAME, ORDERNUM, USERDEFINED)VALUES('Member Card', 1, 0)";
    if(sqlite3_exec(db, sql, NULL, NULL, NULL) > 0) {
        return FALSE;
    }
    const char * sql2 = "INSERT INTO CATEGORY (NAME, ORDERNUM, USERDEFINED)VALUES('Coupon Code', 2, 0)";
    if(sqlite3_exec(db, sql2, NULL, NULL, NULL) > 0) {
        return FALSE;
    }
    const char * sql3 = "INSERT INTO CATEGORY (NAME, ORDERNUM, USERDEFINED)VALUES('Others', 10000, 0)";
    if(sqlite3_exec(db, sql3, NULL, NULL, NULL) > 0) {
        return FALSE;
    }
    const char * sql4 = "INSERT INTO CATEGORY (NAME, ORDERNUM, USERDEFINED)VALUES('Business Card', 3, 0)";
    if(sqlite3_exec(db, sql4, NULL, NULL, NULL) > 0) {
        return FALSE;
    }
    return TRUE;
}

/**
 * Open the database connection. All the data access objects must use this method
 * to create the database connection.
 */
- (void)openDatabase:(NSString *) dbName{
    
   
    if ( database == NULL)
    {
        if (dbName == nil) {
            dbName = DATABASENAME;
        }
        
        NSString *databasePath = [DatabaseManager databasePath:dbName];
        NSFileManager * fileManager = [NSFileManager defaultManager];
               
        if ([fileManager fileExistsAtPath:databasePath] == FALSE) {
            return;
        }

        int result = sqlite3_open([databasePath UTF8String], &database);
        if (result != SQLITE_OK){
            NSLog(@"Failed to open database");
            [self closeDatabase];
        }
        else //security check
        {
            NSString * sql = [NSString stringWithFormat:@"PRAGMA key = '%@'", DEFAULTPASSWORD];
            sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL);
            NSString * sqltab = @"SELECT count(*) FROM sqlite_master";
            if (sqlite3_exec(database, [sqltab UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
                // password is correct, or, database has been initialized
            } else {
                [self closeDatabase];
            }
        }
    }
}


/**
 * Close the database connection. All the data access objects must use this method
 * to close the database connection.
 */
//TODO If database is closed, how could we automatically reopen it.
- (void)closeDatabase{
    if(database){
        sqlite3_close(database);
        database = NULL;
    }
}

- (sqlite3 *) getDatabase;
{
    return database;
}

- (BOOL)resetOldPassword:(NSString *) oldPwd withNewPassword:(NSString *) newPwd
{
    if([oldPwd isEqualToString:newPwd])
        return TRUE;

    if (database) {
        NSString * sql = [NSString stringWithFormat:@"PRAGMA rekey = '%@'", newPwd];
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
            NSLog(@"Changed to another password  successfully"); // Login successfully
            return TRUE;
        } else {
            NSLog(@"Failed to change password!");
            return FALSE;
        }
    }

    return FALSE;
}

+ (BOOL)databaseExists:(NSString *) dbName
{
    if(dbName == nil){
        dbName = DATABASENAME;
    }

    NSString *databasePath = [DatabaseManager databasePath:dbName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
//    NSLog(@"%@", databasePath);
    return [fileManager fileExistsAtPath:databasePath];
}

@end
