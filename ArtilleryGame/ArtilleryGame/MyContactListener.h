//
//  MyContactListener.h
//  TankArtillery
//
//  Created by default on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef TankArtillery_MyContactListener_h
#define TankArtillery_MyContactListener_h

#import "Box2D.h"
#import <set>
#import <algorithm>

class MyContactListener : public b2ContactListener {
    
public:
    std::set<b2Body*>contacts;
    
    MyContactListener();
    ~MyContactListener();
    
    virtual void BeginContact(b2Contact* contact);
    virtual void EndContact(b2Contact* contact);
    virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);   
    virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
    
};

#endif
