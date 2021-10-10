//
//  stringExtensions.swift 
//
//  Created by Geoff Burns on 18/11/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import Foundation

extension String
{
    public var efLocal : String
    {
            return NSLocalizedString(self,
                                     tableName: nil,
                                     bundle: .module,
                                     value: "",
                                     comment: "")
    }
    public func efLocalizeWith(_ arguements:CVarArg...) -> String
    {
        return String(format: self.localize, arguments: arguements)
    }
    public func efLocalizeWith(_ arguements:[CVarArg]) -> String
    {
        return String(format: self.localize, arguments: arguements)
    }
}

