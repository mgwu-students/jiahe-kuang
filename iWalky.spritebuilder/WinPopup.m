//
//  WinPopup.m
//  iWalky
//
//  Created by Jiahe Kuang on 7/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "WinPopup.h"
#import "SaveManager.h"

@implementation WinPopup

- (void)loadNextLevel {
    
    
    
    
    
    int tempPlayerLevel = [[SaveManager sharedManager]getPlayerNormalMapLevel];
    tempPlayerLevel++;
    
    [[SaveManager sharedManager] savePlayerNormalMapLevel:tempPlayerLevel];
    [[SaveManager sharedManager] resetCurrentPlayingMap];
    

    
    CCScene *nextLevel = [CCBReader loadAsScene:@"MainScene"];
    
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:nextLevel withTransition:transition];
}

-(void)retry
{
    int tempStarCount = [[SaveManager sharedManager]getStarCount];
    if (tempStarCount > 0)
    {
        tempStarCount--;
        [[SaveManager sharedManager] saveStarCount:tempStarCount];
        
        CCScene *nextLevel = [CCBReader loadAsScene:@"MainScene"];
        
        CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
        [[CCDirector sharedDirector] presentScene:nextLevel withTransition:transition];
    }

}

-(void)finish
{
    [[SaveManager sharedManager] resetCurrentPlayingMap];
    
    
    
    CCScene *nextLevel = [CCBReader loadAsScene:@"StartScreen"];
    
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:nextLevel withTransition:transition];
}

@end
