//
//  DatabaseManager.h
//  h4h
//


#import <Foundation/Foundation.h>
#import "sqlite3.h"
@interface DatabaseManager : NSObject
{
    sqlite3 * database;
}

+ (DatabaseManager *)newInstance;
- (void)openDatabase:(NSString *) dbName;
- (void)closeDatabase;
+ (BOOL)createDatabase;
+ (BOOL)createDatabase:(BOOL) forceCreate withName:(NSString *) databaseName;
- (sqlite3 *) getDatabase; 
- (BOOL)resetOldPassword:(NSString *) oldPwd withNewPassword:(NSString *) newPwd;
+ (BOOL)databaseExists:(NSString *) dbName;
@end
