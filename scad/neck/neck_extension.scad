/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Neck to support a V bracket
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */
use <scad-utils/transformations.scad>
use <scad-utils/mirror.scad>
use <list-comprehension-demos/skin.scad>
use <agentscad/morph.scad>
use <../lib/profiles.scad>
use <../lib/adjustable_joint.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

// Builds the neck extension
// - i: inter-axis length
module neck_extension( i=NECK_LENGTH ) {
    link_l_min    = 2*LINK_TO_JOINT_L;
    interaxis_min = link_l_min+getAdjustableJointSZ();
    link_l        = i<interaxis_min ? link_l_min : i-getAdjustableJointSZ();
    neckJoints(link_l);
    rotate([90,0,0])
        mirror_x()
        neckLinkShapeFemale(link_l);
    rotate([-90,0,0])
        mirror_x()
        neckLinkShapeMale(link_l);
}

// ----------------------------------------
//              Implementation
// ----------------------------------------
NECK_LENGTH     = 100; // default interaxis between joints
LINK_OVERLAP    = 0.2; // percent of link overlaping
LINK_TO_JOINT_L = getAdjustableJointSZ();

// Places imported joints at their position
module neckJoints ( l=NECK_LENGTH ) {
    translate( [0,-(getAdjustableJointSZ()+l)/2,0] )
    rotate( [-90,0,0] ) {
        adjustableJointFemale(a=90,hj=true);
    }
    translate( [0,(getAdjustableJointSZ()+l)/2,0] )
    rotate( [-90,0,0] ) {
        adjustableJointMale(a=90,hj=true);
    }
}

// Draw one half of female part
module neckLinkShapeFemale ( l=NECK_LENGTH ) {
    strait_link_x = getAdjustableJointSX()/2-LINK_OVERLAP*getAdjustableJointSX();
    profile       = profileAdjustableJoint();
    range         = (getAdjustableJointFemaleX()-strait_link_x)/2;
    skin([
        transform(translation([strait_link_x,0,0]),profile),
        for ( a=[0:1/$fn:1.001] )
            transform(translation([
                getAdjustableJointFemaleX()-range+cos((1-a)*180)*range,
                0,
                l/2+(a-1)*LINK_TO_JOINT_L
            ]),profile)
    ]);
}

// Draw one half of male part
module neckLinkShapeMale ( l=NECK_LENGTH ) {
    strait_link_x = getAdjustableJointSX()/2-LINK_OVERLAP*getAdjustableJointSX();
    profile       = profileAdjustableJoint();
    range         = strait_link_x/2;

    skin([
        transform(translation([strait_link_x,0,0]),profile),
        for ( a=[0:1/$fn:1.001] )
            transform(translation([
                range+cos(a*180)*range,
                0,
                l/2+(a-1)*LINK_TO_JOINT_L
            ]),profile)
    ]);
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
neck_extension ( $fn=50 );
