//
//  DBpediaFetcher.m
//  quizz-dbpedia
//
//  Created by Lion User on 16/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "DBpediaFetcher.h"
#import <stdlib.h>

@implementation DBpediaFetcher

static NSMutableArray* actors;
static NSMutableArray* movies;

#define kAPIAddress         @"http://dbpedia.org/sparql?query="
#define kDefaultFormat      @"&format=application%2Fsparql-results%2Bjson&timeout=0"
#define kKeywordActor       @"?randomActorApp"
#define kKeywordMovie       @"?randomMovieApp"

+ (void) initialize
{
    if (actors == nil) {
        actors = [[NSMutableArray alloc] init];
        [self getAllActors];
    }
    if (movies == nil) {
        movies = [[NSMutableArray alloc] init];
        [self getAllMovies];
    }
}

+ (NSDictionary *) DBpediaQuery:(NSString *)query
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", kAPIAddress, query, kDefaultFormat];
    
    if(kDBpediaFetcherLogEnabled)
        NSLog(@"%@", urlString);
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:NSJSONReadingAllowFragments error:nil];
}

+ (void) getAllActors
{
    NSString * absolutePathFile = [[NSBundle mainBundle] pathForResource:@"allActors" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:absolutePathFile];
    NSDictionary * dicActors = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray * listActor = [[[dicActors objectForKey:@"results"] objectForKey:@"bindings"] allObjects];
    actors = [[NSMutableArray alloc]init];
    for (NSDictionary * actorDetails in listActor)
    {
        [actors addObject:[[actorDetails objectForKey:@"actor"] objectForKey:@"value"]];
    }
}

+ (void) getAllMovies
{
    NSString * absolutePathFile = [[NSBundle mainBundle] pathForResource:@"allMovies" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:absolutePathFile];
    NSDictionary * dicMovies = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray * listMovie = [[[dicMovies objectForKey:@"results"] objectForKey:@"bindings"] allObjects];
    movies = [[NSMutableArray alloc]init];
    for (NSDictionary * movieDetails in listMovie)
    {
        [movies addObject:[[movieDetails objectForKey:@"movie"] objectForKey:@"value"]];
    }
}

+ (NSDictionary *) executeQuery:(NSString *)query
{
    NSString * actor = [NSString stringWithFormat:@"<%@>", [actors objectAtIndex:(arc4random() % [actors count])]];
    NSString * movie = [NSString stringWithFormat:@"<%@>", [movies objectAtIndex:(arc4random() % [movies count])]];
    
    query = [query stringByReplacingOccurrencesOfString:kKeywordActor withString:actor];
    query = [query stringByReplacingOccurrencesOfString:kKeywordMovie withString:movie];
    
    if(kDBpediaFetcherLogEnabled)
        NSLog(@"%@", query);
    
    query = [self urlEncode:query usingEncoding:NSASCIIStringEncoding];
    
    return [DBpediaFetcher DBpediaQuery:query];
}

+ (NSString *)urlEncode:(NSString *)stringUrl usingEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)stringUrl, NULL, CFSTR("!*'\"();:@&=+$,/?%#[]% "), CFStringConvertNSStringEncodingToEncoding(encoding)));
}


@end
