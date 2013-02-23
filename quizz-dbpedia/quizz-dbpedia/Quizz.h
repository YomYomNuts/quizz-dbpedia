//
//  Quizz.h
//  quizz-dbpedia
//
//  Created by Lion User on 20/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionQuizz.h"
#import "DBpediaFetcher.h"
#import "Theme.h"
#import "Question.h"

@interface Quizz : NSObject

+ (QuestionQuizz *) getQuestionTheme:(NSInteger) idTheme;

@end
