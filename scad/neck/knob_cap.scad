/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Main file to render the cap for the joint knob
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */
use <../lib/adjustable_joint.scad>

// ----------------------------------------
//                 API
// ----------------------------------------
module neckAdjustableJointKnob() {
    translate([0,0,-14])
        rotate( [0,90,0] )
        adjustableJointKnob( part=2 );
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
neckAdjustableJointKnob( $fn=100 );
