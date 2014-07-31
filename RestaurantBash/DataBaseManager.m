//
//  PropertiesDataBaseManager.m
//  Properties
//
//  Created by Srinivas Vasadi on 26/08/11.
//  Copyright 2011 Sameva Inc. All rights reserved.
//

#import "DataBaseManager.h"

static DataBaseManager *dataBaseManager = nil;
@implementation DataBaseManager

#pragma mark -
#pragma mark - DataBaseManager initialization

/* initialize the database */
-(id) init{
	self = [super init];
	if (self){
		// get full path of database in documents directory
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *path = [paths objectAtIndex:0];
		_dataBasePath = [path stringByAppendingPathComponent:@"Manu-DB-VAS.sqlite"];
		_database = nil;
		[self openDatabase];
    }
	return self;
}

#pragma mark -
#pragma mark - Open,Create DataBase

/* open database if database doesn't exist, create it */
-(void)openDatabase{
	BOOL ok;
	NSError *error;
	/* determine if database exists.
	 * create a file manager object to test existence
	 */
	NSFileManager *fm = [NSFileManager defaultManager]; 
	ok = [fm fileExistsAtPath:_dataBasePath];
	
	// if database not there, copy from resource to path
	if (!ok){
		if (copyDb){ 
			// location in resource bundle
			NSString *appPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Manu-Properties.sqlite"];
			// copy from resource to where it should be
			ok = [fm copyItemAtPath:appPath toPath:_dataBasePath error:&error];
		}
	}
    // open database
	if (sqlite3_open([_dataBasePath UTF8String], &_database) != SQLITE_OK){
		sqlite3_close(_database); 
		_database = nil;
	}
}

/* Method to Create DataBase */
//-(BOOL)createDatabase{
//    BOOL ret = NO;
//    int rc;
//    
//    NSArray* queries = [NSArray arrayWithObjects:@"CREATE TABLE 'LoginDetails'(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'Username' TEXT NOT NULL , 'Password' TEXT,'Pin' INTEGER, 'DeviceID' TEXT)", nil]; //Query to create table
//       // if(queries != NULL)
//    {
//        for (NSString* sql in queries){
//            sqlite3_stmt *stmt;
//            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
//            ret = (rc == SQLITE_OK);
//            if (ret){
//                rc = sqlite3_step(stmt);
//                ret = (rc == SQLITE_DONE);
//                sqlite3_finalize(stmt);
//                //sqlite3_reset(stmt);
//            }
//        }
//    }
//    return ret;
//}

/* Method to launch database */
+(DataBaseManager*)dataBaseManager{
	if(dataBaseManager==nil){
		dataBaseManager = [[DataBaseManager alloc]init];
	}
	return dataBaseManager;
}

/* Method to get database path */
- (NSString *) getDBPath{
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"ManuLogix-Properties.sqlite"];
}

#pragma mark -
#pragma mark - SQL query methods

/* Method to execute the simple queries directly */
-(BOOL)execute:(NSString*)sqlStatement {
	sqlite3_stmt *statement = nil;
    BOOL status = FALSE;
	NSLog(@"%@",sqlStatement);
	const char *sql = (const char*)[sqlStatement UTF8String];
	
	if(sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
        //   NSAssert1(0, @"Error while preparing  statement. '%s'", sqlite3_errmsg(_database));
        status = FALSE;
    } else {
        status = TRUE;
    }
    
	if (sqlite3_step(statement)!=SQLITE_DONE) {//checking database elements with server response elements for form name,form version and user existence
        NSLog(@"Error %s",sqlite3_errmsg(_database) );
        
        NSString *errorMsg = [NSString stringWithFormat:@"%s",sqlite3_errmsg(_database)];
        
        NSLog(@"error msg %@", errorMsg);
        NSString *compareString = @"are not unique";
        
        if ([errorMsg isEqualToString:@"columns FormName, FormVersion are not unique"]) {
            
        }else if ([errorMsg rangeOfString:compareString].location==NSNotFound){
            NSLog(@"Substring Not Found");
            NSString *compareString1 = @"is not unique";
            if ([errorMsg rangeOfString:compareString1].location==NSNotFound){
                NSLog(@"Substring1 Not Found");
            }
//            else{
//                [self showAlert:DUPLICATE_PRIMARY_RECORD_ENTRY];
//                [FAUtilities showToastMessageAlert:DUPLICATE_PRIMARY_RECORD_ENTRY];
//            }
        }
        else{
            NSLog(@"Substring Found Successfully");
//            [self showAlert:DUPLICATE_PRIMARY_RECORD_ENTRY];
//         [FAUtilities showToastMessageAlert:DUPLICATE_PRIMARY_RECORD_ENTRY];
        }
        
        
        
        //		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(_database));
        status = FALSE;
	} else {
        NSLog(@"Error %s",sqlite3_errmsg(_database) );
	}
	sqlite3_finalize(statement);
    NSLog(@"status %c", status);
    return status;
}

/* Method to get the data table from the database */
-(BOOL) execute:(NSString*)sqlQuery resultsArray:(NSMutableArray*)dataTable{
    
    NSLog(@"%@",sqlQuery);

    char** azResult = NULL;
    int nRows = 0;
    int nColumns = 0;
    BOOL status = FALSE;
    char* errorMsg;
    const char* sql = [sqlQuery UTF8String];
    sqlite3_get_table(
                      _database,  /* An open database */
                      sql,     /* SQL to be evaluated */
                      &azResult,          /* Results of the query */
                      &nRows,                 /* Number of result rows written here */
                      &nColumns,              /* Number of result columns written here */
                      &errorMsg      /* Error msg written here */
                      );
	
    if(azResult != NULL){
        nRows++; 		
        for (int i = 1; i < nRows; i++){
            NSMutableDictionary* row = [[NSMutableDictionary alloc]initWithCapacity:nColumns];
            for(int j = 0; j < nColumns; j++){
                NSString*  value = nil;
                NSString* key = [NSString stringWithUTF8String:azResult[j]];
                if (azResult[(i*nColumns)+j]==NULL){
                    value = [NSString stringWithUTF8String:[[NSString string] UTF8String]];
                }else{
                    value = [NSString stringWithUTF8String:azResult[(i*nColumns)+j]];
                    if ([value isEqual:@"(null)"]) {
                        value = @"";
                    }
                }
                [row setValue:value forKey:key];
            }
            [dataTable addObject:row];
        }
        status = TRUE;
        sqlite3_free_table(azResult);
    }else{
        NSAssert1(0,@"Failed to execute query with message '%s'.",errorMsg);
        status = FALSE;
    }
    return 0;
}

/* Method to get the integer value from the database */
-(NSInteger)getScalar:(NSString*)sqlStatement{
	NSInteger count = -1;
	
	const char* sql= (const char *)[sqlStatement UTF8String];
	sqlite3_stmt *selectstmt;
	if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK){
		while(sqlite3_step(selectstmt) == SQLITE_ROW){
			count = sqlite3_column_int(selectstmt, 0);
		}
	}
	sqlite3_finalize(selectstmt);
	return count;
}

/* Method to get the string from the database */
-(NSString*)getValue:(NSString*)sqlStatement{
	NSString* value = nil;
	const char* sql= (const char *)[sqlStatement UTF8String];
	sqlite3_stmt *selectstmt;
	if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK){
		while(sqlite3_step(selectstmt) == SQLITE_ROW){
			if ((char *)sqlite3_column_text(selectstmt, 0)!=nil){
				value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
			}
		}
	}
	return value;
}

//#pragma mark -
//#pragma mark - Alert
///* Method to show alert for user existence */ 
//-(void)showAlert:(NSString*)message{
//	UIAlertView *alert = [[UIAlertView alloc] init];
//	[alert setTitle:FORMS_PAGE_TITLE];
//	[alert setMessage:message];
//	[alert setDelegate:nil];
//	[alert addButtonWithTitle:@"OK"];
//	[alert show];
//}

#pragma mark -
#pragma mark - Dealloc
-(void)dealloc{
	sqlite3_close(_database);
    dataBaseManager = nil;
}
@end
