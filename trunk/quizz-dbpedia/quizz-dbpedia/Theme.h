//
//  Theme.h
//  quizz-dbpedia
//
//  Created by Lion User on 19/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface Theme : NSObject

@property(assign) NSInteger idTheme;
@property(strong) NSString * nameThemeFR;
@property(strong) NSString * nameThemeEN;
@property(strong) NSMutableArray * allQuestions;

// Get a random question of the theme
- (Question *) getRandomQuestion;

@end
