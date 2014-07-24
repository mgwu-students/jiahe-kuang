//
//  LevelRecord.h
//  iWalky
//
//  Created by Jiahe Kuang on 7/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface LevelRecord : CCNode
-(void)setLevelLabel: (int)playerLevel;
-(void)setBestScoreLabel: (int)playerBestScore;

@end
