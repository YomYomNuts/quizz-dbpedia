//
//  Theme.m
//  quizz-dbpedia
//
//  Created by Lion User on 19/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Theme.h"
#import <stdlib.h>

@implementation Theme

@synthesize idTheme;
@synthesize nameThemeFR;
@synthesize nameThemeEN;
@synthesize allQuestions;

// Get a random question of the theme
- (Question *) getRandomQuestion
{
    return [self.allQuestions objectAtIndex:(arc4random() % [self.allQuestions count])];
}

@end
