//
//  Explosion.m
//  iWalky
//
//  Created by Jiahe Kuang on 6/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion

+(id)explosion
{
    return (Explosion*) [CCBReader load:NSStringFromClass(self)];
}

@end
