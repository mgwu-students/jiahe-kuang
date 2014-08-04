//
//  SaveManager.m
//  iWalky
//
//  Created by Jiahe Kuang on 7/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SaveManager.h"

static NSString* const kplayerNormalMapLevel = @"playerNormalMapLevel";

static NSString* const kplayerHighestLevel = @"playerHighestLevel";

static NSString* const kcurrentPlayingmap = @"currentPlayingmap";
static NSString* const kstarCounts = @"starCounts";
static NSString* const kbarrelCounts = @"barrelCounts";
static NSString* const kplayerHighScoreRecord = @"playerHighScoreRecord";
static NSString* const kIsSucking = @"isSucking";

static NSString* const kEnginLevel = @"enginLevel";
static NSString* const kEnergyExtractorLevel = @"energyExtractorLevel";
static NSString* const kShieldDurability = @"shieldDurability";
static NSString* const kWeaponSystemLevel = @"weaponSystemLevel";


//static NSString* const kisNotNewbie = @"isNotNewbie";



@implementation SaveManager


//-(void)saveIsNotNewbie: (BOOL)isNotNewbie
//{
//    [[NSUserDefaults standardUserDefaults] setBool:isNotNewbie forKey:kisNotNewbie];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    
//}
//-(BOOL)getIsNotNewbie
//{
//    return [[NSUserDefaults standardUserDefaults] boolForKey:kisNotNewbie];
//}
//-(void)resetIsNotNewbie
//{
//    [[NSUserDefaults standardUserDefaults] setBool:true forKey:kisNotNewbie];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//}


-(void)saveWeaponsystemLevel: (int)weaponSystemLevel
{
    [MGWU setObject:[NSNumber numberWithInt:weaponSystemLevel] forKey:kWeaponSystemLevel];

}
-(int)getWeaponSystemLevel
{
    return [((NSNumber*)[MGWU objectForKey:kWeaponSystemLevel]) intValue];
}

-(void)saveShieldDurability: (int)shieldDurability
{
    [MGWU setObject:[NSNumber numberWithInt:shieldDurability] forKey:kShieldDurability];

}

-(int)getshieldDurability
{
    return [((NSNumber*)[MGWU objectForKey:kShieldDurability]) intValue];

}

-(void)saveEngineLevel:(int)engineLevel
{
    [MGWU setObject:[NSNumber numberWithInt:engineLevel] forKey:kEnginLevel];
}

-(int)getEngineLevel
{
    return [((NSNumber*)[MGWU objectForKey:kEnginLevel]) intValue];
}


-(void)saveIsSucking: (BOOL)isSucking
{
    [[NSUserDefaults standardUserDefaults] setBool:isSucking forKey:kIsSucking];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(BOOL)getIsSucking
{
    return (BOOL)[[NSUserDefaults standardUserDefaults] boolForKey:kIsSucking];
}
-(void)resetIsSucking
{
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:kIsSucking];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


-(void)savePlayerNormalMapLevel: (int)playerNormalMapLevel
{
    [[NSUserDefaults standardUserDefaults] setInteger:playerNormalMapLevel forKey:kplayerNormalMapLevel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(int)getPlayerNormalMapLevel
{
    return  (int)[[NSUserDefaults standardUserDefaults] integerForKey:kplayerNormalMapLevel];
}

-(void)resetPlayerNormalMapLevel
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kplayerNormalMapLevel];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(void)savePlayerHighestLevel: (int)playerHighestLevel
{
    [[NSUserDefaults standardUserDefaults] setInteger:playerHighestLevel forKey:kplayerHighestLevel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(int)getPlayerHighestLevel
{
    return  (int)[[NSUserDefaults standardUserDefaults] integerForKey:kplayerHighestLevel];
}

-(void)resetPlayerHighestLevel
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kplayerHighestLevel];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


-(void)saveCurrentPlayingMap: (NSString*)saveCurrentPlayingMap
{
    [[NSUserDefaults standardUserDefaults] setObject:saveCurrentPlayingMap forKey:kcurrentPlayingmap];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSString*)getCurrentPlayingMap
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:kcurrentPlayingmap];

}

-(void)resetCurrentPlayingMap
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kcurrentPlayingmap];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveStarCount: (int)starCount{
    [[NSUserDefaults standardUserDefaults] setInteger:starCount forKey:kstarCounts];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(int)getStarCount{
    return  (int)[[NSUserDefaults standardUserDefaults] integerForKey:kstarCounts];
    
    
}

-(void)resetStarCount{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kstarCounts];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
/////////
-(void)saveBarrelCount: (int)barrelCount{
    [[NSUserDefaults standardUserDefaults] setInteger:barrelCount forKey:kbarrelCounts];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(int)getBarrelCount{
    return  (int)[[NSUserDefaults standardUserDefaults] integerForKey:kbarrelCounts];
    
}

-(void)resetBarrelCount{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kbarrelCounts];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

///////
-(void)savePlayerHighScoreRecord: (NSArray*) playerHighScoreRecord
{
    [[NSUserDefaults standardUserDefaults] setObject:playerHighScoreRecord forKey:kplayerHighScoreRecord];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSArray*)getPlayerHighScoreRecord
{
    return (NSArray*) [[NSUserDefaults standardUserDefaults] objectForKey:kplayerHighScoreRecord];
}

-(void)resetPlayerHighScoreRecord
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kplayerHighScoreRecord];
    [[NSUserDefaults standardUserDefaults] synchronize];

}



+(id)sharedManager
{
    static dispatch_once_t once;
    static SaveManager *sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [[self alloc] init];
                  });
    
    return sharedInstance;
}



@end
