//
//  StartScreen.m
//  iWalky
//
//  Created by Jiahe Kuang on 7/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StartScreen.h"
#import "SaveManager.h"

@implementation StartScreen

-(void)startNormalGame
{

    CCScene* sceneAboutToEnter = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:sceneAboutToEnter withTransition:transition];
    
}

-(void)startRankedGame
{
    
}

-(void)goToPlayerProfile
{
    CCScene* sceneAboutToEnter = [CCBReader loadAsScene:@"PlayerProfile"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:sceneAboutToEnter withTransition:transition];
}

-(void)GoToLevelScreen
{
    CCScene* sceneAboutToEnter = [CCBReader loadAsScene:@"LevelScreen"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:sceneAboutToEnter withTransition:transition];
    
}



@end
