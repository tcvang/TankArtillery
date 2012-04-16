//
//  Player1.h
//  TankArtillery
//
//  Created by default on 4/12/12.
//  Copyright __Thai Vang__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "MyContactListener.h"

@interface Player1 : CCLayer
{
    MyContactListener *contactListener;
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    
    int scoreCount;
    CCLabelTTF *ScoreLabel;
    CCLabelTTF *PlayerLabel;
    NSString *score;
    
    //used to create catapult arm
    b2Fixture *armFixture;
    b2Body *armBody;
    b2RevoluteJoint *armJoint;
    b2MouseJoint *mouseJoint;
   
    b2Body *groundBody;
    
    NSMutableArray *bullets;
    int currentBullet;
    b2Body *bulletBody;
    b2WeldJoint *bulletJoint;
    
    b2Body *bulletBody2;
    b2WeldJoint *bulletJoint2;
    
    BOOL releasingArm;
    
    //enemies
    NSMutableSet *targets;
    NSMutableSet *enemies;
    
}

// returns a CCScene
+(CCScene *) scene;

@end
