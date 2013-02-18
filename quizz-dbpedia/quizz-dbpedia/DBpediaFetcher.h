//
//  DBpediaFetcher.h
//  quizz-dbpedia
//
//  Created by Lion User on 16/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// Turn this value to YES to enable the log messages
#define kDBpediaFetcherLogEnabled              YES

@interface DBpediaFetcher : NSObject

// Return a plist what contains all results of the query
+ (NSDictionary *) executeQuery:(NSString *)query;

// Return an array what contains all actors
+ (void) getAllActors;

// Return an array what contains all movies
+ (void) getAllMovies;

@end
