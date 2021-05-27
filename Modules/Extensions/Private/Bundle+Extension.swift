//
//  Bundle+Extension.swift
//  Core
//
//  Created by Mananchai Rojamornkul on 7/6/2562 BE.
//  Copyright © 2562 Appsynth. All rights reserved.
//

class ClassForBundle {}

extension Bundle {
    static var this: Bundle {
        return Bundle(for: ClassForBundle.self)
    }
}
