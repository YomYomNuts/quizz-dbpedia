//
//  QuestionQuizz.h
//  quizz-dbpedia
//
//  Created by Lion User on 22/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionQuizz : NSObject

@property(strong) NSString * questionFR;
@property(strong) NSString * questionEN;
@property(strong) NSString * goodAnswerFR;
@property(strong) NSString * goodAnswerEN;
@property(strong) NSMutableArray * badAnswersFR;
@property(strong) NSMutableArray * badAnswersEN;

@end
