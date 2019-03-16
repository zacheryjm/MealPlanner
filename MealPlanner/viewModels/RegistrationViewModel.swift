//
//  RegistrationViewModel.swift
//  MealPlanner
//
//  Created by Zachery Miller on 3/15/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import Foundation

class RegistrationViewModel {
    
    var fullName : String? { didSet {checkFormValidity()} }
    var email : String? { didSet {checkFormValidity()} }
    var password : String? { didSet {checkFormValidity()} }
    
    fileprivate func checkFormValidity() {
        let formValid  = (fullName?.isEmpty == false) && (email?.isEmpty == false) && (password?.isEmpty == false)
        
        isFormValidObserver?(formValid)
    }
    
    var isFormValidObserver :((Bool) -> ())?
}
