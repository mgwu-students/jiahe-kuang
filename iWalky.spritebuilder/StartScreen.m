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
    if ([[SaveManager sharedManager]getPlayerNormalMapLevel] == 0) {
        [[SaveManager sharedManager]saveBarrelCount:10];
        [[SaveManager sharedManager]saveStarCount:3];
    }
    CCScene* sceneAboutToEnter = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:sceneAboutToEnter withTransition:transition];
    
}

-(void)startRankedGame
{
    
}

-(void)goToPlayerProfile
{
    
}

-(void)ResetPlayerProfile
{
    [[SaveManager sharedManager] resetPlayerNormalMapLevel];
    [[SaveManager sharedManager] resetCurrentPlayingMap];
    [[SaveManager sharedManager] resetStarCount];
    [[SaveManager sharedManager] resetBarrelCount];
}

@end
