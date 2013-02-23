//
//  QuizzDBpediaViewController.h
//  quizz-dbpedia
//
//  Created by Lion User on 16/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quizz.h"

@interface QuizzDBpediaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *theme;
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UIButton *answerA;
@property (weak, nonatomic) IBOutlet UIButton *answerB;
@property (weak, nonatomic) IBOutlet UIButton *answerC;
@property (weak, nonatomic) IBOutlet UIButton *answerD;

- (IBAction)selectAnswer:(id)sender;


@property(strong) QuestionQuizz * questionQuizz;

@end
