//
//  BoundingBoxParameters.swift
//  Sphere2Project
//
//  Created by IIT PHYS 440 on 1/17/23.
//

import SwiftUI
/// <#Description#>
class BoundingBoxParameters: NSObject {
    var boxradius = ""
    //rewrite this code to calculate two separate lengths for a rectangular prism
    
    /* Doubles the input radius, to be the diameter (length) of the cube. The equation of the surface area of the cube is just
               2
     A = 6 * L^
     
     */
    /// Calculates the surface area of the bounding box of a sphere of radius X
    /// - Returns: Returns the Bounding Box surface Area given the input of box radius
    ///
    ///
    ///
    ///
    ///
     func calculateBoundingBoxSurfaceArea() -> Double {
         let Boxlength = Double(Double(boxradius)! * 2)
         return pow(Boxlength,2) * 6
     }
    
    /*Doubles the input radius, to be the diameter (length) of the cube. The equation of the volume is just
    
           3
     V = L^
     
     */
    /// <#Description#>
    /// - Returns: <#description#>
     func calculateBoundingBoxVolume() -> Double{
         let Boxlength = Double(Double(boxradius)! * 2)
         return  pow(Boxlength,3)    }
 }

