//
//  Character.m
//  iWalky
//
//  Created by Jiahe Kuang on 6/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TailParticle.h"
#import "Character.h"
#import "SaveManager.h"


typedef enum{
    
    kDirectionUp = 0,
    kDirectionDown = 1,
    kDirectionLeft = 2,
    kDirectionRight = 3
}Direction;

@implementation Character
{
    TailParticle* _tailParticle;
    CCSprite* _characterSprite;

}


-(void) didLoadFromCCB
{
    
    _characterSprite.rotation = (arc4random() % 4) * 90;
    
    _tailParticle.angle = _characterSprite.rotation - 180.f;

    _tailParticle.particlePositionType = CCParticleSystemPositionTypeFree;
    
    _tailParticle.paused = true;
    
    _animationDuration = 1.0f;
    
    _accelerationModeEnabled = false;
    
}

-(void)rotateLeft
{
    
    
    CCActionRotateBy* rotateLeft = [CCActionRotateBy actionWithDuration:_animationDuration angle:-90];
    
    _tailParticle.paused = false;
    
    CCActionCallBlock* callBack = [CCActionCallBlock actionWithBlock:^{
        [self animationFinished];
    }];
    
    CCActionSequence* actionSequence = [CCActionSequence actionOne:(CCActionFiniteTime*)rotateLeft two:(callBack)];
    [_characterSprite runAction:actionSequence];
}



-(void)rotateRight
{
    CCActionRotateBy* rotateRight = [CCActionRotateBy actionWithDuration:_animationDuration angle:90];
    
    _tailParticle.paused = false;
    CCActionCallBlock* callBack = [CCActionCallBlock actionWithBlock:^{
        [self animationFinished];
    }];
    
    CCActionSequence* actionSequence = [CCActionSequence actionOne:(CCActionFiniteTime*)rotateRight two:(callBack)];

    [_characterSprite runAction:actionSequence];
}

-(void)move
{
    CGPoint postionDifference = ccp(0.f, 0.f);
    
    Direction direction = [self getOrientation];
    
    switch (direction) {
        case kDirectionUp:
            postionDifference = ccp(0, 32);
            break;
            
        case kDirectionDown:
            postionDifference = ccp(0, -32);
            break;
            
        case kDirectionLeft:
            postionDifference = ccp(-32, 0);
            break;
            
        case kDirectionRight:
            postionDifference = ccp(32, 0);
            break;
            
        default:
            break;
    }
    
    
    CCActionMoveTo* move = [CCActionMoveTo actionWithDuration:_animationDuration position:(ccpAdd(self.position, postionDifference))];
    
    if (_accelerationModeEnabled) {
        [_tailParticle removeFromParent];
        _tailParticle.startSize = 13.0f;
        _tailParticle.endSize  = 7.0f;
        
        [self addChild:_tailParticle];
        _tailParticle.zOrder = _characterSprite.zOrder - 1;
    }
        _tailParticle.paused = false;

    
    
    CCActionCallBlock* callBack = [CCActionCallBlock actionWithBlock:^{
        [self animationFinished];
    }];
    
    CCActionSequence* actionSequence = [CCActionSequence actionOne:(CCActionFiniteTime*)move two:(callBack)];

    
    [self runAction: actionSequence];
    
    
}

-(void)update:(CCTime)delta
{
    _tailParticle.angle = _characterSprite.rotation - 180.f;
}

-(Direction)getOrientation
{
    float normalizedRotation = fmod(_characterSprite.rotation, 360.0f);
    
    if (normalizedRotation < 0.0f) {
        normalizedRotation += 360.f;
    }
    
    if (normalizedRotation < 0.1f && normalizedRotation > -.1f)
    {
        return kDirectionRight;
    }
    
    if (normalizedRotation < 270.1f && normalizedRotation > 269.9f)
    {
        return kDirectionUp;
    }
    
    if (normalizedRotation < 90.1f && normalizedRotation > 89.9f)
    {
        return kDirectionDown;
    }
    
    if (normalizedRotation < 180.1&& normalizedRotation >179.9f)
    {
        return kDirectionLeft;
    }
    
    return -1;
}

-(void)animationFinished
{
    [self.delegate actionFinished];
}

@end
