//
//  ACModelOptions.swift
//  SparroBlu
//
//  Created by Thomas Rademaker on 10/22/23.
//

import Foundation

public class ACModelOptions {
    #if DEBUG
    public static let inMemoryPersistence = true
    #else
    public static let inMemoryPersistence = false
    #endif
}
