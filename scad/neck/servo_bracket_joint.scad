/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Joint to hold a servo bracket
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */
use <scad-utils/transformations.scad>
use <list-comprehension-demos/skin.scad>
use <agentscad/morph.scad>
use <agentscad/printing.scad>
use <vigicad/scad/lib/extensions.scad>
use <vigicad/scad/lib/bevel.scad>
use <vigicad/scad/lib/hardware_shop.scad>
use <vigicad/scad/lib/servo_sg90.scad>
use <vigicad/scad/lib/servo_sg90_container.scad>
use <../lib/profiles.scad>
use <../lib/adjustable_joint.scad>

// ----------------------------------------
//                  API
// ----------------------------------------
module servoBracketJoint(l=0,s=8) {
    rotate( [0,-90,0] ) {
        difference() {
            servoBracketJointShape (l,s);
            servoBracketJointBevel ();
        }
    }
}

function servoShortContainerX() = SHORT_BOX_X;
function servoShortContainerY() = SHORT_BOX_Y;
function servoShortContainerZ() = servoBoxSizeZ()+2*gap();

// ----------------------------------------
//              Implementation
// ----------------------------------------
SHORT_BOX_X   = 4.0+3.5;
SHORT_BOX_Y   = 33;
SHORT_BOX_T   = 1.2;

module servoShortContainer() {
    translate( [servoShortContainerX()/2,0,0] )
    difference() {
        servoShortContainerShape();
        servoShortContainerTransform() {
            %servo(90);
        }
        // 2x8mm screw
        rotate( [0,-90,0] )
            mirrorX()
            translate( [0,-servoScrewPosY(),-servoShortContainerX()/2])
            screwM2Tight (5.2,2.8);
    }
}

// Move an object to servo position inside container
module servoShortContainerTransform() {
    translate( [servoStandTopPosX()+servoShortContainerX()/2,0,0] )
        children();
}

module servoShortContainerShape() {
    sx = servoShortContainerX();
    sy = (servoStandSizeY()-servoBoxSizeY())/2;
    sz = servoShortContainerZ();

    mirrorX()
        translate([0,(servoStandSizeY()-sy)/2,0])
        cube([sx,sy,sz],center=true);
}




module servoBracketJointShape(l,s) {
    servoShortContainer ();
    servoBracketJointSides ();

    translate( [
        getAdjustableJointSZ()/2,
        servoShortContainerY()/2,0
    ])
        rotate( [0,90,0] )
        rotate( [-90,0,0] ) {
            servoShortContainerSkirt (s);
            translate( [0,0,getAdjustableJointSZ()/2+SHORT_BOX_T+l+s])
                adjustableJointMale(l=l,a=30,hj=true);
        }
}

module servoBracketJointBevel() {
    translate( [
        servoShortContainerX(),
        -servoShortContainerY()/2,
        -servoShortContainerZ()/2-SHORT_BOX_T
    ])
    bevelCutLinear (servoShortContainerZ()+2*SHORT_BOX_T,2*servoShortContainerX());

    rotate( [0,90,0] )
        mirrorY()
        translate( [
            servoShortContainerZ()/2+SHORT_BOX_T,
            -servoShortContainerY()/2,
            servoShortContainerX()
        ])
        rotate( [0,0,-90] )
        bevelCutArc (2,2*servoShortContainerX());

    rotate( [0,0,-90] )
        rotate( [0,90,0] )
        translate( [0,mfg(),-50])
        bevelCutLinear (100,servoShortContainerZ()+2*SHORT_BOX_T);
}

module servoBracketJointSides() {
    x1 = getAdjustableJointSY()/2;
    x2 = x1-servoShortContainerX();
    y  = servoShortContainerY()/2;
    mirrorZ()
    translate( [getAdjustableJointSZ()/2,0,servoShortContainerZ()/2] )
    linear_extrude ( height=SHORT_BOX_T )
        polygon([
            [ x1,  y],
            [-x1,  y],
            [-x1, -y],
            [-x2, -y]
        ]);
}

module servoShortContainerSkirt( s=0 ) {
    x = servoShortContainerZ()/2+SHORT_BOX_T;
    y = getAdjustableJointSY()/2;
    profile1 = [
        [  0,  y, 0 ],
        [ -x,  y, 0 ],
        [ -x,  0, 0 ],
        [ -x, -y, 0 ],
        [  0, -y, 0 ],
        [  x, -y, 0 ],
        [  x,  0, 0 ],
        [  x,  y, 0 ],
    ];
    profile2 = profileAdjustableJoint();
    skin (concat(
            [
                profile1
            ],
            morph(
                profile1=transform(
                     translation([0,0,SHORT_BOX_T])
                    ,profile1
                ),
                profile2=transform(
                     translation([0,0,s+SHORT_BOX_T])
                    ,profile2
                ),
                zenith=profile1[0],
                slices=40,
                speed=0.6
            )
        )
    );
}
// ----------------------------------------
//                 Showcase
// ----------------------------------------
servoBracketJoint ( 5, $fn=50 );

