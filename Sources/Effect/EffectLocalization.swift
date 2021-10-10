//
//  EffectLocalization.swift
//
//  Created by Geoff Burns on 10/10/21.
//

import Foundation
import Utilities


public class EffectLocalization : ILocalizationRepository
{ 
    
    public static let shared = EffectLocalization()
  
    public func get(_ phrase: String) -> String {
        return NSLocalizedString(phrase,
                                 tableName: nil,
                                 bundle: .module,
                                 value: "",
                                 comment: "")
    }
    public func register()
    {
        LocalizationRegistry.register(EffectLocalization.shared)
    }
    public static func get(_ phrase: String) -> String {
        return EffectLocalization.shared.get(phrase)
    }
    public static func register()
    {
        EffectLocalization.shared.register()
    }
}

