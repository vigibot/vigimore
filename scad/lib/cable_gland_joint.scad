/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: V bracket to hold a servo bracket with an adjustable joint
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */
use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>
use <list-comprehension-demos/skin.scad>
use <agentscad/extensions.scad>
use <agentscad/mx-screw.scad>
use <agentscad/mx-thread.scad>
use <agentscad/morph.scad>
use <agentscad/bevel.scad>
use <agentscad/printing.scad>
use <../lib/profiles.scad>
use <../lib/adjustable_joint.scad>

// ----------------------------------------
//                  API
// ----------------------------------------

// Cover part holding the joint
//   p: Thread parameters ( ie: M36() )
//   s: Height of the skirt
//   c: Cable passage distance from center
//   a: Cable passage inclinaison
//   w: Screw part wall thickness
// Note: other dimensions are deduced from p:
//   Size of the screwing head: head length/diameter
//   Deep of the cover:         thread length
//   Diameter of the cover:     head diameter
module cableGlandJointCover( p, s=JOINT_SKIRT_SZ, c=FLAT_CABLE_Y, a=FLAT_CABLE_R, w=WALL_T ) {
    difference() {
        cableGlandJointCoverShape(p, s);
        cableGlandJointCoverHoles(p, c, a, w);
        
        radius   = mxGetHexagonalHeadD(p)/2;
        height   = 2*mxGetThreadL(p);
        translate( [radius,radius,height/2] )
            bevelCutArc( radius, height, 360 );
    }
    mxThreadInternal(p);
}

// Screw part holding the joint
//   p: Thread parameters ( ie: M36() )
//   w: Wall thickness
// Note: other dimensions are deduced from p:
//   Size of the screwing head: thread head length/diameter
//   Deep of the cover:         thread length
//   Diameter of the cover:     thread head diameter
module cableGlandJointScrew( p, w=WALL_T ) {
    hole_h   = mxGetThreadL(p)+mxGetHexagonalHeadL(p);
    hole_r   = max(0,mxGetThreadD(p)/2-mxGetPitch(p)-w);
    difference() {
        mxBoltHexagonalThreaded(p,bb=false);
        translate( [0,0,-mxGetHexagonalHeadL(p)+hole_h/2] )
        bevelCutArcConcave( hole_r, hole_h, 360 );
    }
}

// ----------------------------------------
//              Implementation
// ----------------------------------------
WALL_T          = 2;
JOINT_SKIRT_SZ  = 8;
FLAT_CABLE_Y    = 10;
FLAT_CABLE_R    = 15;

module cableGlandJointCoverShape(p, s) {
    radius   = mxGetHexagonalHeadD(p)/2;
    wall_t   = radius-mxGetThreadDP(p)/2;
    height   = mxGetThreadL(p);

    // Joint part
    translate( [0,0,getAdjustableJointSZ()/2+height+s] )
        adjustableJointMale(hj=true);

    // Skirt
    cableGlandJointCoverSkirt( height, radius, s=s, top=true );

    // Screw cylinder
    cylinder(r=radius,h=height);
}

// top=true: top side of the skirt, false: bottom side
module cableGlandJointCoverSkirt( h, r, s, top=true) {
    radius_p1  = r;
    scale_p2   = top ? [1,1,1] : [0,0,0.9];

    skin (
        morph(
            profile1=transform(
                 translation([0,0,h])
                ,circle(radius_p1)
            ),
            profile2=transform(
                 translation([0,0,h])
                *scaling(scale_p2)
                *translation([0,0,s])
                ,profileAdjustableJoint()
            ),
            slices=40,
            speed=top ? 0.7 : 1
        )
    );
}

module cableGlandJointCoverHoles(p, c, a, w) {
    translate ([0,-c,0])
        rotate( [a,0,0] )
        translate ([0,0,-50])
            linear_extrude( 2*100 )
            polygon(to_2d(profileSmile()));

    x3  = mxGetThreadDP(p)/2;
    x1  = mxGetThreadD(p)/2-mxGetPitch(p)-w-2*gap();
    dxy = (x3-x1)/2;
    x2  = x1+dxy;
    y1  = 0;
    y2  = mxGetThreadL(p);
    y3  = y2+dxy;

    rotate_extrude()
        polygon([
            [x1, y1],
            [x1, y2],
            [x2, y3],
            [x3, y2],
            [x3, y1],
        ]);
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
thread = mxGuess ( 60, tl=8, hl=8, hd=74 );
echo( "Rendering for:", mxGetName(thread) );

color( "DeepSkyBlue" )
    cableGlandJointCover(thread,s=20,$fn=100);

color( "SpringGreen" )
    translate( [0,0,-20] )
    cableGlandJointScrew(thread,w=1,$fn=100);
