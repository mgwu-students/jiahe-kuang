//
//  PlayerProfile.m
//  iWalky
//
//  Created by Jiahe Kuang on 7/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PlayerProfile.h"
#import "SaveManager.h"
static int BRONZE_TIER = 1200;
static int SILVER_TIER = 1290;
static int GOLD_TIER = 1310;
static int PLATINUM_TIER = 1330;
static int DIAMOND_TIER = 1350;

@implementation PlayerProfile
{
//    CCScrollView* _maps;

    NSArray* _playerRecord;
    NSInteger sum;
    
    
    CCLabelTTF* _totalBestScoreLabel;
    CCLabelTTF* _rankingLabel;
    CCLabelTTF* _enginePowerLabel;
    CCLabelTTF* _speedLabel;
    CCLabelTTF* _shieldDurabilityLabel;
    CCLabelTTF* _shieldLevelLabel;
    int engineLevel;
    int shieldDurability;
}

-(void)didLoadFromCCB
{    
    sum = 0;
    engineLevel = [[SaveManager sharedManager] getEngineLevel];
    shieldDurability = [[SaveManager sharedManager] getshieldDurability];
    _playerRecord = [[SaveManager sharedManager]getPlayerHighScoreRecord];
    [self updateShieldDurability];
    [self updateTotalBestScoreLabel];
    [self updateRankingLabel];
    [self updateEnginePower];
    [self updateSpeedLabel];
    [self updateShieldLevel];

}

-(void)Menu
{
    CCScene* sceneAboutToEnter = [CCBReader loadAsScene:@"StartScreen"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:sceneAboutToEnter withTransition:transition];
}

-(void)GoToLab
{
    CCScene* sceneAboutToEnter = [CCBReader loadAsScene:@"EngineeringLab"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:sceneAboutToEnter withTransition:transition];
}

-(void)ResetPlayerProfile
{
    [[SaveManager sharedManager] resetPlayerNormalMapLevel];
    [[SaveManager sharedManager] resetCurrentPlayingMap];
    [[SaveManager sharedManager] resetStarCount];
    [[SaveManager sharedManager] resetBarrelCount];
    [[SaveManager sharedManager] resetPlayerHighScoreRecord];
    [[SaveManager sharedManager] resetPlayerHighestLevel];
    
//    [_maps.contentNode removeAllChildren];
    [_totalBestScoreLabel setString:[NSString stringWithFormat:@"%d", 0]];
    [_rankingLabel setString:[NSString stringWithFormat:@"Bronze"]];

    
    
}

-(void)updateTotalBestScoreLabel
{
    for (NSNumber *num in  _playerRecord)
    {
        sum += [num intValue];
    }
    
    [_totalBestScoreLabel setString:[NSString stringWithFormat:@"%d", sum]];
    
}

-(void)updateEnginePower
{
    [_enginePowerLabel setString:[NSString stringWithFormat:@"+ %d", engineLevel]];

}
-(void)updateShieldLevel
{
    [_shieldLevelLabel setString:[NSString stringWithFormat:@"+ %d", shieldDurability]];
    
}


-(void)updateShieldDurability
{
    [_shieldDurabilityLabel setString:[NSString stringWithFormat:@"%.2f", shieldDurability / 4.0f]];

}

-(void)updateSpeedLabel
{
    [_speedLabel setString:[NSString stringWithFormat:@"%.2f", (1.f / (0.8 - 0.05*engineLevel))]];
}

-(void)updateRankingLabel
{
    if (sum <= BRONZE_TIER)
    {
        [_rankingLabel setString:[NSString stringWithFormat:@"Bronze"]];
    }
    
    if (sum > BRONZE_TIER && sum <= SILVER_TIER)
    {
        [_rankingLabel setString:[NSString stringWithFormat:@"Silver"]];
    }
    
    if (sum > SILVER_TIER && sum <= GOLD_TIER)
    {
        [_rankingLabel setString:[NSString stringWithFormat:@"Gold"]];
    }
    
    if (sum > GOLD_TIER && sum <= PLATINUM_TIER)
    {
        [_rankingLabel setString:[NSString stringWithFormat:@"Platinum"]];
    }
    
    if (sum > PLATINUM_TIER && sum <= DIAMOND_TIER)
    {
        [_rankingLabel setString:[NSString stringWithFormat:@"Diamond"]];
    }
    
    if(sum > DIAMOND_TIER)
    {
        [_rankingLabel setString:[NSString stringWithFormat:@"Master"]];
        
    }

}

@end
