//
//  MonteCarloIntegration.swift
//  Monte-Carlo
//
//  Created by IIT PHYS 440 on 2/9/23.
//

import SwiftUI
class MonteCarloIntegration: ObservableObject {
   @Published var variableN :Int = 0
   @Published var Nstring = ""
   @Published var insideData = [(xPoint: Double, yPoint: Double)]()
   @Published var outsideData = [(xPoint: Double, yPoint: Double)]()
    var randomx = 0.0
    var randomy = 0.0
    let xmin = 0.0
    let xmax = 1.0
    let ymin = 0.0
    let ymax = 1.0
    @Published var insideGuesses = 0
    @Published var outsideGuesses = 0
    @Published var totalGuesses = 0
    @Published var  exactintegral = ( exp(1.0) - 1.0 )/exp(1.0)
    @Published var integral = -2023.0
    @Published var logerror = 100.0
    
    
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

    
    func clear(){
        insideData = [(xPoint: Double, yPoint: Double)]()
        outsideData = [(xPoint: Double, yPoint: Double)]()
        insideGuesses = 0
        outsideGuesses = 0
        totalGuesses = 0
        logerror = 0.0
        integral = 0.0
    
    }

}
