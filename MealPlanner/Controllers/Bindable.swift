//
//  Bindable.swift
//  MealPlanner
//
//  Created by Zachery Miller on 3/16/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
    
}
