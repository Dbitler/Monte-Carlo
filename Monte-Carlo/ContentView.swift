//
//  ContentView.swift
//  Monte-Carlo
//
//  Created by IIT PHYS 440 on 2/3/23.
//

import SwiftUI
import Charts



/* Use monte carlo integration to evaluate the integral of e-x dx over the inteveral from 0 to 1 using n = 10, 20, 50, 100, 200, 500, 1000, 10,000, and 50,000. Calculate the error with respect to the exact answer. Plot the results using a logarithmic scale to show the rate of growth. Determine how the error changes as a function of n. */

// WARNING: PROGRAM SLOWS/CRASHES WITH ANY NUMBER > 100,000, do not attempt.


struct ContentView: View {
    
    //Plot instances variables
    @EnvironmentObject var plotData :PlotClass
    @ObservedObject private var calculator = CalculatePlotData()
    @State var isChecked:Bool = false
    @State var tempInput = ""
    @State var selector = 0
    @MainActor func setObjectWillChange(theObject:PlotClass){
        
        theObject.objectWillChange.send()
        
    }
    @MainActor func setupPlotDataModel(selector: Int){
        
        calculator.plotDataModel = self.plotData.plotArray[selector]
    }
    //ContentView().environmentObject(PlotClass)
    
    //integration variables
    @State var variableN :Int = 0
    @State var Nstring = ""
    @State var insideData = [(xPoint: Double, yPoint: Double)]()
    @State var outsideData = [(xPoint: Double, yPoint: Double)]()
    @State var randomx = 0.0
    @State var randomy = 0.0
    let xmin = 0.0
    let xmax = 1.0
    let ymin = 0.0
    let ymax = 1.0
    @State var insideGuesses = 0
    @State var outsideGuesses = 0
    @State var totalGuesses = 0
    @State var  exactintegral = ( exp(1.0) - 1.0 )/exp(1.0)
    @State var integral = -2023.0
    @State var logerror = 100.0
    @State var values = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    
    var body: some View {
        HStack{
            VStack {
                Text("Enter the # of guesses:")
                TextField("# of Guesses", text: $Nstring)
                Button(action: self.monteCarloIntegration) {
                    Text("Calculate")
                }
                Button(action: integralloop) {
                    Text("Calculate Entire Loop")
                }
                Button(action: clear) {
                    Text("Clear previous Integral")
                }
                Button("Graph exp(-x)", action: {
                    Task.init{
                        self.selector = 0
                        await self.calculate()
                    }
                }
                       
                       
                )
                .padding()
                
            }
            
            //DrawingField
            
            VStack{
                drawingView(redLayer: $insideData, blueLayer: $outsideData)
                    .padding()
                    .aspectRatio(1, contentMode: .fit)
                // Stop the window shrinking to zero.
                Spacer()
                Text("total number of inside guesses: \(insideGuesses)")
                Text("total number of outside guesses: \(outsideGuesses)")
                Text("total number of guesses: \(totalGuesses)")
                Text("exact integral: \(exactintegral)")
                Text("calculated integral: \(integral)")
                Text("log error: \(logerror) ")
            }
            
            // NEED TO CHANGE THIS SO THAT IT ACTUALLY GRAPHS THE ERROR W/ RESPECT TO N-VALUE - comment
            VStack{
                Chart($plotData.plotArray[selector].plotData.wrappedValue) {
                    LineMark(
                        x: .value("n-value", $0.xVal),
                        y: .value("error (logscale)", $0.yVal)
                        
                    )
                    .foregroundStyle($plotData.plotArray[selector].changingPlotParameters.lineColor.wrappedValue)
                    PointMark(x: .value("Position", $0.xVal), y: .value("Height", $0.yVal))
                    
                        .foregroundStyle($plotData.plotArray[selector].changingPlotParameters.lineColor.wrappedValue)
                    
                    
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .padding()
                Text($plotData.plotArray[selector].changingPlotParameters.xLabel.wrappedValue)
                    .foregroundColor(.red)
             }
             
            }
            
        }
        
     
        
        /// monte carlo integration Description:
        /// exact answer to the integral that the splash method will be compared to, as well as drawing a graph that shows the error over the iterations.
        ///    _
        ///   /  1         - x                e - 1
        ///    |           e     dx       =   -----
        ///   _/  0                                e
        ///
        ///
        func monteCarloIntegration() {
            /*
            let mymontecarloinstance = MonteCarloIntegration()
            mymontecarloinstance.Nstring = Nstring
            
            self.insideGuesses = mymontecarloinstance.monteCarloIntegration(name:"insideGuesses")
            let insideData = mymontecarloinstance.insideData
            let outsideData = mymontecarloinstance.outsideData 
            let outsideGuesses = mymontecarloinstance.outsideGuesses
            let totalGuesses = mymontecarloinstance.totalGuesses
            let integral = mymontecarloinstance.integral
            let logerror = mymontecarloinstance.logerror
            let exactintegral = mymontecarloinstance.exactintegral
            
            */
            
            
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
    

        
        func integralloop() {
            var values = [10, 20, 50, 100, 200, 500, 1000, 10000, 50000]
            for value in values {
                Nstring = String(value)
                monteCarloIntegration()
                clear()

            }
        }
        
        func clear(){
            insideData = [(xPoint: Double, yPoint: Double)]()
            outsideData = [(xPoint: Double, yPoint: Double)]()
            insideGuesses = 0
            outsideGuesses = 0
            totalGuesses = 0
            logerror = 0.0
        }
        
        func calculate() async {
            
            let myplottinginstance = CalculatePlotData()
            myplottinginstance.logerror = logerror
            myplottinginstance.Nstring = Nstring
            
            //pass the plotDataModel to the Calculator
            // calculator.plotDataModel = self.plotData.plotArray[0]
            
            setupPlotDataModel(selector: 0)
            
            //   Task{
    
            
            
        
            
            
            let _ = await withTaskGroup(of:  Void.self) { taskGroup in
                
                
                
                taskGroup.addTask {
                    
                    
                    var temp = 0.0
                    
                    
                    
                    //Calculate the new plotting data and place in the plotDataModel
                    await calculator.ploteToTheMinusX()
                    
                    // This forces a SwiftUI update. Force a SwiftUI update.
                    //await self.plotData.objectWillChange.send()
                    
                    await setObjectWillChange(theObject: self.plotData)
                }
                
                
            }
            
            //      }
            
            
        }
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

