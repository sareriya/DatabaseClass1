
/********************************************************************************\
 *
 * File Name       Database.m
 * Author          $Author:: gaurav.thummar  $: Author of last commit
 * Version         $Revision:: 01             $: Revision of last commit
 * Modified        $Date:: 2011-12-15 16:24:59#$: Date of last commit
 * 
 * Copyright(c) 2011 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/

#import "Database.h"
#import "KalDate.h"
static Database *shareDatabase =nil;

@implementation Database
@synthesize m_MutArrFavortiesData;
#pragma mark -
#pragma mark Database


+(Database*) shareDatabase
{
	
	if(!shareDatabase)
    {
		shareDatabase = [[Database alloc] init];
	}
	
	return shareDatabase;
	
}

#pragma mark -
#pragma mark Get DataBase Pathd
NSString * const DataBaseName  = @"Trialtoolkit.db"; // Pass Your DataBase Name Over here

- (NSString *) GetDatabasePathDocumentDirectory:(NSString *)dbName
{
	NSArray  *paths        = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:dbName];
}
 

- (NSString *) GetDatabasePath:(NSString *)dbName
{
	NSArray  *paths        = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
    NSString *privatePath = [documentsDir stringByAppendingPathComponent:@"/Private"];
    
	return [privatePath stringByAppendingPathComponent:dbName];
}



-(NSString *)GetFilePathDocumentDirectory:(NSString *)fileName
{
	NSArray  *paths        = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:fileName];
}
 
-(NSString *)GetFilePath:(NSString *)fileName
{
	NSArray  *paths        = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
    NSString *privatePath = [documentsDir stringByAppendingPathComponent:@"/Private"];
	return [privatePath stringByAppendingPathComponent:fileName];
}

-(BOOL) createEditableCopyOfDatabaseIfNeededForDocumentDirectory
{
    BOOL success; 
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DataBaseName];
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return success;
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DataBaseName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    if (!success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!!!" message:@"Failed to create writable database" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        [alert release];
        }
    return success;
}
-(void)AlterTable:(NSString *)tableQuery
{
    
    NSString *path = [self GetDatabasePathDocumentDirectory:DataBaseName];
    if (sqlite3_open([path UTF8String], &databaseObj) == SQLITE_OK) {
        
        NSString *charsTableNameQuery = tableQuery;
        
        int results = 0;
        
        //create all chars tables
        const char *charsTableNameQuerySQL = [charsTableNameQuery UTF8String];
        sqlite3_stmt * charsTableNameStatment = nil;
        results = sqlite3_exec(databaseObj, charsTableNameQuerySQL, NULL, NULL, NULL);
        if (results != SQLITE_DONE) {
            const char *err = sqlite3_errmsg(databaseObj);
            NSString *errMsg = [NSString stringWithFormat:@"%s",err];
            if (![errMsg isEqualToString:@"not an error"]) {
                NSLog(@"createTables-chartables error: %@",errMsg);
             //   return FALSE;
            }
        }
        
        sqlite3_finalize(charsTableNameStatment);
        sqlite3_close(databaseObj);
        
       // return TRUE;
    }else{
        NSLog(@"database not opened");
    }
    
  //  return FALSE;
}

-(BOOL)moveDatabaseToprivateIfNeeded
{
      NSArray *documentdirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *tempPath = [documentdirectory objectAtIndex:0] ;
        NSString *toPath = [tempPath stringByAppendingPathComponent:DataBaseName];
        
        NSArray *librarydirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *fromPath = [[librarydirectory objectAtIndex:0] stringByAppendingPathComponent:@"Private"];
        NSString *strdestination = [fromPath stringByAppendingPathComponent:DataBaseName];
        NSError *Error = nil;
        
        if([[NSFileManager defaultManager]fileExistsAtPath:toPath])
        {
            
            if([[NSFileManager defaultManager]copyItemAtPath:toPath toPath:strdestination error:&Error]==NO)
            {
                // UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"copy" message:[NSString stringWithFormat:@"%@",Error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                //[Alert show];
            }
            else
            {
                [[NSFileManager defaultManager] removeItemAtPath:toPath error:NULL];
                //UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Not copy" message:[NSString stringWithFormat:@"%@",Error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                //[Alert show];
            }
        }
        
    }
-(BOOL) createEditableCopyOfDatabaseIfNeeded
{
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *privatePath = [documentsDirectory stringByAppendingPathComponent:@"/Private"];
    NSString *writableDBPath = [privatePath stringByAppendingPathComponent:DataBaseName];
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return success;
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DataBaseName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    if (!success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!!!" message:@"Failed to create writable database" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    return success;
}


-(BOOL)createTable:(NSString *)tableQuery
{
   
    NSString *path = [self GetDatabasePath:DataBaseName];
    if (sqlite3_open([path UTF8String], &databaseObj) == SQLITE_OK) {
        
        NSString *charsTableNameQuery = tableQuery;
        
        int results = 0;
        
        //create all chars tables
        const char *charsTableNameQuerySQL = [charsTableNameQuery UTF8String];
        sqlite3_stmt * charsTableNameStatment = nil;
        results = sqlite3_exec(databaseObj, charsTableNameQuerySQL, NULL, NULL, NULL);
        if (results != SQLITE_DONE) {
            const char *err = sqlite3_errmsg(databaseObj);
            NSString *errMsg = [NSString stringWithFormat:@"%s",err];
            if (![errMsg isEqualToString:@"not an error"]) {
                NSLog(@"createTables-chartables error: %@",errMsg);
                return FALSE;
            }
        }
        
        sqlite3_finalize(charsTableNameStatment);
        sqlite3_close(databaseObj);
        
        return TRUE;
    }else{
        NSLog(@"database not opened");
    }
    
    return FALSE;
    
}
-(BOOL)isTableExists:(NSString *)tableName
{
	sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
	 bool sucess = FALSE;
    	int temp = 0;
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
        
    NSString *tableExistsQuery=[NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'",tableName];
    sqlite3_prepare_v2(databaseObj,[tableExistsQuery UTF8String], -1, &statement, nil);
    
        if (sqlite3_prepare_v2(databaseObj,[tableExistsQuery UTF8String], -1, &statement, nil)==temp) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                sucess = TRUE;
            }
        }
 
    sqlite3_finalize(statement);
    
    }
    return sucess;
}
#pragma mark -
#pragma mark Get All Record

-(NSMutableArray *)SelectAllFromTable:(NSString *)query
{
	sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	NSMutableArray *alldata;
	alldata = [[NSMutableArray alloc] init];
	int temp = 0;
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
    
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == temp)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{	
				NSMutableDictionary *currentRow = [[NSMutableDictionary alloc] init];
                
				int count = sqlite3_column_count(statement);
				
				for (int i=0; i < count; i++) {
                    
					char *name = (char*) sqlite3_column_name(statement, i);
					char *data = (char*) sqlite3_column_text(statement, i);
					
					NSString *columnData;   
					NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                    
					if(data != nil){
						columnData = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
					}else {
						columnData = @"";
					}
                    columnData = [columnData stringByReplacingOccurrencesOfString:@"$" withString:@"'"];
					[currentRow setObject:columnData forKey:columnName];
				}
                
				[alldata addObject:currentRow];
                [currentRow release];
			}
		}
		sqlite3_finalize(statement); 
	}
	sqlite3_close(databaseObj) ;
//       == SQLITE_OK){
//    
//    }
//    else
//    {
//          //  NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
//    }
    //NSMutableArray *ary = [NSMutableArray arrayWithArray:alldata];
    //[alldata release];
	return alldata;

}
-(NSMutableArray *)SelectAllFromTableDocuments:(NSString *)query
{
	sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePathDocumentDirectory:DataBaseName];
	
	NSMutableArray *alldata;
	alldata = [[NSMutableArray alloc] init];
	int temp = 0;
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
        
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == temp)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{
				NSMutableDictionary *currentRow = [[NSMutableDictionary alloc] init];
                
				int count = sqlite3_column_count(statement);
				
				for (int i=0; i < count; i++) {
                    
					char *name = (char*) sqlite3_column_name(statement, i);
					char *data = (char*) sqlite3_column_text(statement, i);
					
					NSString *columnData;
					NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                    
					if(data != nil){
						columnData = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
					}else {
						columnData = @"";
					}
                    columnData = [columnData stringByReplacingOccurrencesOfString:@"$" withString:@"'"];
					[currentRow setObject:columnData forKey:columnName];
				}
                
				[alldata addObject:currentRow];
                [currentRow release];
			}
		}
		sqlite3_finalize(statement);
	}
	sqlite3_close(databaseObj) ;
    //       == SQLITE_OK){
    //
    //    }
    //    else
    //    {
    //          //  NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    //    }
    //NSMutableArray *ary = [NSMutableArray arrayWithArray:alldata];
    //[alldata release];
	return alldata;
    
}

#pragma mark -
#pragma mark Get Record Count

-(int)getCount:(NSString *)query
{
	int m_count=0;
	sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName] ;
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
		{
			if(sqlite3_step(statement) == SQLITE_ROW)
			{	
				m_count= sqlite3_column_int(statement,0);
			}
		}
		sqlite3_finalize(statement); 
	}
    sqlite3_close(databaseObj);
	return m_count;
}

#pragma mark -
#pragma mark Check For Record Present

-(BOOL)CheckForRecord:(NSString *)query
{	
	sqlite3_stmt *statement = nil;
	NSString *path = [self GetDatabasePath:DataBaseName];
	int isRecordPresent = 0;
		
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement, NULL)) == SQLITE_OK)
		{
			if(sqlite3_step(statement) == SQLITE_ROW)
			{
				isRecordPresent = 1;
			}
			else {
				isRecordPresent = 0;
			}
		}
	}
	sqlite3_finalize(statement);	
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }	
	return isRecordPresent;
}

#pragma mark -
#pragma mark Insert

- (void)Insert:(NSString *)query 
{	
	sqlite3_stmt *statement=nil;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
	{
		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement,NULL)) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
	}
	sqlite3_finalize(statement);
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
}

#pragma mark -
#pragma mark Rename

- (void)rename:(NSString *)query
{
	sqlite3_stmt *statement=nil;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
	{
		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement,NULL)) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
	}
	sqlite3_finalize(statement);
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
}

//SELECT * FROM dbname.sqlite_master WHERE type='table';
#pragma mark -
#pragma mark All Tables
-(NSMutableArray *)getAllTables
{
    
    NSString *query=@"SELECT tbl_name FROM sqlite_master WHERE type='table';";
	sqlite3_stmt *statement = nil ;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	NSMutableArray *alldata;
	alldata = [[NSMutableArray alloc] init];
	int temp = 0;
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
        
		if((sqlite3_prepare_v2(databaseObj,[query UTF8String],-1, &statement, NULL)) == temp)
		{
			while(sqlite3_step(statement) == SQLITE_ROW)
			{
				NSMutableDictionary *currentRow = [[NSMutableDictionary alloc] init];
                
				int count = sqlite3_column_count(statement);
				
				for (int i=0; i < count; i++) {
                    
					char *name = (char*) sqlite3_column_name(statement, i);
					char *data = (char*) sqlite3_column_text(statement, i);
					
					NSString *columnData;
					NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                    
					if(data != nil){
						columnData = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
					}else {
						columnData = @"";
					}
                    columnData = [columnData stringByReplacingOccurrencesOfString:@"$" withString:@"'"];
					[currentRow setObject:columnData forKey:columnName];
				}
                
				[alldata addObject:currentRow];
                [currentRow release];
			}
		}
		sqlite3_finalize(statement);
	}
	sqlite3_close(databaseObj) ;
    //       == SQLITE_OK){
    //
    //    }
    //    else
    //    {
    //          //  NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    //    }
    //NSMutableArray *ary = [NSMutableArray arrayWithArray:alldata];
    //[alldata release];
	return alldata;
    
}

#pragma mark -
#pragma mark Drop
- (void)Drop:(NSString *)query
{
	sqlite3_stmt *statement=nil;
	NSString *path = [self GetDatabasePath:DataBaseName];
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
	{
		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement,NULL)) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
	}
	sqlite3_finalize(statement);
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }else{
        NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
}
#pragma mark -
#pragma mark DeleteRecord

-(void)Delete:(NSString *)query
{
	sqlite3_stmt *statement = nil;
	NSString *path = [self GetDatabasePath:DataBaseName] ;
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK )
	{
		if((sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement, NULL)) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
	}
	sqlite3_finalize(statement);
	if(sqlite3_close(databaseObj) == SQLITE_OK){
        
    }
    else
    {
        NSAssert1(0, @"Error: failed to close database on memwarning with message '%s'.", sqlite3_errmsg(databaseObj));
    }
}

#pragma mark -
#pragma mark UpdateRecord

-(void)Update:(NSString *)query
{
	sqlite3_stmt *statement=nil;
	NSString *path = [self GetDatabasePath:DataBaseName] ;
	
	if(sqlite3_open([path UTF8String],&databaseObj) == SQLITE_OK)
	{
		if(sqlite3_prepare_v2(databaseObj, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			sqlite3_step(statement);
		}
		sqlite3_finalize(statement);
	}
	sqlite3_close(databaseObj);
}
-(void)selectAllDateForCalender:(NSString *)query
{
	sqlite3_stmt *stament=nil;
	NSString *path=[self GetDatabasePath:DataBaseName];
	
	NSString *q=[NSString stringWithFormat:@"%@",query];
	char charQuery[q.length];
	sprintf(charQuery,"%s",[q UTF8String]);
	
	m_MutArrFavortiesData=[[NSMutableArray alloc]init];
	
    NSString *ADate;
    // int week;
	if(sqlite3_open([path UTF8String],&databaseObj)==SQLITE_OK)
	{
		if(sqlite3_prepare_v2(databaseObj, charQuery, -1, &stament,NULL)==SQLITE_OK)
		{
			while(sqlite3_step(stament)==SQLITE_ROW)
			{
				
                ADate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stament, 0)];
                
                // Convert string to date object
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MM-dd-yyyy"];
                
                NSTimeZone *tz = [NSTimeZone timeZoneForSecondsFromGMT:(-8 * 3600)]; // for PST
                [dateFormat setTimeZone:tz];
                
                NSDate *date = [dateFormat dateFromString:ADate];
                KalDate *kaldate = [KalDate dateFromNSDate:date];
                
                [m_MutArrFavortiesData addObject:kaldate];
                [m_MutArrFavortiesData retain];
                
                [dateFormat release];
                
			}
		}
		else
		{
			
		}
		sqlite3_finalize(stament);
		
	}
	else
	{
    }
	
	sqlite3_close(databaseObj);
}
@end
