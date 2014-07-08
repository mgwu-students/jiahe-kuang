//
//  SaveManager.m
//  iWalky
//
//  Created by Jiahe Kuang on 7/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SaveManager.h"

static NSString* const kplayerNormalMapLevel = @"playerNormalMapLevel";
static NSString* const kcurrentPlayingmap = @"currentPlayingmap";
static NSString* const kstarCounts = @"starCounts";
static NSString* const kbarrelCounts = @"barrelCounts";
static NSString* const kisNotNewbie = @"isNotNewbie";



@implementation SaveManager


-(void)saveIsNotNewbie: (BOOL)isNotNewbie
{
    [[NSUserDefaults standardUserDefaults] setBool:isNotNewbie forKey:kisNotNewbie];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
}
-(BOOL)getIsNotNewbie
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kisNotNewbie];
}
-(void)resetIsNotNewbie
{
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:kisNotNewbie];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)savePlayerNormalMapLevel: (int)playerNormalMapLevel
{
    [[NSUserDefaults standardUserDefaults] setInteger:playerNormalMapLevel forKey:kplayerNormalMapLevel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(int)getPlayerNormalMapLevel
{
    return  [[NSUserDefaults standardUserDefaults] integerForKey:kplayerNormalMapLevel];
}

-(void)resetPlayerNormalMapLevel
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kplayerNormalMapLevel];
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
    return  [[NSUserDefaults standardUserDefaults] integerForKey:kstarCounts];
    
    
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
    return  [[NSUserDefaults standardUserDefaults] integerForKey:kbarrelCounts];
    
}

-(void)resetBarrelCount{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kbarrelCounts];
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
