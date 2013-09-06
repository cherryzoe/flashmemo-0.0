//
//  BaseDAO.h
//  h4h
//

#import "GeneralEntity.h"

@protocol BaseDAO

@required
- (BOOL) insert:(NSObject *)obj;
- (BOOL) update:(NSObject *)obj;
- (BOOL) remove:(NSObject *) obj;

@optional
- (NSMutableArray *) selectWhere:(NSString *) clause OrderBy:(NSString *) order;
- (BOOL) removeAllObject;
- (NSInteger) totalCount;
- (NSMutableArray *) getAllObject;
@end
