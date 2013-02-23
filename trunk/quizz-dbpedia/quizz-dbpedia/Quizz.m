//
//  Quizz.m
//  quizz-dbpedia
//
//  Created by Lion User on 20/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Quizz.h"
#import <stdlib.h>

@implementation Quizz

#define kKeywordActor       @"?randomActorApp"
#define kKeywordActor2      @"?randomActor2App"
#define kKeywordMovie       @"?randomMovieApp"
#define kKeywordMovie2      @"?randomMovie2App"
#define kMaximumBadAnswers  3

+ (QuestionQuizz *) getQuestionTheme:(NSInteger) idTheme
{
    Question * question = [[[DBpediaFetcher getAllThemes] objectAtIndex:idTheme] getRandomQuestion];
    QuestionQuizz * questionQuizz = [[QuestionQuizz alloc] init];
    
    //Initialize the questionQuizz
    questionQuizz.questionFR = question.subjectFR;
    questionQuizz.questionEN = question.subjectEN;
    questionQuizz.goodAnswerFR = question.goodAnswerFR;
    questionQuizz.goodAnswerEN = question.goodAnswerEN;
    questionQuizz.badAnswersFR = [[NSMutableArray alloc] init];
    questionQuizz.badAnswersEN = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < kMaximumBadAnswers; i++)
    {
        [questionQuizz.badAnswersFR addObject:question.badAnswerFR];
        [questionQuizz.badAnswersEN addObject:question.badAnswerEN];
    }
    
    NSString * actor, * actor2;
    NSString * movie, * movie2;
    NSString * query;
    NSMutableArray * results;
    NSArray * keys;
    NSInteger count = 0;
    
    while (count < 1)
    {
        actor = [[DBpediaFetcher getAllActors] objectAtIndex:(arc4random() % [[DBpediaFetcher getAllActors] count])];
        movie = [[DBpediaFetcher getAllMovies] objectAtIndex:(arc4random() % [[DBpediaFetcher getAllMovies] count])];
        
        query = [question.requestGoodAnswerCount stringByReplacingOccurrencesOfString:kKeywordActor withString:actor];
        query = [query stringByReplacingOccurrencesOfString:kKeywordMovie withString:movie];
        results = [DBpediaFetcher executeQuery:query];
        if ([results count] > 0)
        {
            keys = [[results objectAtIndex:0] allKeys];
            count = [[[results objectAtIndex:0] objectForKey:[keys objectAtIndex:0]] integerValue];
        }
    }
    
    query = [question.requestGoodAnswerResult stringByReplacingOccurrencesOfString:kKeywordActor withString:actor];
    query = [query stringByReplacingOccurrencesOfString:kKeywordMovie withString:movie];
    results = [DBpediaFetcher executeQuery:query];
    
    if ([results count] > 0)
    {
        //Do the replacement
        keys = [[results objectAtIndex:0] allKeys];
        NSDictionary * resultSelected = [results objectAtIndex:(arc4random() % [results count])];
        for (NSString * key in keys)
        {
            questionQuizz.questionFR = [questionQuizz.questionFR stringByReplacingOccurrencesOfString:key withString:[resultSelected objectForKey:key]];
            questionQuizz.questionEN = [questionQuizz.questionEN stringByReplacingOccurrencesOfString:key withString:[resultSelected objectForKey:key]];
            questionQuizz.goodAnswerFR = [questionQuizz.goodAnswerFR stringByReplacingOccurrencesOfString:key withString:[resultSelected objectForKey:key]];
            questionQuizz.goodAnswerEN = [questionQuizz.goodAnswerEN stringByReplacingOccurrencesOfString:key withString:[resultSelected objectForKey:key]];
            for (NSInteger i = 0; i < kMaximumBadAnswers; i++)
            {
                [questionQuizz.badAnswersFR replaceObjectAtIndex:i withObject:[[questionQuizz.badAnswersFR objectAtIndex:i] stringByReplacingOccurrencesOfString:key withString:[resultSelected objectForKey:key]]];
                [questionQuizz.badAnswersEN replaceObjectAtIndex:i withObject:[[questionQuizz.badAnswersEN objectAtIndex:i] stringByReplacingOccurrencesOfString:key withString:[resultSelected objectForKey:key]]];
            }
        }
        
        NSInteger numberBadAnswer = 0;
        while (numberBadAnswer < question.numberRequest)
        {
            count = -1;
            while (count < question.numberMinimalResults || (question.numberMaximalResults != -1 && count > question.numberMaximalResults))
            {
                actor2 = [[DBpediaFetcher getAllActors] objectAtIndex:(arc4random() % [[DBpediaFetcher getAllActors] count])];
                while (actor == actor2)
                {
                    actor2 = [[DBpediaFetcher getAllActors] objectAtIndex:(arc4random() % [[DBpediaFetcher getAllActors] count])];
                }
                movie2 = [[DBpediaFetcher getAllMovies] objectAtIndex:(arc4random() % [[DBpediaFetcher getAllMovies] count])];
                while (movie == movie2)
                {
                    movie2 = [[DBpediaFetcher getAllMovies] objectAtIndex:(arc4random() % [[DBpediaFetcher getAllMovies] count])];
                }
                
                query = [question.requestBadAnswerCount stringByReplacingOccurrencesOfString:kKeywordActor withString:actor];
                query = [query stringByReplacingOccurrencesOfString:kKeywordActor2 withString:actor2];
                query = [query stringByReplacingOccurrencesOfString:kKeywordMovie withString:movie];
                query = [query stringByReplacingOccurrencesOfString:kKeywordMovie2 withString:movie2];
                results = [DBpediaFetcher executeQuery:query];
                if ([results count] > 0)
                {
                    keys = [[results objectAtIndex:0] allKeys];
                    count = [[[results objectAtIndex:0] objectForKey:[keys objectAtIndex:0]] integerValue];
                }
            }
            
            query = [question.requestBadAnswerResult stringByReplacingOccurrencesOfString:kKeywordActor withString:actor];
            query = [query stringByReplacingOccurrencesOfString:kKeywordActor2 withString:actor2];
            query = [query stringByReplacingOccurrencesOfString:kKeywordMovie withString:movie];
            query = [query stringByReplacingOccurrencesOfString:kKeywordMovie2 withString:movie2];
            results = [DBpediaFetcher executeQuery:query];
            
            if ([results count] > 0)
            {
                keys = [[results objectAtIndex:0] allKeys];
                if (question.numberRequest == 1)
                {
                    numberBadAnswer = 0;
                    while (numberBadAnswer < kMaximumBadAnswers)
                    {
                        //Do the replacement
                        NSDictionary * resultSelected = [results objectAtIndex:(arc4random() % [results count])];
                        NSString * varTempFR = [questionQuizz.badAnswersFR objectAtIndex:numberBadAnswer];
                        NSString * varTempEN = [questionQuizz.badAnswersEN objectAtIndex:numberBadAnswer];
                        for (NSString * key in keys)
                        {
                            varTempFR = [varTempFR stringByReplacingOccurrencesOfString:key withString:[resultSelected objectForKey:key]];
                            varTempEN = [varTempEN stringByReplacingOccurrencesOfString:key withString:[resultSelected objectForKey:key]];
                        }
                        if ([questionQuizz.badAnswersFR indexOfObject:varTempFR] == NSNotFound)
                        {
                            [questionQuizz.badAnswersFR replaceObjectAtIndex:numberBadAnswer withObject:varTempFR];
                            [questionQuizz.badAnswersEN replaceObjectAtIndex:numberBadAnswer withObject:varTempEN];
                            numberBadAnswer++;
                        }
                    }
                }
                else
                {
                    //Do the replacement
                    NSDictionary * resultSelected = [results objectAtIndex:(arc4random() % [results count])];
                    NSString * varTempFR = [questionQuizz.badAnswersFR objectAtIndex:numberBadAnswer];
                    NSString * varTempEN = [questionQuizz.badAnswersEN objectAtIndex:numberBadAnswer];
                    for (NSString * key in keys)
                    {
                        varTempFR = [varTempFR stringByReplacingOccurrencesOfString:key withString:[resultSelected objectForKey:key]];
                        varTempEN = [varTempEN stringByReplacingOccurrencesOfString:key withString:[resultSelected objectForKey:key]];
                    }
                    if ([questionQuizz.badAnswersFR indexOfObject:varTempFR] == NSNotFound)
                    {
                        [questionQuizz.badAnswersFR replaceObjectAtIndex:numberBadAnswer withObject:varTempFR];
                        [questionQuizz.badAnswersEN replaceObjectAtIndex:numberBadAnswer withObject:varTempEN];
                        numberBadAnswer++;
                    }
                }
            }
        }
    }
    
    return questionQuizz;
}

@end
