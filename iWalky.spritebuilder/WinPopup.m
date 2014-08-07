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
{
    NSArray*     _playerRecord;
    BOOL         _nextLevelPressed;

}

-(void)didLoadFromCCB
{
    _nextLevelPressed = false;
}

- (void)loadNextLevel {

    int sum = 0;
    
    if (!_nextLevelPressed)
    {
        _nextLevelPressed = true;
        int tempPlayerLevel = [[SaveManager sharedManager]getPlayerNormalMapLevel];
        tempPlayerLevel++;
        
        
        if (tempPlayerLevel > [[SaveManager sharedManager] getPlayerHighestLevel])
        {
            
            [[SaveManager sharedManager] savePlayerHighestLevel:tempPlayerLevel];
                    NSNumber* levelNumber = [NSNumber numberWithInt:tempPlayerLevel];
            
                    _playerRecord = [[SaveManager sharedManager]getPlayerHighScoreRecord];
            
                    for (NSNumber *num in  _playerRecord)
                    {
                        sum += [num intValue];
                    }
            
                    NSNumber* scoreAtHighestLevel = [NSNumber numberWithInt:sum];
            
                    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: scoreAtHighestLevel, @"highestScore", levelNumber, @"levelNumber", nil];
            
                    [MGWU logEvent:@"player_Highest_Level" withParams: params];
            
                    CCLOG(@"Player stopped at level %d with score %d", [levelNumber intValue], sum);
            
        }
        
        
        [[SaveManager sharedManager] savePlayerNormalMapLevel:tempPlayerLevel];
        [[SaveManager sharedManager] resetCurrentPlayingMap];
        
        
        
        CCScene *nextLevel = [CCBReader loadAsScene:@"MainScene"];
        
        CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
        [[CCDirector sharedDirector] presentScene:nextLevel withTransition:transition];
    }
    
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
