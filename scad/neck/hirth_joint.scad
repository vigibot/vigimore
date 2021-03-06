/*
 * Copyright (c) 2019, Vigibot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * Description: Main file to render the joint knob
 * Design:      Gilles Bouissac
 * Author:      Gilles Bouissac
 */
use <../lib/adjustable_joint.scad>

// ----------------------------------------
//                 API
// ----------------------------------------
module neckAdjustableJointHirth() {
    adjustableJointHirth();
}

// ----------------------------------------
//                 Showcase
// ----------------------------------------
neckAdjustableJointHirth($fn=100);
