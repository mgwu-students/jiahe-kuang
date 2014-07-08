//
//  TailParticle.m
//  iWalky
//
//  Created by Jiahe Kuang on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TailParticle.h"

@implementation TailParticle

+(id)tailParticle
{
    return (TailParticle*) [CCBReader load:NSStringFromClass(self)];

}

@end
