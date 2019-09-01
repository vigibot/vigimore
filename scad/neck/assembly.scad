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
use <../lib/adjustable_joint.scad>
use <cable_gland_joint_cover.scad>
use <cable_gland_joint_screw.scad>
use <hirth_joint.scad>
use <knob.scad>
use <knob_cap.scad>
use <neck.scad>
use <neck_extension.scad>
use <servo_bracket_joint.scad>

// ----------------------------------------
//                 Showcase
// ----------------------------------------

transformNeck() {
    neck(i=NECK_L);

    transformNeckAdjustableJointKnob(y=-NECK_L/2)
        neckAdjustableJointKnob(part=0);

    transformExt() {
        neck_extension(i=EXT_L);
        transformServoBracketJoint()
            servoBracketJoint (l=SRVO_JOINT_L,s=SRVO_JOINT_S);
        transformNeckAdjustableJointKnob(y=-EXT_L/2)
            neckAdjustableJointKnob(part=0);
    }
}

transformNeckCableGlandJoint() {
    neckCableGlandJointCover();
    transformNeckCableGlandJointScrew() {
        neckCableGlandJointScrew();
    }
}

transformNeckAdjustableJointKnob()
    neckAdjustableJointKnob(part=0);

// ----------------------------------------
//                 Implementation
// ----------------------------------------

$fn=50;

NECK_L = 60;
EXT_L  = 70;
SRVO_JOINT_L = 5;
SRVO_JOINT_S = 8;

// Control of angles
NECK_A = 60;
EXT_A  = -30;
SRVO_JOINT_A = -30;


module transformNeck() {
    rotate([NECK_A,0,0])
    translate([0,-NECK_L/2,0])
        children();
}
module transformExt() {
    translate([0,-NECK_L/2,0])
    rotate([EXT_A,0,0])
    translate([0,-EXT_L/2,0])
        children();
}
module transformNeckCableGlandJoint() {
    translate([0,0,11+8+7.5])
    rotate([180,0,0])
        children();
}
module transformNeckCableGlandJointScrew() {
    translate([0,0,-15])
        children();
}
module transformServoBracketJoint() {
    translate([0,-EXT_L/2,0])
    rotate( [SRVO_JOINT_A,0,0] )
    rotate( [0,180,0] )
    translate([
        0,
        -(servoShortContainerY()/2+1.2+SRVO_JOINT_L+SRVO_JOINT_S+7.5),
        -15/2
    ])
        children();
}
module transformNeckAdjustableJointKnob(y=0) {
    translate([-getAdjustableJointFemaleX()-getAdjustableJointSX()/2,+y,0])
    rotate( [0,-90,0] )
        children();
}
