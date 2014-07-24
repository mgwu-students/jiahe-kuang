//
//  LevelScreen.m
//  iWalky
//
//  Created by Jiahe Kuang on 7/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelScreen.h"

@implementation LevelScreen
{
    CCScrollView* _maps;
}


-(void)Menu
{
    CCScene* sceneAboutToEnter = [CCBReader loadAsScene:@"StartScreen"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:sceneAboutToEnter withTransition:transition];
}
    


@end
