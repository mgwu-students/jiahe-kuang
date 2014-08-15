//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "CCActionInterval.h"
#import "Character.h"
#import "Tile.h"
#import "EndTile.h"
#import "StartTile.h"
#import "Explosion.h"
#import "PlayerProfile.h"
#import "SaveManager.h"
#import "WinPopup.h"
#import "Timer.h"
#import "Star.h"
#import "Barrel.h"
#import "OverPopup.h"
#import "WeaponSystem.h"


static int MAPS_PER_LEVEL = 1;
static int MAX_NUMBER_OF_MAPS = 30;

static int BRONZE_TIER = 1200;
static int SILVER_TIER = 1290;
static int GOLD_TIER = 1310;
static int PLATINUM_TIER = 1330;
static int DIAMOND_TIER = 1350;




//static int SECOND_PER_LEVEL = 5;

@implementation MainScene
{
    
    CCLabelTTF* _EarnedStarLabel;
    
    
    BOOL shownGameTip;
    CCNode* _instructionArrow;
    
    CCNode* _rotateLeftButtonAnimation;
    CCNode* _moveForwardAnimation;
    CCNode* _rotateRightButtonAnimation;
    
    int shieldDurability;
    int weaponSystemLevel;
    
    CCParticleSystem* _weaponTailParticle;
    CCButton* _fireButton;
    
    
    CCLabelTTF* _tutorialBannerLabel;
    
    CCButton* _shieldButton;
    
    CCNode* _blackHole1;
    CCNode* _blackHole2;
    CCNode* _blackHole3;
    CCNode* _blackHole4;
    CCNode* _blackHole5;

    
    CCLabelTTF* _levelLabelText;
    CCLabelTTF* _levelDisplayLabel;
    
    CCLabelTTF* _menuLabel;
    CCLabelTTF* _clearLabel;;

    
    CCLabelTTF* _totalHighScoreLabel;
    CCLabelTTF* _rankLabel;
    CCButton* _retryButton;
    CCButton* _nextButton;
    CCButton* _finishButton;
    
    CCNode* _portal1Start;
    CCNode* _portal1End;
    
    
    CCNode* _portal2Start;
    CCNode* _portal2End;
    
    
    CCNode* _portal3Start;
    CCNode* _portal3End;
    
    
    CCNode* _portal4Start;
    CCNode* _portal4End;
    
    CCNode* _portal5Start;
    CCNode* _portal5End;


    
    CCLabelTTF* _LabelIndicator;
    
    NSMutableArray* instructionSet;
    
    NSMutableArray* playerHighScoreRecord;
    
    int currentLevel;
    CCNode* _levelMapFrame;
    Character*  character;
    int instructionCounts;
    
    EndTile* _endTile;
    StartTile* _startTile;
    CCNode* tileNode;
    BOOL characterIsAlive;
    int playerMapLevel;
    int randomMapPicker;
    
    NSString* currentPlayingMap;
    
    CCLabelTTF* _timerLabel;
    float mTimeInSec;
    
    CCLabelTTF* _currentScoreLabel;
    CCLabelTTF* _highScoreLabel;
    
//    CCLabelTTF* _newHighScoreLabel;
    
//    CCTimer* countDownTimer;
//    Timer* timerNode;
//    int countDownTimerCheck;
    
    CCLabelTTF* _starCountsLabel;
//    CCLabelTTF* _barrelCountsLabel;
    
    int starCounts;
//    int barrelCounts;
    
    Star* _star;
//    Barrel* _barrel;
    
    BOOL won;
    
    BOOL goPressed;
    
    BOOL isAboutToDemote;
    
    BOOL clearPressed;
    
    CCButton* _acceleration;
    
    CCParticleSystem* _rotateLeftParticle;
    CCParticleSystem* _rotateRightParticle;
    CCParticleSystem* _goUpParticle;
    CCParticleSystem* _starParticle;
    
    CCParticleSystem* _hightLightParticleForLeft;
    CCParticleSystem* _hightLightParticleForMoveForward;
    CCParticleSystem* _hightLightParticleForRight;
    
    CCButton* _turnLeftButton;
    CCButton* _turnRightButton;
    CCButton* _goUpButton;
    CCButton* _startEngineButton;
    

    CCButton* _clearButton;
    CCButton* _menuButton;
    
    CCSprite* _arrow1;
    CCSprite* _arrow2;
    CCSprite* _arrow3;
    
//    CCLabelTTF* _moveForwardLabel;
    
    CCNode* _tutorialLabel;
    
    CCSprite* _star_Icon;
//    CCSprite* _barrel_Icon;
    
    int level2TutorialMoveForwardCounter;
    int level3TutorialMoveForwardCounter;
    
    BOOL level3isAboutDone;

    
    BOOL solarDisruption;

    
    
    
}


-(void)actionFinished
{

    [self checkIfILost];
    
    if (characterIsAlive)
    {
        [self checkForPortal];
        [self checkForBlackHole];
//        [self checkForBarrel];
        [self checkForStar];

        
        [self checkIfGameFinished];

        [self checkIfIwon];
        
    }
    
    
    if(instructionCounts < ([instructionSet count] -1))
    {
        instructionCounts++;
        [self executeInstruction];
    }
    
    
    
}

- (void)didLoadFromCCB
{
    [[SaveManager sharedManager]saveWeaponsystemLevel:2];
    shieldDurability = [[SaveManager sharedManager]getshieldDurability];
    weaponSystemLevel = [[SaveManager sharedManager]getWeaponSystemLevel];
    
    _shieldButton.visible = false;
    _fireButton.visible = true;
    solarDisruption = false;
    [[SaveManager sharedManager]resetIsSucking];

    mTimeInSec = 0.0f;
    
    shownGameTip = false;
    
    [self schedule:@selector(tick:) interval:(1.f)];
    
    if ([[SaveManager sharedManager]getPlayerNormalMapLevel] == 0)
    {
//        [[SaveManager sharedManager]saveBarrelCount:10];
        [[SaveManager sharedManager]saveStarCount:999];
//        [[SaveManager sharedManager]saveShieldDurability:5];
    }
    
    [_rotateLeftParticle stopSystem];
    [_rotateRightParticle stopSystem];
    [_goUpParticle stopSystem];
    [_starParticle stopSystem];
    
    
    _acceleration.visible = false;
    won = false;
    goPressed = false;
    clearPressed = false;
    //it loads the current map level, it is needed when the player advances to the next level
    [self loadPlayerMapLevel];
    
    
    
    //it loads the same map that was being played.
    //if the player gets to a new level or reset the game, it will become nill
    //a random map will be picked from the map pool according to playerMapLevel,
    //and will be saved as the new currentPlayingMap
    [self loadCurrentPlayingMap];
    
    
    //it loads all the map contents into the scene
    [self loadMapContents];
    
    
    //it creates an instruction set and set the instruction counter to zero
    [self settingUpInstructionSet_And_InstructionCounter];
    
    //it sets the character delegate to itself
    [self setCharacterDelegateToSelf];
    
    
    //it sets characterIsAlive state to be true
    [self setCharacterIsAliveToBeTrue];
    
//    if (playerMapLevel > 10) {
//        [self loadTimerNode];
//        
//        [self setTimerLabel];
//        
//        [self checkTimer];
//    }

    
    starCounts = [[SaveManager sharedManager] getStarCount];
//    barrelCounts = [[SaveManager sharedManager] getBarrelCount];
    
   _starCountsLabel.string = [NSString stringWithFormat:@"%d", starCounts];
//   _barrelCountsLabel.string = [NSString stringWithFormat:@"%d", barrelCounts];
    
    isAboutToDemote = false;
    
    _star = (Star*)[CCBReader load:@"Star"];
    
    _star.position = ccp(_endTile.position.x+16, _endTile.position.y+16);
    
    character.zOrder = _star.zOrder + 1;
    
    [_levelMapFrame addChild:_star];
    
//    _barrelCountsLabel.visible= false;
    
    level3isAboutDone = false;

    
}



-(void)goForward
{
    if (!goPressed) {
//        [character.animationManager runAnimationsForSequenceNamed:@"pressedAnimation"];
        [_goUpParticle resetSystem];
        [instructionSet addObject:@"goForward"];
    }
    
    if (playerMapLevel == 1)
    {
        
        [self level1TutorialStep3];
    }
    
    if (playerMapLevel == 2) {
        
        if (level2TutorialMoveForwardCounter < 2) {
            level2TutorialMoveForwardCounter++;
            [self level2TutorialStep2];
        }
        else
        {
            [self level2TutorialStep3];
        }
        
    }
    
    if (playerMapLevel == 3 && !level3isAboutDone) {
        
        if (level3TutorialMoveForwardCounter < 1)
        {
            level3TutorialMoveForwardCounter++;
            [self level3TutorialStep2];
        }
        else
        {
            [self level3TutorialStep3];
        }
        
    }
    
    if (playerMapLevel == 3 && level3isAboutDone) {
        [self level3TutorialStep4];
    }
    
}

-(void)turnLeft
{
    if (!goPressed) {
//        [character.animationManager runAnimationsForSequenceNamed:@"pressedAnimation"];
        [_rotateLeftParticle resetSystem];
        
        if (solarDisruption)
        {
            [instructionSet addObject:@"turnRight"];

        }
        
        else
        {
            [instructionSet addObject:@"turnLeft"];
        }
        
    }
    
    if (playerMapLevel == 1)
    {

        [self level1TutorialStep2];
    }
    
    if (playerMapLevel == 2) {
        [self level2TutorialStep2];
    }
    
    if (playerMapLevel == 3) {
        [self level3TutorialStep2];

    }
    
    
}

-(void)turnRight
{
    if (!goPressed)
    {
//        [character.animationManager runAnimationsForSequenceNamed:@"pressedAnimation"];
        [_rotateRightParticle resetSystem];
        
        
        if (solarDisruption)
        {
            [instructionSet addObject:@"turnLeft"];
            
        }
        
        else
        {
            [instructionSet addObject:@"turnRight"];
        }
    }
    
    if (playerMapLevel == 3)
    {
        level3isAboutDone = true;
   
        [self level3TutorialStep2];
    }
}

-(void)go
{
    _instructionArrow.visible = false;

    if (playerMapLevel > 3 && playerMapLevel <= 5 && ([instructionSet count] == 0) && !shownGameTip)
    {
        
        CCNode* _plottingLabel = [CCBReader load:@"InstructionLabel/PlottingLabel" owner:self];
        _plottingLabel.position = ccp([[CCDirector sharedDirector] viewSize].width * 0.5, [[CCDirector sharedDirector] viewSize].height * .8);
        [_tutorialBannerLabel setString:[NSString stringWithFormat:@"Tip:\nPlot a complete course"]];
        _tutorialBannerLabel.scaleX = .65;
        [self addChild:_plottingLabel];
        shownGameTip = true;
    }

    if (!goPressed && [instructionSet count] != 0) {
        [_starParticle resetSystem];

        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);

        if(playerMapLevel > 3)
        {
            if ([[SaveManager sharedManager]getEngineLevel] > 0)
            {
                _acceleration.visible = true;

            }
            
            if (shieldDurability > 0) {
                _shieldButton.visible = true;

            }
            
//            if (weaponSystemLevel > 0) {
//                _fireButton.visible = true;
//
//            }
        }
        
//        _levelLabelText.visible = false;
//        _levelDisplayLabel.visible = false;
        _startEngineButton.visible=false;
        _turnLeftButton.visible = false;
        _rotateLeftButtonAnimation.visible= false;

        _turnRightButton.visible = false;
        _rotateRightButtonAnimation.visible = false;

        _goUpButton.visible = false;
        _moveForwardAnimation.visible = false;

        _clearButton.visible = false;
        _menuButton.visible = false;
        
        _arrow1.visible = false;
        _arrow2.visible = false;
        _arrow3.visible = false;
        
        _clearLabel.visible = false;
        _menuLabel.visible = false;
        
        _hightLightParticleForLeft.visible = false;
        _hightLightParticleForMoveForward.visible = false;
        _hightLightParticleForRight.visible = false;
        
        if (playerMapLevel <= 3)
        {
            
            
            [_tutorialBannerLabel setString:[NSString stringWithFormat:@"Tip:\nPlot a complete course"]];
            _tutorialBannerLabel.scaleX = .65;

        }
        


//        _moveForwardLabel.visible = false;

        
//        _barrelCountsLabel.visible= true;

        _tutorialLabel.visible = false;

        [self executeInstruction];
        goPressed = true;
        
    }



}

-(void)Clear
{
//    starCounts = [[SaveManager sharedManager] getStarCount];
//    barrelCounts = [[SaveManager sharedManager] getBarrelCount];
    
    if (!won && !clearPressed && !goPressed && !isAboutToDemote){
        if (starCounts > 0)
        {
            clearPressed = true;
            starCounts--;
            _starCountsLabel.string = [NSString stringWithFormat:@"%d", starCounts];
            [[SaveManager sharedManager] saveStarCount:starCounts];
            [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"MainScene"]];
            
        }
            
        else
            {

                isAboutToDemote = true;
                playerMapLevel--;
                [[SaveManager sharedManager] savePlayerHighestLevel:playerMapLevel];
                [[SaveManager sharedManager] savePlayerNormalMapLevel:playerMapLevel];
                [[SaveManager sharedManager] resetCurrentPlayingMap];
                
                clearPressed = true;

                [self gameOver];
                

            }
    }
}

    
//    if (!goPressed) {
//        if ((!(won) && (starCounts > 0) && !clearPressed) || (!(won) && playerMapLevel == 1 && !isAboutToDemote && !clearPressed)) {
//            clearPressed = true;
//            
//            if (playerMapLevel != 1) {
//                starCounts--;
//                
//                _starCountsLabel.string = [NSString stringWithFormat:@"%d", starCounts];
//                _barrelCountsLabel.string = [NSString stringWithFormat:@"%d", barrelCounts];
//            }
//
//        }
//        
//        else{
//            if (!(won) && playerMapLevel >1 && !clearPressed)
//            {
//                clearPressed = true;
//                isAboutToDemote = true;
//                playerMapLevel--;
//                [[SaveManager sharedManager] savePlayerNormalMapLevel:playerMapLevel];
//                [[SaveManager sharedManager] resetCurrentPlayingMap];
//                [self gameOver];
//            }
//            
//        }
//

    


-(void)gameOver
{
    _acceleration.visible = false;
    OverPopup* popup = (OverPopup *)[CCBReader load:@"OverPopup"];
    popup.positionType = CCPositionTypeNormalized;
    popup.position = ccp(0.5, 0.5);
    
    [self addChild:popup];
    
}

-(void)checkIfIwon
{
    
    if (CGRectIntersectsRect(character.boundingBox, _endTile.boundingBox) &&
        (instructionCounts == [instructionSet count] - 1) &&
        character.position.x == _endTile.position.x + 16 &&
        character.position.y == _endTile.position.y + 16
        )
    {
        
        CCLOG(@"Player At %f, %f", character.position.x, character.position.y);
        CCLOG(@"Entiled at %f, %f", _endTile.position.x, character.position.y);
        
        won = true;
        _menuButton.visible = true;
        _menuLabel.visible = true;

        _acceleration.visible = false;
        _shieldButton.visible = false;
        _fireButton.visible = false;
        
        
        if ([playerHighScoreRecord count] < playerMapLevel)
        {
            [playerHighScoreRecord insertObject:[NSNumber numberWithFloat:0.0f] atIndex:playerMapLevel-1];
        }
            
            NSNumber* previousHighScoreForCurrentLevel = [playerHighScoreRecord objectAtIndex:playerMapLevel-1];

            CCLOG(@"High Score for Level %d is %f", playerMapLevel, [previousHighScoreForCurrentLevel floatValue]);
            
            if ((100.f - mTimeInSec) > [previousHighScoreForCurrentLevel floatValue])
            {
                NSNumber* newHighScore = [NSNumber numberWithFloat:100.f - mTimeInSec];
                
                CCLOG(@"Adding score : %f to index %d", [newHighScore floatValue], playerMapLevel - 1);
                
                [playerHighScoreRecord removeObjectAtIndex:playerMapLevel-1];
                [playerHighScoreRecord insertObject:newHighScore atIndex:playerMapLevel-1];
                
                CCLOG(@"%.2f", [(NSNumber*)[playerHighScoreRecord objectAtIndex:playerMapLevel-1] floatValue]);
                

                
                [[SaveManager sharedManager] savePlayerHighScoreRecord: [NSArray arrayWithArray:playerHighScoreRecord]];
                
            }
            
            WinPopup *popup = (WinPopup *)[CCBReader load:@"WinPopup" owner:self];
            popup.positionType = CCPositionTypeNormalized;
            popup.position = ccp(0.5, 0.5);
            
            [self addChild:popup];
        
        [_EarnedStarLabel setString:[NSString stringWithFormat:@"+ %d Stars", playerMapLevel*3]];

        
        if(playerMapLevel < MAX_NUMBER_OF_MAPS)
        {
            _finishButton.visible = false;
            
            [_LabelIndicator setString:@"Your Score:"];
            
            
            [_currentScoreLabel setString:[NSString stringWithFormat:@"%d", (int)(100.f - mTimeInSec)]];
            
            if ((100.f - mTimeInSec) > [previousHighScoreForCurrentLevel floatValue])
            {
                //                [_newHighScoreLabel setString:[NSString stringWithFormat:@"Lvl%d High Score: %d", playerMapLevel, (int)(100.f - mTimeInSec)]];
                [_highScoreLabel setString:[NSString stringWithFormat:@"New Best Score: %d", (int)(100.f - mTimeInSec)]];
                
            }
            else{
                [_highScoreLabel setString:[NSString stringWithFormat:@"Best Score: %d", (int)[previousHighScoreForCurrentLevel floatValue]]];
                
            }
            
            [[SaveManager sharedManager] saveStarCount:starCounts];
            //            [[SaveManager sharedManager] saveBarrelCount:barrelCounts];
        
        }

        
        
        if (playerMapLevel == MAX_NUMBER_OF_MAPS)
        {
            
            [MGWU logEvent:@"GameComplete" withParams:nil];

            
            [_LabelIndicator setString:@"Pilot Ranking:"];
            NSInteger sum = 0;
            
            for (NSNumber *num in  playerHighScoreRecord)
            {
                sum += [num intValue];
            }
            
            [_totalHighScoreLabel setString:[NSString stringWithFormat:@"Best Scores Total: %d", sum]];
            
            if (sum <= BRONZE_TIER)
            {
                [_rankLabel setString:[NSString stringWithFormat:@"Bronze Pilot"]];
            }
            
            if (sum > BRONZE_TIER && sum <= SILVER_TIER)
            {
                [_rankLabel setString:[NSString stringWithFormat:@"Silver Pilot"]];
            }
            
            if (sum > SILVER_TIER && sum <= GOLD_TIER)
            {
                [_rankLabel setString:[NSString stringWithFormat:@"Gold Pilot"]];
            }
            
            if (sum > GOLD_TIER && sum <= PLATINUM_TIER)
            {
                [_rankLabel setString:[NSString stringWithFormat:@"Platinum Pilot"]];
            }
            
            if (sum > PLATINUM_TIER && sum <= DIAMOND_TIER)
            {
                [_rankLabel setString:[NSString stringWithFormat:@"Diamond Pilot"]];
            }
            
            if(sum > DIAMOND_TIER)
            {
                [_rankLabel setString:[NSString stringWithFormat:@"Master Pilot"]];

            }
            
            _retryButton.visible = false;
            _nextButton.visible = false;
            _highScoreLabel.visible = false;
            _currentScoreLabel.visible = false;
            _finishButton.visible = true;
            
            CCLOG(@"You complete the game");
        }
    
    }


}

-(void)checkIfILost
{
    if (!(won))
    {
        if ([character isShieldActivated]) {
            return;
        }
        else
        {
            for (CCNode* node in tileNode.children )
            {
            if ((character.position.x == node.position.x + 16 && (((character.position.y == node.position.y + 16 || character.position.y == node.position.y + 32)))))
                        {
                            return;
                        }
            else if((character.position.y == node.position.y + 16 && ((character.position.x == node.position.x + 16 || character.position.x == node.position.x + 32 ))))

                {
                    return;
                }
            
            }
        }
    [self iLost];
    }
}


-(void)checkIfGameFinished
{
    if (instructionCounts == [instructionSet count] - 1)
    {
        CCLOG(@"I am here");
        CCLOG(@"x: %f %f)", character.position.x, _endTile.position.x + 16);
        CCLOG(@"y: %f %f)", character.position.y, _endTile.position.y + 16);


        
        if (character.position.x != (_endTile.position.x + 16) ||
              character.position.y != (_endTile.position.y + 16))
        {
            CCLOG(@"Game never finished");
            goPressed = false;

            [self Clear];
        }
    }
}

-(void)Menu
{
    if (won || (goPressed && isAboutToDemote) || (!goPressed))
    {
        if([instructionSet count] > 0 && !won && starCounts > 0)
        {
            starCounts--;
            [[SaveManager sharedManager] saveStarCount:starCounts];
        }
        
        else if([instructionSet count] > 0 && !won)
        {
            playerMapLevel--;
            [[SaveManager sharedManager] savePlayerHighestLevel:playerMapLevel];
            [[SaveManager sharedManager] savePlayerNormalMapLevel:playerMapLevel];
            [[SaveManager sharedManager] resetCurrentPlayingMap];
        }
        CCScene* sceneAboutToEnter = [CCBReader loadAsScene:@"StartScreen"];
        CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
        [[CCDirector sharedDirector] presentScene:sceneAboutToEnter withTransition:transition];
    }
    
    
    
}

-(void)loadPlayerMapLevel
{
    playerMapLevel = [[SaveManager sharedManager] getPlayerNormalMapLevel];
    playerHighScoreRecord = [[[SaveManager sharedManager]getPlayerHighScoreRecord] mutableCopy];

    
    if (playerMapLevel == 0)
    {
        playerMapLevel++;
        [[SaveManager sharedManager] savePlayerNormalMapLevel:playerMapLevel];
        
        if (playerHighScoreRecord == nil) {
            playerHighScoreRecord = [NSMutableArray array];
            
            for (int i = 0; i <  MAX_NUMBER_OF_MAPS; i++)
            {
                [playerHighScoreRecord insertObject:[NSNumber numberWithFloat:0.0f] atIndex:i];
            }
            
            [[SaveManager sharedManager] savePlayerHighScoreRecord: [NSArray arrayWithArray:playerHighScoreRecord]];
        }


    }
    
    if (playerMapLevel == 11 ||
        playerMapLevel == 19 ||
        playerMapLevel == 20 ||
        playerMapLevel == 30)
    {
        [self switchArrows];
        solarDisruption = true;
    }
    
    
    [_levelDisplayLabel setString:[NSString stringWithFormat:@"%d", playerMapLevel]];
    
    
}

-(void)loadCurrentPlayingMap
{
    currentPlayingMap = [[SaveManager sharedManager] getCurrentPlayingMap];
    
//    if ( playerMapLevel == 11) {
//        solarDisruption = true;
//        
//    }
    
    if (currentPlayingMap == nil)
    {
        CCLOG(@"it is nil");
        randomMapPicker = (arc4random() % MAPS_PER_LEVEL);
        
        CCLOG(@"Loading Map%d-%d", playerMapLevel, randomMapPicker);
        
        currentPlayingMap = [NSString stringWithFormat:@"Map%d-%d", playerMapLevel, randomMapPicker];
        
        [[SaveManager sharedManager] saveCurrentPlayingMap:currentPlayingMap];
    }
}

-(void)loadMapContents
{
    CCScene* _levelMap = [CCBReader loadAsScene:[NSString stringWithFormat:@"Maps/%@", currentPlayingMap] owner:self];
    
//    CCScene* _levelMap = [CCBReader loadAsScene:@"Maps/ChallengerMap1" owner:self];



    
    [_levelMapFrame addChild:_levelMap];
    
    character = (Character*)[CCBReader load:@"Character"];
    character.position = ccp((_startTile.position.x) + 16, _startTile.position.y + 16);
    
    
    [_levelMapFrame addChild:character];
    


    
    CCNode* mapNode = ((CCNode*)[_levelMap.children objectAtIndex:0 ]);
    tileNode = ((CCNode*) [mapNode.children objectAtIndex:0]);
    
    
    [self sortTileX];
    [self sortTileY];

    
    if (playerMapLevel <= 3)
    {
        CCNode* _plottingLabel = [CCBReader load:@"InstructionLabel/PlottingLabel" owner:self];
        _plottingLabel.position = ccp([[CCDirector sharedDirector] viewSize].width * 0.5, [[CCDirector sharedDirector] viewSize].height * .8);
        [self addChild:_plottingLabel];
    }
    
    if (playerMapLevel == 1)
    {
        [self level1TutorialStep1];
    }
    
    if (playerMapLevel == 2)
    {
        level2TutorialMoveForwardCounter = 0;
        [self level2TutorialStep1];

    }
    
    if (playerMapLevel == 3)
    {
        level3TutorialMoveForwardCounter = 0;
        [self level3TutorialStep1];
    }
    
}

-(void)settingUpInstructionSet_And_InstructionCounter
{
    
    instructionSet = [NSMutableArray array];
    
    instructionCounts = 0;
}

-(void)setCharacterDelegateToSelf
{
    character.delegate = self;

}

-(void)setCharacterIsAliveToBeTrue
{
  characterIsAlive = TRUE;
}

//-(void)loadTimerNode
//{
//    timerNode = (Timer*) [CCBReader load:@"Timer" owner:self];
//
//    
//    timerNode.position = ccp(0.5 * [[CCDirector sharedDirector] viewSize].width, 1 * [[CCDirector sharedDirector] viewSize].height);
//
//    
//    [self addChild:timerNode];
//}
//
//-(void)setTimerLabel
//{
//    countDownTimerCheck = playerMapLevel * SECOND_PER_LEVEL +(int) [tileNode.children count] * 5;
//    
//    
//    _timerLabel.string = [NSString stringWithFormat:@"%d",countDownTimerCheck] ;
//    
//
//
//}

//-(void)updateTimer
//{
//    if (!(won) && !isAboutToDemote) {
//        countDownTimerCheck--;
//        _timerLabel.string = [NSString stringWithFormat:@"%d", countDownTimerCheck] ;
//        
//        if (countDownTimerCheck == 0)
//        {
//            [self unschedule:@selector(updateTimer)];
//            [self iLost];
//        }
//    }
//    
//    else
//    {
//        [self unschedule:@selector(updateTimer)];
//    }
//
//    
//}

//-(void)checkTimer
//{
//    [self schedule:@selector(updateTimer) interval:1.0];
//
//}

-(void)iLost
{
    goPressed = false;
    
    characterIsAlive = FALSE;
    
    character.visible = FALSE;
    
    
    Explosion* characterExplosion = [Explosion explosion];
    [character.parent addChild:characterExplosion];
    characterExplosion.position = character.position;
    
    CCActionSequence* resetSequence = [CCActionSequence
                                       actions:
                                       [CCActionDelay actionWithDuration:characterExplosion.duration * 2],
                                       [CCActionCallBlock
                                        actionWithBlock:^{
                                            [self Clear];
                                        }],
                                       nil];
    
    [self runAction:resetSequence];
}


-(void)checkForStar
{
    if (CGRectIntersectsRect(character.boundingBox, _star.boundingBox) && !_star.isChecked)
    {
        _star.isChecked = true;
        starCounts = 3 * playerMapLevel + starCounts;
        _starCountsLabel.string = [NSString stringWithFormat:@"%d", starCounts];
        
//        [[SaveManager sharedManager] saveStarCount:starCounts];
        _star.visible = false;
        [_star removeFromParent];
        
    }
}

//-(void)checkForBarrel
//{
//    if (CGRectIntersectsRect(character.boundingBox, _barrel.boundingBox) && !_barrel.isChecked)
//    {
//        _barrel.isChecked = true;
//        barrelCounts++;
//        _barrelCountsLabel.string = [NSString stringWithFormat:@"%d", barrelCounts];
//        
////        [[SaveManager sharedManager] saveBarrelCount:barrelCounts];
//        _barrel.visible = false;
//        [_barrel removeFromParent];
//        
//    }
//}

-(void)checkForPortal
{
    if (CGRectIntersectsRect(character.boundingBox, _portal1Start.boundingBox)
        && _portal1Start.position.x + 16 == character.position.x
        && _portal1Start.position.y + 16 == character.position.y)
    {
        
//        [character stopTailParticleWhenEnterPortal];

        character.position = ccp(_portal1End.position.x+16, _portal1End.position.y+16);
    }
    
    if (CGRectIntersectsRect(character.boundingBox, _portal2Start.boundingBox)
        && _portal2Start.position.x + 16 == character.position.x
        && _portal2Start.position.y + 16 == character.position.y
        )
    {
//        [character stopTailParticleWhenEnterPortal];

        character.position = ccp(_portal2End.position.x+16, _portal2End.position.y+16);
    }
    
    if (CGRectIntersectsRect(character.boundingBox, _portal3Start.boundingBox)
        && _portal3Start.position.x + 16 == character.position.x
        && _portal3Start.position.y + 16 == character.position.y
        )
    {
//        [character stopTailParticleWhenEnterPortal];
        character.position = ccp(_portal3End.position.x+16, _portal3End.position.y+16);
        
    }
    
    if (CGRectIntersectsRect(character.boundingBox, _portal4Start.boundingBox)
        && _portal4Start.position.x + 16 == character.position.x
        && _portal4Start.position.y + 16 == character.position.y
        )
    {
        //        [character stopTailParticleWhenEnterPortal];
        character.position = ccp(_portal4End.position.x+16, _portal4End.position.y+16);
        
    }
    
    if (CGRectIntersectsRect(character.boundingBox, _portal5Start.boundingBox)
        && _portal5Start.position.x + 16 == character.position.x
        && _portal5Start.position.y + 16 == character.position.y
        )
    {
        //        [character stopTailParticleWhenEnterPortal];
        character.position = ccp(_portal5End.position.x+16, _portal5End.position.y+16);
        
    }
//
//    if (CGRectIntersectsRect(character.boundingBox, _portal4Start.boundingBox))
//    {
//        character.position = ccp(_portal4End.position.x+16, _portal4End.position.y+16);
//        
//    }
}

-(void)checkForBlackHole
{
    if (CGRectIntersectsRect(character.boundingBox, _blackHole1.boundingBox) ||
        CGRectIntersectsRect(character.boundingBox, _blackHole2.boundingBox) ||
        CGRectIntersectsRect(character.boundingBox, _blackHole3.boundingBox) ||
        CGRectIntersectsRect(character.boundingBox, _blackHole4.boundingBox) ||
        CGRectIntersectsRect(character.boundingBox, _blackHole5.boundingBox) )
    {
        CCLOG(@"On a blackHole");
        [[SaveManager sharedManager]saveIsSucking:true];
    }
    
    else
    {
        [[SaveManager sharedManager]resetIsSucking];
    }
    
    
}


-(void)executeInstruction
{
    if ([instructionSet count] != 0 && !(won)) {
        if ([instructionSet[instructionCounts] isEqualToString:@"goForward"])
        {
            [character move];
            CCLOG(@"%f %f", character.position.x, character.position.y);

        }
        
        if ([instructionSet[instructionCounts] isEqualToString:@"turnRight"])
        {
            [character rotateRight];
            CCLOG(@"%f %f", character.position.x, character.position.y);

        }
        
        if ([instructionSet[instructionCounts] isEqualToString:@"turnLeft"])
        {
            [character rotateLeft];
            CCLOG(@"%f %f", character.position.x, character.position.y);

        }
    }
}

-(void)accelerate
{

    if (starCounts >= ([[SaveManager sharedManager]getEngineLevel] * 10) && !character.accelerationModeEnabled && !(won) && !isAboutToDemote && goPressed)
    {

        starCounts = starCounts - [[SaveManager sharedManager]getEngineLevel] * 10;
        _starCountsLabel.string = [NSString stringWithFormat:@"%d", starCounts];
        
        [[SaveManager sharedManager] saveStarCount:starCounts];
        character.accelerationModeEnabled = true;
        [character speedUp];
        _acceleration.visible = false;
    }
}

-(void)sortTileX
{
    for (CCNode* node in tileNode.children )
    {
        BOOL rePlacedTile = false;

        for (int i = 32; i < 320 && !rePlacedTile; i=i+32)
        {
            if (abs((int)node.position.x - i) < 10)
            {
                node.position = ccp((float)i, node.position.y);

                rePlacedTile = true;
            }

        }
        
    }
    
}

-(void)sortTileY
{
    CCLOG(@"sorting y");

    for (CCNode* node in tileNode.children )
    {
        BOOL rePlacedTile = false;
        
        for (int i = 32; i < 384 && !rePlacedTile; i=i+32)
        {
            if (abs((int)node.position.y - i) < 10)
            {
                node.position = ccp(node.position.x, (float)i);
                rePlacedTile = true;
            }

            
        }
        
    }
    
}

-(void)level1TutorialStep1
{
    
    _hightLightParticleForMoveForward.visible = false;
    _hightLightParticleForRight.visible = false;
    
    _startEngineButton.visible=false;
//    _turnLeftButton.visible = false;
    _turnRightButton.visible = false;
    _rotateRightButtonAnimation.visible = false;

    _goUpButton.visible = false;
    _moveForwardAnimation.visible = false;

    _clearButton.visible = false;
    _clearLabel.visible = false;
    _menuButton.visible = false;
    _menuLabel.visible = false;

//    _arrow1.visible = false;
    _arrow3.visible = false;
    _arrow2.visible = false;
//    _moveForwardLabel.visible = false;
    
//    _tutorialLabel = [CCBReader load:@"InstructionLabel/RotateLeftIns"];
//    [_tutorialLabel setAnchorPoint:ccp(0.5, 0.5)];
    [_tutorialBannerLabel setString:[NSString stringWithFormat:@"tap\n[Rotate Left]\nbutton"]];
    
    _instructionArrow.positionType = CCPositionTypeNormalized;
    _instructionArrow.position = ccp(0.15, _instructionArrow.position.y);
    
//    _tutorialLabel.position = ccp(_turnLeftButton.position.x * 320, _turnLeftButton.position.y * 384 + 128);
//    [self addChild:_tutorialLabel];
}

-(void)level1TutorialStep2
{

    _turnLeftButton.visible = false;
    _rotateLeftButtonAnimation.visible= false;

    _arrow1.visible = false;
    
    _hightLightParticleForMoveForward.visible = true;
    _hightLightParticleForLeft.visible = false;
    
    _goUpButton.visible = true;
    _moveForwardAnimation.visible = true;

    _moveForwardAnimation.visible = true;

    _arrow2.visible = true;

//    _moveForwardLabel.visible = true;

    
//    [_tutorialLabel removeFromParent];
//    _tutorialLabel = [CCBReader load:@"InstructionLabel/MoveForwardIns"];
    [_tutorialBannerLabel setString:[NSString stringWithFormat:@"tap\n[Forward 1]\nbutton"]];
    _instructionArrow.positionType = CCPositionTypeNormalized;
    _instructionArrow.position = ccp(0.5, _instructionArrow.position.y);
    
//    _tutorialLabel.position = ccp(_goUpButton.position.x * 320, _goUpButton.position.y * 384 + 128);
//    [self addChild:_tutorialLabel];
    
}
-(void)level1TutorialStep3
{
    _goUpButton.visible = false;
    _moveForwardAnimation.visible = false;
    _arrow2.visible = false;
    
    _hightLightParticleForMoveForward.visible = false;
    
//    _moveForwardLabel.visible = false;
    
    _startEngineButton.visible = true;
//    [_tutorialLabel removeFromParent];
//    _tutorialLabel = [CCBReader load:@"InstructionLabel/StartIns"];
    [_tutorialBannerLabel setString:[NSString stringWithFormat:@"tap\n[Start Engine]\nbutton"]];
    
    _instructionArrow.positionType = CCPositionTypeNormalized;
    _instructionArrow.position = ccp(0.5, _instructionArrow.position.y+0.1);


//    _tutorialLabel.position = ccp(_startEngineButton.position.x * 320, _startEngineButton.position.y * 384 + 110);
//    [self addChild:_tutorialLabel];
}

-(void)level2TutorialStep1
{
    _hightLightParticleForMoveForward.visible = false;
    _hightLightParticleForRight.visible = false;
    
    _startEngineButton.visible=false;
    //    _turnLeftButton.visible = false;
    _turnRightButton.visible = false;
    _rotateRightButtonAnimation.visible = false;
    
    _goUpButton.visible = false;
    _moveForwardAnimation.visible = false;

    _clearButton.visible = false;
    _clearLabel.visible = false;
    _menuButton.visible = false;
    _menuLabel.visible = false;
    
    //    _arrow1.visible = false;
    _arrow3.visible = false;
    _arrow2.visible = false;
    //    _moveForwardLabel.visible = false;
    
//    _tutorialLabel = [CCBReader load:@"InstructionLabel/RotateLeftIns"];
    [_tutorialBannerLabel setString:[NSString stringWithFormat:@"tap\n[Rotate Left]\nbutton"]];
    _instructionArrow.positionType = CCPositionTypeNormalized;
    _instructionArrow.position = ccp(0.15, _instructionArrow.position.y);

//    [_tutorialLabel setAnchorPoint:ccp(0.5, 0.5)];
    
//    _tutorialLabel.position = ccp(_turnLeftButton.position.x * 320, _turnLeftButton.position.y * 384 + 128);
//    [self addChild:_tutorialLabel];
    
}
-(void)level2TutorialStep2
{
    
    _turnLeftButton.visible = false;
    _rotateLeftButtonAnimation.visible= false;

    _arrow1.visible = false;
    
    _hightLightParticleForMoveForward.visible = true;
    _hightLightParticleForLeft.visible = false;
    
    _goUpButton.visible = true;
    _moveForwardAnimation.visible = true;

    _arrow2.visible = true;
    
    //    _moveForwardLabel.visible = true;
    
    
//    [_tutorialLabel removeFromParent];
//    _tutorialLabel = [CCBReader load:@"InstructionLabel/MoveForwardIns"];
    [_tutorialBannerLabel setString:[NSString stringWithFormat:@"tap\n[Forward 1]\nbutton"]];
    _instructionArrow.positionType = CCPositionTypeNormalized;
    _instructionArrow.position = ccp(0.5, _instructionArrow.position.y);

//    _tutorialLabel.position = ccp(_goUpButton.position.x * 320, _goUpButton.position.y * 384 + 128);
//    [self addChild:_tutorialLabel];
    
}

-(void)level2TutorialStep3
{
    _goUpButton.visible = false;
    _moveForwardAnimation.visible = false;

    _arrow2.visible = false;
    
    _hightLightParticleForMoveForward.visible = false;
    
    //    _moveForwardLabel.visible = false;
    
    _startEngineButton.visible = true;
//    [_tutorialLabel removeFromParent];
//    _tutorialLabel = [CCBReader load:@"InstructionLabel/StartIns"];
    [_tutorialBannerLabel setString:[NSString stringWithFormat:@"tap\n[Start Engine]\nbutton"]];
    _instructionArrow.positionType = CCPositionTypeNormalized;
    _instructionArrow.position = ccp(0.5, _instructionArrow.position.y+0.1);

//    _tutorialLabel.position = ccp(_startEngineButton.position.x * 320, _startEngineButton.position.y * 384 + 110);
//    [self addChild:_tutorialLabel];

    
}

-(void)level3TutorialStep1
{
    _hightLightParticleForMoveForward.visible = false;
    _hightLightParticleForRight.visible = false;
    
    _startEngineButton.visible=false;
    //    _turnLeftButton.visible = false;
    _turnRightButton.visible = false;
    _rotateRightButtonAnimation.visible = false;

    
    _goUpButton.visible = false;
    _moveForwardAnimation.visible = false;

    _clearButton.visible = false;
    _clearLabel.visible = false;
    _menuButton.visible = false;
    _menuLabel.visible = false;
    
    //    _arrow1.visible = false;
    _arrow3.visible = false;
    _arrow2.visible = false;
    //    _moveForwardLabel.visible = false;
    
//    _tutorialLabel = [CCBReader load:@"InstructionLabel/RotateLeftIns"];
    [_tutorialBannerLabel setString:[NSString stringWithFormat:@"tap\n[Rotate Left]\nbutton"]];
    _instructionArrow.positionType = CCPositionTypeNormalized;
    _instructionArrow.position = ccp(0.15, _instructionArrow.position.y);

//    [_tutorialLabel setAnchorPoint:ccp(0.5, 0.5)];
//    
//    _tutorialLabel.position = ccp(_turnLeftButton.position.x * 320, _turnLeftButton.position.y * 384 + 128);
//    [self addChild:_tutorialLabel];
    
}
-(void)level3TutorialStep2
{
    if (level3isAboutDone)
    {
        _hightLightParticleForRight.visible = false;
        _arrow3.visible = false;
        _turnRightButton.visible = false;
        _rotateRightButtonAnimation.visible = false;

    }
    _turnLeftButton.visible = false;
    _rotateLeftButtonAnimation.visible= false;
    _arrow1.visible = false;
    _hightLightParticleForLeft.visible = false;
    

    _hightLightParticleForMoveForward.visible = true;
    _goUpButton.visible = true;
    _moveForwardAnimation.visible = true;

    _moveForwardAnimation.visible = true;
    _arrow2.visible = true;
    
    //    _moveForwardLabel.visible = true;
    
    
//    [_tutorialLabel removeFromParent];
//    _tutorialLabel = [CCBReader load:@"InstructionLabel/MoveForwardIns"];
    [_tutorialBannerLabel setString:[NSString stringWithFormat:@"tap\n[Forward 1]\nbutton"]];
    _instructionArrow.positionType = CCPositionTypeNormalized;
    _instructionArrow.position = ccp(0.5, _instructionArrow.position.y);

//    _tutorialLabel.position = ccp(_goUpButton.position.x * 320, _goUpButton.position.y * 384 + 128);
//    [self addChild:_tutorialLabel];
    
}
-(void)level3TutorialStep3
{
    _goUpButton.visible = false;
    _moveForwardAnimation.visible = false;

    _arrow2.visible = false;
    _hightLightParticleForMoveForward.visible = false;

    
    _hightLightParticleForRight.visible = true;
    _arrow3.visible = true;
    _turnRightButton.visible = true;
    _rotateRightButtonAnimation.visible = true;
    
    
    //    _moveForwardLabel.visible = true;
    
    
//    [_tutorialLabel removeFromParent];
//    _tutorialLabel = [CCBReader load:@"InstructionLabel/RotateRightIns"];
    [_tutorialBannerLabel setString:[NSString stringWithFormat:@"tap\n[Rotate Right]\nbutton"]];
    _instructionArrow.positionType = CCPositionTypeNormalized;
    _instructionArrow.position = ccp(0.85, _instructionArrow.position.y);

//    _tutorialLabel.position = ccp(_turnRightButton.position.x * 320, _turnRightButton.position.y * 384 + 128);
//    [self addChild:_tutorialLabel];
    
}
-(void)level3TutorialStep4
{
    _goUpButton.visible = false;
    _moveForwardAnimation.visible = false;

    _arrow2.visible = false;
    _hightLightParticleForMoveForward.visible = false;
    

    
    _startEngineButton.visible = true;
//    [_tutorialLabel removeFromParent];
//    _tutorialLabel = [CCBReader load:@"InstructionLabel/StartIns"];
    [_tutorialBannerLabel setString:[NSString stringWithFormat:@"tap\n[Start Engine]\nbutton"]];
    _instructionArrow.positionType = CCPositionTypeNormalized;
    _instructionArrow.position = ccp(0.5, _instructionArrow.position.y+0.1);

//    _tutorialLabel.position = ccp(_startEngineButton.position.x * 320, _startEngineButton.position.y * 384 + 110);
//    [self addChild:_tutorialLabel];

    
}

-(void)tick:(CCTime)dt
{
    if(won || isAboutToDemote)
        return;
    
    mTimeInSec +=dt;
    
    
    float digit_min = mTimeInSec/60.0f;
    float digit_sec =((int) mTimeInSec%60);
    
    
    int min = (int)digit_min;
    int sec = (int)digit_sec;
    
    
    [_timerLabel setString:[NSString stringWithFormat:@"%.2d:%.2d", min,sec]];
    
}

-(void)activateShield
{
    if ((starCounts >= ([[SaveManager sharedManager]getshieldDurability] * 10) && !(won) && !isAboutToDemote && goPressed))
    {
        starCounts = starCounts - shieldDurability * 10;
        _starCountsLabel.string = [NSString stringWithFormat:@"%d", starCounts];
        [character activateShield];
        _shieldButton.visible = false;
    }


}

-(void)fire
{
    WeaponSystem* _shipWeapon = (WeaponSystem*)[CCBReader load:@"Weapon01"];

    [_levelMapFrame addChild:_shipWeapon];
    
    _shipWeapon.position = character.position;
    CCLOG(@"Character at: %f %f\nWeapon at %f %f", character.position.x, character.position.y, _shipWeapon.position.x, _shipWeapon.position.y);
    
    _shipWeapon.rotation = character.characterSprite.rotation;
//    _weaponTailParticle.angle = _shipWeapon.rotation - 180.f;

    CGPoint postionDifference = ccp(cosf((360 - _shipWeapon.rotation) * 3.14 / 180)*32*weaponSystemLevel,
                                    sinf((360 - _shipWeapon.rotation) * 3.14 / 180)*32*weaponSystemLevel);
    
    
//    CGPoint postionDifference = ccp(0, 64);
    CCActionMoveTo* move = [CCActionMoveTo actionWithDuration:(0.8 - 0.05f * weaponSystemLevel) / 4
                                                     position:(ccpAdd(character.position, postionDifference))];
    
    [_shipWeapon runAction:move];

}

-(void)switchArrows
{
    _arrow1.positionType = CCPositionTypeNormalized;
    _arrow3.positionType = CCPositionTypeNormalized;

    _arrow1.position = ccp(0.85, 0.09);
    _arrow3.position = ccp(0.15, 0.09);
}
@end
