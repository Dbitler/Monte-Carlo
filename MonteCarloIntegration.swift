//
//  MonteCarloIntegration.swift
//  Monte-Carlo
//
//  Created by IIT PHYS 440 on 2/9/23.
//

import SwiftUI
class MonteCarloIntegration: NSObject {
    var variableN :Int = 0
    var Nstring = ""
    var insideData = [(xPoint: Double, yPoint: Double)]()
    var outsideData = [(xPoint: Double, yPoint: Double)]()
    var randomx = 0.0
    var randomy = 0.0
    let xmin = 0.0
    let xmax = 1.0
    let ymin = 0.0
    let ymax = 1.0
    var insideGuesses = 0
    var outsideGuesses = 0
    var totalGuesses = 0
    var  exactintegral = ( exp(1.0) - 1.0 )/exp(1.0)
    var integral = -2023.0
    var logerror = 100.0
    
    
    func monteCarloIntegration() {
        variableN = Int(Nstring)!
        for i in 0..<variableN {
            randomx = Double.random(in: xmin...xmax)
            randomy = Double.random(in: ymin...ymax)
            if randomy <= exp(-randomx) {
                if (totalGuesses < 20000) {  insideData.append((xPoint: randomx, yPoint: randomy))
                }
                insideGuesses = insideGuesses + 1
            }
            else {
                if (totalGuesses < 20000) { outsideData.append((xPoint: randomx, yPoint: randomy))
                }
                outsideGuesses = outsideGuesses + 1
            }
            totalGuesses = totalGuesses + 1
        }
        //PLACEHOLDER CODE, REPLACE WITH CALL TO BOUNDINGBOX PARAMETERS
        let areaofBoundingBox = 1.0
        integral = Double(insideGuesses)/Double(totalGuesses) * areaofBoundingBox
        logerror = -log10(abs(integral - exactintegral)/exactintegral)
    }


}
