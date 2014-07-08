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


static int MAPS_PER_LEVEL = 2;
static int MAX_NUMBER_OF_MAPS = 10;
static int SECOND_PER_LEVEL = 5;

@implementation MainScene
{
    NSMutableArray* instructionSet;
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
    CCTimer* countDownTimer;
    Timer* timerNode;
    int countDownTimerCheck;
    
    CCLabelTTF* _starCountsLabel;
    CCLabelTTF* _barrelCountsLabel;
    
    int starCounts;
    int barrelCounts;
    
    Star* _star;
    Barrel* _barrel;
    
    BOOL won;
    
    BOOL goPressed;
    
    BOOL isAboutToDemote;
    
    BOOL clearPressed;
    
    

    
    
    
}


-(void)actionFinished
{

    [self checkIfILost];
    
    if (characterIsAlive)
    {
        [self checkForBarrel];
        [self checkForStar];
        
        [self checkIfIwon];
        
        [self checkIfGameFinished];
    }
    
    
    if(instructionCounts < ([instructionSet count] -1))
    {
        instructionCounts++;
        [self executeInstruction];
    }
    
    
    
}

- (void)didLoadFromCCB
{
    
    
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
    
    if (playerMapLevel > 10) {
        [self loadTimerNode];
        
        [self setTimerLabel];
        
        [self checkTimer];
    }

    
    starCounts = [[SaveManager sharedManager] getStarCount];
    barrelCounts = [[SaveManager sharedManager] getBarrelCount];
    
   _starCountsLabel.string = [NSString stringWithFormat:@"%d", starCounts];
   _barrelCountsLabel.string = [NSString stringWithFormat:@"%d", barrelCounts];
    
    isAboutToDemote = false;
    
    
    

    
}

-(void)goForward
{
    if (!goPressed) {
        [instructionSet addObject:@"goForward"];
    }
}

-(void)turnLeft
{
    if (!goPressed) {
        [instructionSet addObject:@"turnLeft"];

    }
}

-(void)turnRight
{
    if (!goPressed) {
        [instructionSet addObject:@"turnRight"];
    }
}

-(void)go
{
    if (!goPressed && [instructionSet count] != 0) {
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
    OverPopup* popup = (OverPopup *)[CCBReader load:@"OverPopup"];
    popup.positionType = CCPositionTypeNormalized;
    popup.position = ccp(0.5, 0.5);
    
    [self addChild:popup];
    
}

-(void)checkIfIwon
{

    
    if (CGRectIntersectsRect(character.boundingBox, _endTile.boundingBox) && (instructionCounts == [instructionSet count] - 1))
    {
        if (playerMapLevel < MAX_NUMBER_OF_MAPS) {
            won = true;
            playerMapLevel++;
            
            [[SaveManager sharedManager] savePlayerNormalMapLevel:playerMapLevel];
            [[SaveManager sharedManager] resetCurrentPlayingMap];
            [[SaveManager sharedManager] saveStarCount:starCounts];
            [[SaveManager sharedManager] saveBarrelCount:barrelCounts];
            
            WinPopup *popup = (WinPopup *)[CCBReader load:@"WinPopup"];
            popup.positionType = CCPositionTypeNormalized;
            popup.position = ccp(0.5, 0.5);
            
            [self addChild:popup];
        }
        
        else
        {
            won = true;
            CCLOG(@"You have passed the game");
            [self Menu];
        }
        
    }

}

-(void)checkIfILost
{
    if (!(won))
    {
        for (CCNode* node in tileNode.children )
        {
            if ((CGRectIntersectsRect(character.boundingBox, node.boundingBox)))
            {
                return;
                
            }
            
        }
//        
//        characterIsAlive = FALSE;
//        
//        character.visible = FALSE;
//
//
//        
//        
//        Explosion* characterExplosion = [Explosion explosion];
//        [character.parent addChild:characterExplosion];
//        characterExplosion.position = character.position;
//        
//        CCActionSequence* resetSequence = [CCActionSequence
//                                           actions:
//                                           [CCActionDelay actionWithDuration:characterExplosion.duration * 2],
//                                           [CCActionCallBlock
//                                            actionWithBlock:^{
//                                                [self Clear];
//                                            }],
//                                           nil];
//        
//        [self runAction:resetSequence];
        
        [self iLost];
        
    }
    
    
}

-(void)checkIfGameFinished
{
    if (instructionCounts == [instructionSet count] - 1)
    {
        if (!CGRectIntersectsRect(character.boundingBox, _endTile.boundingBox))
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
        
        CCScene* sceneAboutToEnter = [CCBReader loadAsScene:@"StartScreen"];
        CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
        [[CCDirector sharedDirector] presentScene:sceneAboutToEnter withTransition:transition];
    }
    
    
    
}

-(void)loadPlayerMapLevel
{
    playerMapLevel = [[SaveManager sharedManager] getPlayerNormalMapLevel];
    
    if (playerMapLevel == 0)
    {
        playerMapLevel++;
    }
    
}

-(void)loadCurrentPlayingMap
{
    currentPlayingMap = [[SaveManager sharedManager] getCurrentPlayingMap];
    
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

-(void)loadTimerNode
{
    timerNode = (Timer*) [CCBReader load:@"Timer" owner:self];
    timerNode.positionType = CCPositionTypeNormalized;
    timerNode.position = ccp(0, 0);
    
    [self addChild:timerNode];
}

-(void)setTimerLabel
{
    countDownTimerCheck = playerMapLevel * SECOND_PER_LEVEL + [tileNode.children count] * 5;
    
    
    _timerLabel.string = [NSString stringWithFormat:@"%d",countDownTimerCheck] ;
    


}

-(void)updateTimer
{
    if (!(won)) {
        countDownTimerCheck--;
        _timerLabel.string = [NSString stringWithFormat:@"%d", countDownTimerCheck] ;
        
        if (countDownTimerCheck == 0)
        {
            [self unschedule:@selector(updateTimer)];
            [self iLost];
        }
    }
    
    else
    {
        [self unschedule:@selector(updateTimer)];
    }

    
}

-(void)checkTimer
{
    [self schedule:@selector(updateTimer) interval:1.0];

}

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
        starCounts++;
        _starCountsLabel.string = [NSString stringWithFormat:@"%d", starCounts];
        
//        [[SaveManager sharedManager] saveStarCount:starCounts];
        _star.visible = false;
        [_star removeFromParent];
        
    }
}

-(void)checkForBarrel
{
    if (CGRectIntersectsRect(character.boundingBox, _barrel.boundingBox) && !_barrel.isChecked)
    {
        _barrel.isChecked = true;
        barrelCounts++;
        _barrelCountsLabel.string = [NSString stringWithFormat:@"%d", barrelCounts];
        
//        [[SaveManager sharedManager] saveBarrelCount:barrelCounts];
        _barrel.visible = false;
        [_barrel removeFromParent];
        
    }
}

-(void)executeInstruction
{
    if ([instructionSet count] != 0 && !(won)) {
        if ([instructionSet[instructionCounts] isEqualToString:@"goForward"])
        {
            [character move];
        }
        
        if ([instructionSet[instructionCounts] isEqualToString:@"turnRight"])
        {
            [character rotateRight];
        }
        
        if ([instructionSet[instructionCounts] isEqualToString:@"turnLeft"])
        {
            [character rotateLeft];
        }
    }
}

-(void)accelerate
{

    if (barrelCounts >= 1 && !character.accelerationModeEnabled && !(won) && !isAboutToDemote && goPressed)
    {

        barrelCounts--;
        _barrelCountsLabel.string = [NSString stringWithFormat:@"%d", barrelCounts];
        
        [[SaveManager sharedManager] saveBarrelCount:barrelCounts];
        
        character.accelerationModeEnabled = true;
        character.animationDuration = 0.5;
    }
}

@end
