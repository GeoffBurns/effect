//
//  Jackpot.swift
//  BlackJack
//
//  Created by 🦋 Aurelie 🦋 on 28/9/21.
//

import SwiftUI
import Utilities

public struct CoinView: View {
    var num : Int
    var move : CGFloat
    var frame : CGSize
    var scale : CGFloat { CGFloat(60.random+40)/100.0 }
    var posX : CGFloat  { CGFloat(Int(frame.width*0.6).random) + frame.width*0.2}
    
    var posY : CGFloat  { CGFloat(Int(frame.height*0.7).random) - frame.height*0.4}
    public var body: some View {
        ZStack
            {
        
                    CoinImage.get(num)
                .rotation3DEffect(.degrees( Double(self.move)*3.0+Double(180.random)), axis: (x: 1, y: 0, z: 0))
                .scaleEffect(scale)
                .offset(x: posX  ,
                    y: posY
                        /*-geo.size.height/2.0 */
                        + CGFloat(self.move)*4.0)
      
                }
    }
 
    }
    
public struct Jackpot: View {
    @State private var isShowing : Bool = false
    @State private var move : CGFloat = 0
    
    public init()
    {
        
    }
    fileprivate func youHaveWon() {
        self.isShowing = true
        withAnimation(.linear(duration: 1.2)) {
            self.move = 360
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isShowing = false
            self.move = 0
        }
    }
    public var body: some View {
        ZStack
            {
            GeometryReader { geo in
                if isShowing
                {
                ForEach(0...13,id:\.self)
                {
                    i in
                    CoinView(num: i, move: self.move, frame: geo.size)
  /*              .rotation3DEffect(.degrees( Double(self.move)*3.0+Double(180.random)), axis: (x: 1, y: 0, z: 0))
                .scaleEffect(CGFloat(60.random+40)/100.0)
                .offset(x: CGFloat(Int(geo.size.width*0.6).random) + geo.size.width*0.2/*-geo.size.width/2.0*/,
                    y: CGFloat(Int(geo.size.height*0.7).random) - geo.size.height*0.4
                        /*-geo.size.height/2.0 */
                        + CGFloat(self.move)*4.0)
      
                }*/
                }}}}  .onAppear {
            youHaveWon()
    }
 
    }
}

struct Jackpot_Previews: PreviewProvider {
    static var previews: some View {
        Jackpot()
    }
}
