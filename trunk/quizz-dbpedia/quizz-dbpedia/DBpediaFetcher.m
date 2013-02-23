//
//  DBpediaFetcher.m
//  quizz-dbpedia
//
//  Created by Lion User on 16/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "DBpediaFetcher.h"
#import "Theme.h"
#import "Question.h"

@implementation DBpediaFetcher

static NSMutableArray* themes;
static NSMutableArray* actors;
static NSMutableArray* movies;

#define kAPIAddress         @"http://dbpedia.org/sparql?query="
#define kDefaultFormat      @"&format=application%2Fsparql-results%2Bjson&timeout=0"

+ (void) initialize
{
    if (themes == nil)
        [self getAllThemes];
    if (actors == nil)
        [self getAllActors];
    if (movies == nil)
        [self getAllMovies];
}

+ (NSDictionary *) DBpediaQuery:(NSString *)query
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", kAPIAddress, query, kDefaultFormat];
    
    if(kDBpediaFetcherLogEnabled)
        NSLog(@"%@", urlString);
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:NSJSONReadingAllowFragments error:nil];
}

+ (NSMutableArray *) getAllThemes
{
    if (themes == nil)
    {
        NSString * absolutePathFile = [[NSBundle mainBundle] pathForResource:@"questionsDBpedia" ofType:@"json"];
        NSData * data = [NSData dataWithContentsOfFile:absolutePathFile];
        NSDictionary * dicThemes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray * listThemes = [[dicThemes objectForKey:@"themes"] allObjects];
        themes = nil;
        themes = [[NSMutableArray alloc] init];
        NSInteger index = 0;
        for (NSDictionary * themeDetails in listThemes)
        {
            Theme * theme = [[Theme alloc] init];
            theme.idTheme = index;
            theme.nameThemeFR = [themeDetails objectForKey:@"nameThemeFR"];
            theme.nameThemeEN = [themeDetails objectForKey:@"nameThemeEN"];
            theme.allQuestions = [[NSMutableArray alloc] init];
            
            NSDictionary * dicQuestions = [themeDetails objectForKey:@"questions"];
            for (NSDictionary * questionDetails in dicQuestions)
            {
                Question * question = [[Question alloc] init];
                question.subjectFR = [questionDetails objectForKey:@"subjectFR"];
                question.subjectEN = [questionDetails objectForKey:@"subjectEN"];
                question.goodAnswerFR = [questionDetails objectForKey:@"goodAnswerFR"];
                question.goodAnswerEN = [questionDetails objectForKey:@"goodAnswerEN"];
                question.badAnswerFR = [questionDetails objectForKey:@"badAnswerFR"];
                question.badAnswerEN = [questionDetails objectForKey:@"badAnswerEN"];
                
                question.requestGoodAnswerCount = [[questionDetails objectForKey:@"requestGoodAnswer"] objectForKey:@"count"];
                question.requestGoodAnswerResult = [[questionDetails objectForKey:@"requestGoodAnswer"] objectForKey:@"result"];
                question.requestBadAnswerCount = [[questionDetails objectForKey:@"requestBadAnswer"] objectForKey:@"count"];
                question.requestBadAnswerResult = [[questionDetails objectForKey:@"requestBadAnswer"] objectForKey:@"result"];
                question.numberMinimalResults = [[[questionDetails objectForKey:@"requestBadAnswer"] objectForKey:@"numberMinimalResults"] integerValue];
                question.numberMaximalResults = [[[questionDetails objectForKey:@"requestBadAnswer"] objectForKey:@"numberMaximalResults"] integerValue];
                question.numberRequest = [[[questionDetails objectForKey:@"requestBadAnswer"] objectForKey:@"numberRequest"] integerValue];
                
                [theme.allQuestions addObject:question];
            }
            
            [themes addObject:theme];
            index++;
        }
    }
    return themes;
}

+ (NSMutableArray *) getAllActors
{
    if (actors == nil)
    {
        NSString * absolutePathFile = [[NSBundle mainBundle] pathForResource:@"allActors" ofType:@"json"];
        NSData * data = [NSData dataWithContentsOfFile:absolutePathFile];
        NSDictionary * dicActors = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray * listActors = [[[dicActors objectForKey:@"results"] objectForKey:@"bindings"] allObjects];
        actors = nil;
        actors = [[NSMutableArray alloc] init];
        for (NSDictionary * actorDetails in listActors)
        {
            [actors addObject:[NSString stringWithFormat:@"%@", [[actorDetails objectForKey:@"actor"] objectForKey:@"value"]]];
        }
    }
    return actors;
}

+ (NSMutableArray *) getAllMovies
{
    if (movies == nil)
    {
        NSString * absolutePathFile = [[NSBundle mainBundle] pathForResource:@"allMovies" ofType:@"json"];
        NSData * data = [NSData dataWithContentsOfFile:absolutePathFile];
        NSDictionary * dicMovies = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray * listMovie = [[[dicMovies objectForKey:@"results"] objectForKey:@"bindings"] allObjects];
        movies = nil;
        movies = [[NSMutableArray alloc] init];
        for (NSDictionary * movieDetails in listMovie)
        {
            [movies addObject:[NSString stringWithFormat:@"%@", [[movieDetails objectForKey:@"movie"] objectForKey:@"value"]]];
        }
    }
    return movies;
}

+ (NSMutableArray *) executeQuery:(NSString *)query
{
    if(kDBpediaFetcherLogEnabled)
        NSLog(@"%@", query);
    
    query = [self urlEncode:query usingEncoding:NSASCIIStringEncoding];
    
    NSDictionary * resultsQuery = [DBpediaFetcher DBpediaQuery:query];
    
    NSArray * varsData = [[[resultsQuery objectForKey:@"head"] objectForKey:@"vars"] allObjects];
    NSMutableArray * vars = [[NSMutableArray alloc] init];
    for (NSString * var in varsData)
    {
        [vars addObject:[NSString stringWithFormat:@"?%@", var]];
    }
    NSArray * resultsData = [[[resultsQuery objectForKey:@"results"] objectForKey:@"bindings"] allObjects];
    NSMutableArray * results = [[NSMutableArray alloc] init];
    for (NSDictionary * resultDetails in resultsData)
    {
        NSMutableArray * resultDetailsAdd = [[NSMutableArray alloc] init];
        for (NSString * var in varsData)
        {
            [resultDetailsAdd addObject:[[resultDetails objectForKey:var] objectForKey:@"value"]];
        }
        NSDictionary * dicTemp = [[NSMutableDictionary alloc] initWithObjects:resultDetailsAdd forKeys:vars];
        [results addObject:dicTemp];
    }
    return results;
}

+ (NSString *)urlEncode:(NSString *)stringUrl usingEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)stringUrl, NULL, CFSTR("!*'\"();:@&=+$,/?%#[]% "), CFStringConvertNSStringEncodingToEncoding(encoding)));
}


@end
