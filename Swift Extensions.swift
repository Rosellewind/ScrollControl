//
//  Swift Extensions.swift
//  ScrollControl
//
//  Created by Roselle Tanner on 5/14/17.
//  Copyright © 2017 Roselle Tanner. All rights reserved.
//

import Foundation


extension Array {
    /// Return the first element to satify the predicate includeElement. Returns nil if not found or there is an error.
    func elementPassing(_ includeElement: (Element) throws -> Bool) rethrows -> Element? {
        for element in self {
            do  {
                let isAMatch = try includeElement(element)
                if isAMatch {
                    return element
                }
            } catch {
                print("elementMatching includeElement() error")
            }
        }
        return nil
    }
}
