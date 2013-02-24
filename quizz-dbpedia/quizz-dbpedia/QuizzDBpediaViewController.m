//
//  QuizzDBpediaViewController.m
//  quizz-dbpedia
//
//  Created by Lion User on 16/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "QuizzDBpediaViewController.h"

@interface QuizzDBpediaViewController ()

@end

@implementation QuizzDBpediaViewController
@synthesize theme;
@synthesize question;
@synthesize answerA;
@synthesize answerB;
@synthesize answerC;
@synthesize answerD;
@synthesize questionQuizz;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Generation of a question
    Theme * themeQuizz = [[DBpediaFetcher getAllThemes] objectAtIndex:0];
    questionQuizz = [Quizz getQuestionTheme:themeQuizz.idTheme];
    //Link with the UI
    [theme setTitle:themeQuizz.nameThemeFR];
    [question setText:questionQuizz.questionFR];
    [answerA setTitle:[questionQuizz.badAnswersFR objectAtIndex:1] forState:UIControlStateNormal];
    [answerB setTitle:questionQuizz.goodAnswerFR forState:UIControlStateNormal];
    [answerC setTitle:[questionQuizz.badAnswersFR objectAtIndex:2] forState:UIControlStateNormal];
    [answerD setTitle:[questionQuizz.badAnswersFR objectAtIndex:0] forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [self setTheme:nil];
    [self setQuestion:nil];
    [self setAnswerA:nil];
    [self setAnswerB:nil];
    [self setAnswerC:nil];
    [self setAnswerD:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)selectAnswer:(id)sender {
    //Know if it's the good answer
    if ([sender currentTitle] == questionQuizz.goodAnswerFR)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Winner" message:@"You win!" delegate:self cancelButtonTitle:@"I know I know" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loser" message:@"Try again!" delegate:self cancelButtonTitle:@"OK..." otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)refresh:(id)sender {
    //Generation of a question
    Theme * themeQuizz = [[DBpediaFetcher getAllThemes] objectAtIndex:0];
    questionQuizz = [Quizz getQuestionTheme:themeQuizz.idTheme];
    //Link with the UI
    [theme setTitle:themeQuizz.nameThemeFR];
    [question setText:questionQuizz.questionFR];
    [answerA setTitle:[questionQuizz.badAnswersFR objectAtIndex:1] forState:UIControlStateNormal];
    [answerB setTitle:questionQuizz.goodAnswerFR forState:UIControlStateNormal];
    [answerC setTitle:[questionQuizz.badAnswersFR objectAtIndex:2] forState:UIControlStateNormal];
    [answerD setTitle:[questionQuizz.badAnswersFR objectAtIndex:0] forState:UIControlStateNormal];
}

@end
