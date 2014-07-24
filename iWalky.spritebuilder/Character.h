//
//  Character.h
//  iWalky
//
//  Created by Jiahe Kuang on 6/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@protocol CharacterDelegate <NSObject>

-(void) actionFinished;

@end


@interface Character : CCNode

@property (nonatomic, weak) NSObject <CharacterDelegate>* delegate;
@property (nonatomic, assign)float animationDuration;
@property (nonatomic, assign)BOOL accelerationModeEnabled;




-(void)move;

-(void)rotateLeft;
-(void)rotateRight;
-(void)speedUp;
-(void)activateShield;
-(BOOL)isShieldActivated;
//-(void)stopTailParticleWhenEnterPortal;

@end
