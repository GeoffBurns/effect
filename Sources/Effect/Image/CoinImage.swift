//
//  CoinImage.swift
//  
//
//  Created by Geoff Burns on 23/9/21.
//

import SwiftUI 


public enum CoinImage
{
    public static func get(_ num: Int) -> Image
    {
        return Image("coin" + num.description, bundle: Bundle.module)
    } 
    
}

