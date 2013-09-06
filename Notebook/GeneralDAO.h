//
//  BaseDAO.h
//  h4h
//
//  Created by Hui Chen on 1/31/12.
//  Copyright (c) 2012 Wayne State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralEntity.h"
#import "DatabaseManager.h"
#import "BaseDAO.h"

@interface GeneralDAO : NSObject <BaseDAO>
{
    DatabaseManager * databaseManager;
}

@property (nonatomic, strong)  DatabaseManager *databaseManager;

//these methods MUST be overrided in the subclasses
- (NSObject *) readObject:(sqlite3_stmt *) statement;
- (NSString *) getTableName;
- (NSString *) getSelectSql;

//these methods can be overrided
- (NSObject *) findById:(NSInteger) objid;
- (BOOL) executeSQL:(NSString *)sql;
- (NSMutableArray *) executeSearchSQL:(NSString *)sql;
- (BOOL) startTransaction;
- (BOOL) commitTransation;
- (BOOL) rollback;
- (NSInteger) getLastInsertRowID;
- (BOOL) emptyString:(NSString *)str;
- (NSString *) convertNilString:(NSString *)str;
-(BOOL)removeByCondition:(NSString *) conds;
@end
