//
//  OverPopup.m
//  iWalky
//
//  Created by Jiahe Kuang on 7/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "OverPopup.h"

@implementation OverPopup

- (void)goBackToMenu {
    
    CCScene *nextLevel = [CCBReader loadAsScene:@"MainScene"];
    
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:nextLevel withTransition:transition];
}

@end
