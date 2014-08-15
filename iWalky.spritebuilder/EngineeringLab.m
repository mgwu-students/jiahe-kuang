//
//  EngineeringLab.m
//  iWalky
//
//  Created by Jiahe Kuang on 7/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "EngineeringLab.h"
#import "SaveManager.h"

static int STAR_COST_FOR_ENGIN_UPGRADE = 50;
static int STAR_COST_FOR_SHIELD_UPGRADE = 80;
//static int STAR_COST_FOR_ENERGYEXTRACTOR_UPGRADE = 30;


@implementation EngineeringLab
{
    CCParticleSystem* _engineUpgradeParticle;
    CCParticleSystem* _downgradeParticle;
    
    int _currentEngineLevel;
    CCLabelTTF* _engineLevelLabel;
    
    int _currentShieldLevel;
    CCLabelTTF* _shieldLabel;

    
    int _currentEnergyExtractorLevel;
    
    int _currentStarCount;
    CCLabelTTF* _currentStartCountLabel;
    
    
    CCSprite* _engineIcon;
    
    BOOL isResearching;
}

-(void)didLoadFromCCB
{
    isResearching = false;
    [_engineUpgradeParticle stopSystem];
    [_downgradeParticle stopSystem];
    _currentEngineLevel = [[SaveManager sharedManager]getEngineLevel];
    _currentShieldLevel = [[SaveManager sharedManager]getshieldDurability];
    [_engineLevelLabel setString:[NSString stringWithFormat:@"%d", _currentEngineLevel]];
    [_shieldLabel setString:[NSString stringWithFormat:@"%d", _currentShieldLevel]];
    
    
    _currentStarCount = [[SaveManager sharedManager] getStarCount];
    [_currentStartCountLabel setString:[NSString stringWithFormat:@"%d", _currentStarCount]];
    
    
    
}

-(void)GoBackToPlayerProfile
{
    CCScene* sceneAboutToEnter = [CCBReader loadAsScene:@"PlayerProfile"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:sceneAboutToEnter withTransition:transition];
}


-(void)EngineUpgrade
{
    if (_currentStarCount > (STAR_COST_FOR_ENGIN_UPGRADE * (_currentEngineLevel + 1)) && _currentEngineLevel < 11 &&  !isResearching)
    {
        
        [_engineUpgradeParticle resetSystem];
        CCActionRotateBy* upgradeRotation = [CCActionRotateBy actionWithDuration:1 angle:359];
        [_engineIcon runAction:upgradeRotation];
        
        isResearching = true;
        _currentStarCount -= STAR_COST_FOR_ENGIN_UPGRADE * (_currentEngineLevel + 1);
        [[SaveManager sharedManager] saveStarCount:_currentStarCount];
        [_currentStartCountLabel setString:[NSString stringWithFormat:@"%d", _currentStarCount]];

        int successRate = 55 - 5 * _currentEngineLevel;
        int tempRamdonNumber = (arc4random()%100);
        CCLOG(@"Your lucky number %d for engine level: %d", tempRamdonNumber, _currentEngineLevel+1);
        if ( tempRamdonNumber < successRate)
        {
            _currentEngineLevel++;
            [[SaveManager sharedManager] saveEngineLevel:_currentEngineLevel];
        }
        
//        else
//        {
//            if (_currentEngineLevel > 0)
//            {
//                _currentEngineLevel--;
//            }
//            [[SaveManager sharedManager] SaveEngineLevel:_currentEngineLevel];
//            [_engineLevelLabel setString:[NSString stringWithFormat:@"%d", _currentEngineLevel]];
//            
//        }
        
        CCActionSequence* engineLabelUpdateSequence = [CCActionSequence
                                           actions:
                                           [CCActionDelay actionWithDuration:1.1f],
                                           [CCActionCallBlock
                                            actionWithBlock:^{
                                                [_engineLevelLabel setString:[NSString stringWithFormat:@"%d", _currentEngineLevel]];
                                                isResearching = false;

                                            }],
                                           nil];
        [self runAction:engineLabelUpdateSequence];


    }
}


-(void)ShieldUpgrade
{
    if (_currentStarCount > (STAR_COST_FOR_SHIELD_UPGRADE * (_currentShieldLevel + 2)) &&  _currentShieldLevel < 11 && !isResearching)
    {
        _downgradeParticle.position = ccp(0.5, 0.35);
        [_downgradeParticle resetSystem];
        
        isResearching = true;
        _currentStarCount -= STAR_COST_FOR_SHIELD_UPGRADE * (_currentShieldLevel + 2);
        [[SaveManager sharedManager] saveStarCount:_currentStarCount];
        [_currentStartCountLabel setString:[NSString stringWithFormat:@"%d", _currentStarCount]];
        
        int successRate = 55 - 5 * _currentShieldLevel;
        int tempRamdonNumber = (arc4random()%100);
        CCLOG(@"Your lucky number %d for shield level: %d", tempRamdonNumber, _currentShieldLevel+1);
        if ( tempRamdonNumber < successRate)
        {
            _currentShieldLevel++;
            [[SaveManager sharedManager] saveShieldDurability: _currentShieldLevel];
        }
        
        //        else
        //        {
        //            if (_currentEngineLevel > 0)
        //            {
        //                _currentEngineLevel--;
        //            }
        //            [[SaveManager sharedManager] SaveEngineLevel:_currentEngineLevel];
        //            [_engineLevelLabel setString:[NSString stringWithFormat:@"%d", _currentEngineLevel]];
        //
        //        }
        
        CCActionSequence* shieldLabelUpdateSequence = [CCActionSequence
                                                       actions:
                                                       [CCActionDelay actionWithDuration:1.1f],
                                                       [CCActionCallBlock
                                                        actionWithBlock:^{
                                                            [_shieldLabel setString:[NSString stringWithFormat:@"%d", _currentShieldLevel]];
                                                            isResearching = false;
                                                            
                                                        }],
                                                       nil];
        [self runAction:shieldLabelUpdateSequence];
        
        
    }
}

-(void)EngineDownGrade
{
    if (_currentEngineLevel > 0 && !isResearching)
    {
    isResearching = true;
    _downgradeParticle.position = ccp(0.5, 0.8);
    [_downgradeParticle resetSystem];
    CCActionRotateBy* downgradeRotation = [CCActionRotateBy actionWithDuration:1 angle:-359];
    [_engineIcon runAction:downgradeRotation];

        _currentEngineLevel--;
        [[SaveManager sharedManager] saveEngineLevel:_currentEngineLevel];
        [_engineLevelLabel setString:[NSString stringWithFormat:@"%d", _currentEngineLevel]];

    isResearching = false;
    }

    
}

-(void)ShieldDownGrade
{
    if (_currentShieldLevel > 0 && !isResearching)
    {
        isResearching = true;
        _downgradeParticle.position = ccp(0.5, 0.35);
        [_downgradeParticle resetSystem];

        
        _currentShieldLevel--;
        [[SaveManager sharedManager] saveShieldDurability:_currentShieldLevel];
        [_shieldLabel setString:[NSString stringWithFormat:@"%d", _currentShieldLevel]];
        
        isResearching = false;
    }
    
    
}

-(void)GoToLevels
{
    CCScene* sceneAboutToEnter = [CCBReader loadAsScene:@"LevelScreen"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:sceneAboutToEnter withTransition:transition];
    
}

-(void)GenerateStars
{
    [[SaveManager sharedManager]saveStarCount:99999];
    
    _currentStarCount = [[SaveManager sharedManager] getStarCount];
    [_currentStartCountLabel setString:[NSString stringWithFormat:@"%d", _currentStarCount]];

}

-(void)ClearStars
{
    [[SaveManager sharedManager]resetStarCount];
    _currentStarCount = [[SaveManager sharedManager] getStarCount];
    [_currentStartCountLabel setString:[NSString stringWithFormat:@"%d", _currentStarCount]];
}

@end
