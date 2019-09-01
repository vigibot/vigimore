/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Cover part of cable gland joint
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */
use <agentscad/mx-screw.scad>
use <../lib/cable_gland_joint.scad>

// ----------------------------------------
//                 API
// ----------------------------------------
module neckCableGlandJointCover() {
    thread = mxGuess ( 36, tl=8, hl=8, hd=44 );
    cableGlandJointCover(thread,s=11,c=4,a=30);
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------

neckCableGlandJointCover($fn=100);
%cableGlandJointScrew(mxGuess ( 36, tl=8, hl=8, hd=44 ),$fn=100);
