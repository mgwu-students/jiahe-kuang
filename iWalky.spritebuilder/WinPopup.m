//
//  WinPopup.m
//  iWalky
//
//  Created by Jiahe Kuang on 7/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "WinPopup.h"

@implementation WinPopup

- (void)loadNextLevel {
    
    CCScene *nextLevel = [CCBReader loadAsScene:@"MainScene"];
    
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:nextLevel withTransition:transition];
}

@end
