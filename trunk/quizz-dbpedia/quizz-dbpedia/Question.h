//
//  Question.h
//  quizz-dbpedia
//
//  Created by Lion User on 19/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Question : NSObject

@property(strong) NSString * subjectFR;
@property(strong) NSString * subjectEN;
@property(strong) NSString * answerFR;
@property(strong) NSString * answerEN;
@property(strong) NSString * requestGoodAnswerCount;
@property(strong) NSString * requestGoodAnswerResult;
@property(strong) NSString * requestBadAnswerCount;
@property(strong) NSString * requestBadAnswerResult;
@property(assign) NSInteger numberMinimalResults;
@property(assign) NSInteger numberMaximalResults;
@property(assign) NSInteger numberRequest;

@end
