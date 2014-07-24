//
//  LevelIndex.m
//  iWalky
//
//  Created by Jiahe Kuang on 7/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelIndex.h"
#import "SaveManager.h"

@implementation LevelIndex
{
    NSMutableArray* _levelIndex;
    NSArray* playerBestScores;
    float positionCounter;
}


-(void)didLoadFromCCB
{
    
    
    CCLOG(@"loaded into scrollView");
    positionCounter = 3200.f;
    
    _levelIndex = [NSMutableArray array];
    playerBestScores = [[SaveManager sharedManager] getPlayerHighScoreRecord];
    

    
    int playerHighestLevel = [[SaveManager sharedManager]getPlayerHighestLevel];
    
    
    for (int i = 0; i < playerHighestLevel; i++)
    {
        LevelRecord* levelRecord = (LevelRecord*) [CCBReader load:@"LevelRecord"];
        [levelRecord setLevelLabel:i+1];
        int tempScore = [((NSNumber*)[playerBestScores objectAtIndex:i])integerValue];
        [levelRecord setBestScoreLabel:tempScore];
        
        [_levelIndex insertObject:levelRecord atIndex:i];
    }
    
    for (int y = 0; y < [_levelIndex count]; y++) {
        
        [self addChild:[_levelIndex objectAtIndex:y]];
        ((CCNode*)[_levelIndex objectAtIndex:y]).position = ccp(0.0f, positionCounter);
        positionCounter = positionCounter - 66.f;

    }
    
    
}
@end
