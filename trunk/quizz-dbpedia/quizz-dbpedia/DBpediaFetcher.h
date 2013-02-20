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

// Initialize the static var themes with the file match
+ (void) getAllThemes;

// Initialize the static var actors with the file match
+ (void) getAllActors;

// Initialize the static var movies with the file match
+ (void) getAllMovies;

@end
