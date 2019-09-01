/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Joint adjustable with screw and knob
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */

use <scad-utils/transformations.scad>
use <scad-utils/mirror.scad>
use <list-comprehension-demos/skin.scad>
use <agentscad/printing.scad>
use <agentscad/mx-screw.scad>
use <agentscad/mx-knob.scad>
use <agentscad/hirth-joint.scad>
use <profiles.scad>

// ----------------------------------------
//                  API
// ----------------------------------------
JOINT_SX  = getAdjustableJointW()*2;
JOINT_SY  = 15;
JOINT_SZ  = 7.5;

// Hirth Joint parameters
HJ_RADIUS   = 5+gap();
HJ_TEETH    = 11;
HJ_HEIGHT   = 1;
HJ_SHOULDER = 0;
HJ_INLAY    = 1+gap();

SCREW     = M5(tl=24,tlp=24);

// Render the brackets for the Male part
// - l:  additional length of the joint
// - a:  is the nut rotation angle (useful for 3D printing)
// - hj: true to add hirth joint
module adjustableJointMale(l=0,a=0,hj=false) {
    difference() {
        adjustableJointShape(l);
        adjustableJointHoles(a,hj);
    }
}

// Render the couple of brackets for the Female part
// - l:  additional length of the joint
// - a:  is the nut rotation angle (useful for 3D printing)
// - hj: true to add hirth joint
module adjustableJointFemale(l=0,a=0,hj=false) {
    rotate( [180,0,0] )
    difference() {
        mirror_x()
        translate( [getAdjustableJointFemaleX(),0,0] )
            adjustableJointShape(l);
        adjustableJointHoles(a,hj);
    }
}

module adjustableJointKnob(part=0) {
    translate([-JOINT_SX/2-getAdjustableJointFemaleX()-mxGetHeadDP(SCREW)/3,0,0])
    rotate( [0,-90,0] )
        mxKnob(SCREW,part=part);
}

function getAdjustableJointSX()      = JOINT_SX;
function getAdjustableJointSY()      = JOINT_SY;
function getAdjustableJointSZ()      = JOINT_SZ+JOINT_SY/2;
function getAdjustableJointFemaleX() = JOINT_SX+gap();

// ----------------------------------------
//              Implementation
// ----------------------------------------
module adjustableJointShape(l=0) {
    profile1  = transform(
                    translation([0,-0.0001,0]),
                    profileAdjustableHalfJoint()
                );
    mirrored  = transform(scaling([1,-1,1]),profile1);
    profile2  = transform(
                    translation([0,-0.0001,0]),
                    profileAdjustableHalfJoint(getAdjustableJointL()/cos(22.5))
                );
    translate( [0,0,-JOINT_SZ] )
    skin([
        transform(translation([0,0,-l]), profile1),
        for ( a=[22.5:-45:-202.5] )
            transform(
                 translation([0,0,JOINT_SZ])
                *rotation([a,0,0])
                ,profile2
            ),
        transform(translation([0,0,-l]), mirrored)
    ]);
}

module adjustableJointHoles(a=0,hj=false) {
    translate([-JOINT_SX/2-getAdjustableJointFemaleX()-mxGetHeadDP(SCREW)/3,0,0])
    rotate( [0,90,0] )
    rotate( [0,0,a] ) {
        mxBoltHexagonalPassage(SCREW);
        %mxBoltHexagonal(SCREW);
    }

    translate([JOINT_SX/2+getAdjustableJointFemaleX()-mxGetHexagonalHeadL(SCREW),0,0])
    rotate( [0,90,0] )
    rotate( [0,0,a] ) {
        mxNutHexagonalPassage(SCREW);
        %mxNutHexagonal(SCREW);
    }

    if ( hj ) {
        translate( [-getAdjustableJointFemaleX()+JOINT_SX/2,0,0] ) {
            adjustableJointHirthPassage(a);
        }
    }
}

module adjustableJointHirthPassage(a=0) {
    translate( [-(HJ_HEIGHT)/2,0,0] )
        rotate( [a,0,0] )
        rotate( [0,90,0] ) {
             hirthJointPassage(HJ_RADIUS,HJ_HEIGHT,HJ_SHOULDER,HJ_INLAY);
            %hirthJointSinus (HJ_RADIUS,HJ_TEETH,HJ_HEIGHT,HJ_SHOULDER,HJ_INLAY);
        }
    translate( [+(HJ_HEIGHT)/2,0,0] )
        rotate( [a,0,0] )
        rotate( [0,-90,0] ) {
             hirthJointPassage(HJ_RADIUS,HJ_HEIGHT,HJ_SHOULDER,HJ_INLAY);
            %hirthJointSinus (HJ_RADIUS,HJ_TEETH,HJ_HEIGHT,HJ_SHOULDER,HJ_INLAY);
        }
}

module adjustableJointHirth() {
    difference() {
        hirthJointSinus (HJ_RADIUS,HJ_TEETH,HJ_HEIGHT,HJ_SHOULDER,HJ_INLAY);
        translate( [0,0,-HJ_INLAY] )
        mxBoltHexagonalPassage(SCREW);
    }
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------

WANT_HIRTH_JOINT=true;

adjustableJointMale(l=10,hj=WANT_HIRTH_JOINT,$fn=50);
adjustableJointFemale(2,15,WANT_HIRTH_JOINT,$fn=50);
adjustableJointKnob(part=1,$fn=50);
adjustableJointKnob(part=2,$fn=50);

if (0) {
    translate([0,0,20])
        adjustableJointHirth($fn=50);
    %translate([0,0,30])
        adjustableJointHirthPassage();
}
