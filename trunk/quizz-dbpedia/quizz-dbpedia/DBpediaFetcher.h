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
#define kDBpediaFetcherLogEnabled   NO

@interface DBpediaFetcher : NSObject

// Return an array what contains all results of the query
+ (NSMutableArray *) executeQuery:(NSString *)query;

// Return an array what contains all themes
+ (NSMutableArray *) getAllThemes;

// Return an array what contains all actors
+ (NSMutableArray *) getAllActors;

// Return an array what contains all movies
+ (NSMutableArray *) getAllMovies;

@end
