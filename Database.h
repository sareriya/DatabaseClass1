/********************************************************************************\
 *
 * File Name       Database.h
 * Author          $Author:: gaurav.thummar  $: Author of last commit
 * Version         $Revision:: 01             $: Revision of last commit
 * Modified        $Date:: 2011-12-15 16:01:19#$: Date of last commit
 * 
 * Copyright(c) 2011 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Database : NSObject {

	sqlite3 *databaseObj;

    NSMutableArray *m_MutArrFavortiesData;
}
@property (nonatomic,retain)NSMutableArray *m_MutArrFavortiesData;

+(Database*) shareDatabase;
-(BOOL) createEditableCopyOfDatabaseIfNeededForDocumentDirectory;
-(NSString *)GetFilePath:(NSString *)fileName;
-(BOOL) createEditableCopyOfDatabaseIfNeeded;
-(NSString *) GetDatabasePath:(NSString *)dbName;
-(void)selectAllDateForCalender:(NSString *)query;
-(NSMutableArray *)SelectAllFromTable:(NSString *)query;
-(int)getCount:(NSString *)query;
-(BOOL)CheckForRecord:(NSString *)query;
- (void)Insert:(NSString *)query;
-(void)Delete:(NSString *)query;
-(void)Update:(NSString *)query;
-(void)AlterTable:(NSString *)tableQuery;
- (void)rename:(NSString *)query;
- (void)Drop:(NSString *)query;

// Added by Darshan 
-(BOOL)createTable:(NSString *)tableQuery;
-(BOOL)isTableExists:(NSString *)tableName;
-(NSMutableArray *)SelectAllFromTableDocuments:(NSString *)query;
-(BOOL)moveDatabaseToprivateIfNeeded;
-(NSMutableArray *)getAllTables;
-(NSString *)GetFilePathDocumentDirectory:(NSString *)fileName;
@end
