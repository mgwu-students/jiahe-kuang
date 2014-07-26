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
    kDirectionRight = 3,
    
    kDirection45UpRight = 4,
    kDirection45UpLeft = 5,
    kDirection45DownRight = 6,
    kDirection45DownLeft = 7
}Direction;

@implementation Character
{


    CCSprite* _characterSprite;
    
    TailParticle* _tailParticle;
    
    CCParticleSystem* _shieldParticle;
    
    
    BOOL _tailIsRemoved;
    
    int rotationAngel;
    int movingPixel;

    int isOnTopOfABlackHole;
    
    int engineLevel;
    int shieldDurability;
    BOOL shieldActivated;
//    BOOL shieldDepleted;
    int energyExtractorEfficiency;
    
    int shieldTimer;
}


-(void) didLoadFromCCB
{
    shieldActivated = false;
//    shieldDepleted = true;
    engineLevel = [[SaveManager sharedManager] getEngineLevel];
    shieldDurability = [[SaveManager sharedManager] getshieldDurability];
    
    shieldTimer = shieldDurability * 60;
    
    if (engineLevel == 0) {
        _animationDuration = .8f;
    }
    
    else
    {
        _animationDuration = 0.8f - 0.05f * engineLevel;
    }
    
    CCLOG(@"speed at %.3f", _animationDuration);
    
    [[SaveManager sharedManager]resetIsSucking];
    rotationAngel = 90;
    movingPixel = 32;
    
    
    _characterSprite.rotation = 270.0f;

    if ([[SaveManager sharedManager]getPlayerNormalMapLevel] < 4)
    {
        _characterSprite.rotation = 0.0f;

    }
    
    [_shieldParticle stopSystem];
    
    _tailParticle.angle = _characterSprite.rotation - 180.f;


    _tailParticle.particlePositionType = CCParticleSystemPositionTypeFree;


    
    _tailParticle.paused = true;

    
    
    _accelerationModeEnabled = false;
    
    _tailIsRemoved = false;
    
}

-(void)rotateLeft
{
    if ([[SaveManager sharedManager] getIsSucking])
    {
        rotationAngel = 45;
    }
    
    else
    {
        rotationAngel = 90;

    }
    
    CCActionRotateBy* rotateLeft = [CCActionRotateBy actionWithDuration:_animationDuration angle:-rotationAngel];
    
    _tailParticle.paused = false;

    
    CCActionCallBlock* callBack = [CCActionCallBlock actionWithBlock:^{
        [self animationFinished];
    }];
    
    CCActionSequence* actionSequence = [CCActionSequence actionOne:(CCActionFiniteTime*)rotateLeft two:(callBack)];
//    [self.animationManager runAnimationsForSequenceNamed:@"pressedAnimation"];
    [_characterSprite runAction:actionSequence];
}



-(void)rotateRight
{
    if ([[SaveManager sharedManager] getIsSucking])
    {
        rotationAngel = 45;

    }
    
    else
    {
        rotationAngel = 90;
        
    }
    
    CCActionRotateBy* rotateRight = [CCActionRotateBy actionWithDuration:_animationDuration angle:rotationAngel];
    
    _tailParticle.paused = false;

    
    CCActionCallBlock* callBack = [CCActionCallBlock actionWithBlock:^{
        [self animationFinished];
    }];
    
    CCActionSequence* actionSequence = [CCActionSequence actionOne:(CCActionFiniteTime*)rotateRight two:(callBack)];

//    [self.animationManager runAnimationsForSequenceNamed:@"pressedAnimation"];
    [_characterSprite runAction:actionSequence];
}

-(void)move
{
    if ([[SaveManager sharedManager] getIsSucking])
    {
        movingPixel = 16;
        
    }
    
    else
    {
        movingPixel= 32;
        
    }
    
    CGPoint postionDifference = ccp(0.f, 0.f);
    
    Direction direction = [self getOrientation];
    
    switch (direction) {
        case kDirectionUp:
            postionDifference = ccp(0, movingPixel);
            break;
            
        case kDirectionDown:
            postionDifference = ccp(0, -movingPixel);
            break;
            
        case kDirectionLeft:
            postionDifference = ccp(-movingPixel, 0);
            break;
            
        case kDirectionRight:
            postionDifference = ccp(movingPixel, 0);
            break;
            
        case kDirection45DownRight:
            postionDifference = ccp(movingPixel, -movingPixel);
            break;
            
        case kDirection45DownLeft:
            postionDifference = ccp(-movingPixel, -movingPixel);
            break;
        
        case kDirection45UpLeft:
            postionDifference = ccp(-movingPixel, movingPixel);
            break;
            
        case kDirection45UpRight:
            postionDifference = ccp(movingPixel, movingPixel);
            break;
            
        default:
            break;
    }
    
    
    CCActionMoveTo* move = [CCActionMoveTo actionWithDuration:_animationDuration position:(ccpAdd(self.position, postionDifference))];
    
    if (_accelerationModeEnabled) {
        [_tailParticle removeFromParent];



        _tailParticle.startSize = 12.5f;
        _tailParticle.endSize  = 9.5f;
        _tailParticle.life = .8f;
        

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
    
    if (shieldActivated)
    {
        CCLOG(@"%d", shieldTimer);
        shieldTimer--;
        if (shieldTimer == 0)
        {
            //        shieldDepleted = true;
            shieldActivated = false;
            [_shieldParticle stopSystem];
        }
    }
    

    
    
//    [[SaveManager sharedManager] getIsSucking];
    


}

-(Direction)getOrientation
{
    float normalizedRotation = fmod(_characterSprite.rotation, 360.0f);
    
    
    if (normalizedRotation < 0.0f) {
        normalizedRotation += 360.f;
    }
    
//    if ([[SaveManager sharedManager] getIsSucking])
//    {
//        if (normalizedRotation < 315.1f && normalizedRotation > 314.9f)
//        {
//            return kDirection45UpRight;
//        }
//        
//        if (normalizedRotation < 225.1f && normalizedRotation > 224.9f)
//        {
//            CCLOG(@"pointing at 45 up left");
//            return kDirection45UpLeft;
//        }
//        
//        if (normalizedRotation < 45.1f && normalizedRotation > 44.9f)
//        {
//            return kDirection45DownRight;
//        }
//        
//        if (normalizedRotation < 135.1&& normalizedRotation > 134.9f)
//        {
//            return kDirection45DownLeft;
//        }
//        
//    }
    
    if (normalizedRotation < 315.1f && normalizedRotation > 314.9f)
    {
        return kDirection45UpRight;
    }
    
    if (normalizedRotation < 225.1f && normalizedRotation > 224.9f)
    {
        CCLOG(@"pointing at 45 up left");
        return kDirection45UpLeft;
    }
    
    if (normalizedRotation < 45.1f && normalizedRotation > 44.9f)
    {
        return kDirection45DownRight;
    }
    
    if (normalizedRotation < 135.1&& normalizedRotation > 134.9f)
    {
        return kDirection45DownLeft;
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

-(void)speedUp
{
    CCLOG(@"Before speed up speed at %.3f", _animationDuration);

    _animationDuration = _animationDuration / 2;
    
    CCLOG(@"After speed up speed at %.3f", _animationDuration);

}

-(void)activateShield
{
    if (shieldDurability > 0)
    {
        [_shieldParticle resetSystem];
        shieldActivated = true;
    }
}

-(BOOL) isShieldActivated
{
    return shieldActivated;
}

//-(void)stopTailParticleWhenEnterPortal
//{
//    [_tailParticle removeFromParent];
//    _tailIsRemoved = true;
//}



@end
