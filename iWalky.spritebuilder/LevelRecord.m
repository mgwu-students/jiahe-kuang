//
//  LevelRecord.m
//  iWalky
//
//  Created by Jiahe Kuang on 7/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelRecord.h"
#import "SaveManager.h"

@implementation LevelRecord
{
    CCLabelTTF* _levelLabel;
    CCLabelTTF* _bestScoreLabel;
    int _playThisLevel;
}

-(void)setLevelLabel: (int)playerLevel
{
    _playThisLevel = playerLevel;
    [_levelLabel setString:[NSString stringWithFormat:@"%d", playerLevel]];
}
-(void)setBestScoreLabel: (int)playerBestScore
{
    [_bestScoreLabel setString:[NSString stringWithFormat:@"%d", playerBestScore]];
}

-(void)Play
{
    [[SaveManager sharedManager] savePlayerNormalMapLevel:_playThisLevel];
    [[SaveManager sharedManager] resetCurrentPlayingMap];
    CCScene* sceneAboutToEnter = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:sceneAboutToEnter withTransition:transition];
}

@end
