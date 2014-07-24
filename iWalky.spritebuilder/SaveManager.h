//
//  SaveManager.h
//  iWalky
//
//  Created by Jiahe Kuang on 7/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveManager : NSObject

//-(void)saveIsNotNewbie: (BOOL)isNotNewbie;
//-(BOOL)getIsNotNewbie;
//-(void)resetIsNotNewbie;

-(void)savePlayerNormalMapLevel: (int)playerNormalMapLevel;

-(int)getPlayerNormalMapLevel;

-(void)resetPlayerNormalMapLevel;

/////////

-(void)savePlayerHighestLevel: (int)playerHighestLevel;

-(int)getPlayerHighestLevel;

-(void)resetPlayerHighestLevel;

/////////
-(void)saveStarCount: (int)starCount;

-(int)getStarCount;

-(void)resetStarCount;
/////////
-(void)saveBarrelCount: (int)barrelCount;

-(int)getBarrelCount;

-(void)resetBarrelCount;
/////////
-(void)saveCurrentPlayingMap: (NSString*)saveCurrentPlayingMap;

-(NSString*)getCurrentPlayingMap;

-(void)resetCurrentPlayingMap;

//////
-(void)savePlayerHighScoreRecord: (NSArray*) playerHighScoreRecord;

-(NSArray*)getPlayerHighScoreRecord;

-(void)resetPlayerHighScoreRecord;

-(void)saveIsSucking: (BOOL)isSucking;
-(BOOL)getIsSucking;
-(void)resetIsSucking;

-(void)saveEngineLevel: (int)engineLevel;
-(int)getEngineLevel;

-(void)saveShieldDurability: (int)shieldDurability;
-(int)getshieldDurability;



+(id)sharedManager;

@end
