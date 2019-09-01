/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: 2D profiles
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */
use <scad-utils/transformations.scad>
use <scad-utils/linalg.scad>
include <../generated/smile.svg.scad>

// ----------------------------------------
//                  API
// ----------------------------------------
// This scaling is used by paths2openscad for every shapes
paths2openscadScaling = scaling([25.4/96,-25.4/96,1]);

function profileAdjustableJoint(l=JOINT_L,w=JOINT_W) = [
    [      0,  (l)   ],
    [ -(w-1),  (l)   ],
    [     -w,  (l-1) ],
    [     -w,  0     ],
    [     -w, -(l-1) ],
    [ -(w-1), -(l)   ],
    [      0, -(l)   ],
    [ +(w-1), -(l)   ],
    [     +w, -(l-1) ],
    [     +w,  0     ],
    [     +w,  (l-1) ],
    [ +(w-1),  (l)   ],
];

function profileAdjustableHalfJoint(l=JOINT_L,w=JOINT_W) = [
    [     -w, 0      ],
    [     -w, -(l-1) ],
    [ -(w-1), -(l)   ],
    [      0, -(l)   ],
    [ +(w-1), -(l)   ],
    [     +w, -(l-1) ],
    [     +w, 0      ],
];

function getAdjustableJointW() = JOINT_W;
function getAdjustableJointL() = JOINT_L;

function profileSmile() =
let (
    shape   = transform (
        paths2openscadScaling*
        translation(-vec3(smileReference_0_center)),
        to_3d(smile_0_points) )
) shape;

// ----------------------------------------
//                 Showcase
// ----------------------------------------
JOINT_W = 3.5;
JOINT_L = 8;

function to_2d(list) = [ for(v = list) [v[0],v[1]] ];

translate([0,0,5])
color("SpringGreen")
polygon(to_2d(profileAdjustableJoint()));

translate([0,0,10])
color("DeepSkyBlue")
polygon(to_2d(profileAdjustableHalfJoint()));

translate([0,0,15])
color("Pink")
polygon(to_2d(profileSmile()));
