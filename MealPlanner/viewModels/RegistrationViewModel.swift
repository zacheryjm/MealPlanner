//
//  RegistrationViewModel.swift
//  MealPlanner
//
//  Created by Zachery Miller on 3/15/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegistrationViewModel {
    
    var fullName : String? { didSet {checkFormValidity()} }
    var email : String? { didSet {checkFormValidity()} }
    var password : String? { didSet {checkFormValidity()} }
    
    let bindableImage = Bindable<UIImage>()
    let bindableIsFormValid = Bindable<Bool>()
    let bindableIsRegistering = Bindable<Bool>()
    
    fileprivate func checkFormValidity() {
        let formValid  = (fullName?.isEmpty == false) && (email?.isEmpty == false) && (password?.isEmpty == false)
        
        bindableIsFormValid.value = formValid
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        bindableIsRegistering.value = true
        
        guard let userEmail = email, let userPassword = password else {return}
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (res, err) in
            if let err = err {
                completion(err)
                return
            }
            else {
                completion(nil)
            }
            
        }
        if let imageData = self.bindableImage.value?.jpegData(compressionQuality: 1.0) {
            let filename = UUID().uuidString
            let reference = Storage.storage().reference(withPath: "/UserImages/\(filename)")
            
            reference.putData(imageData, metadata: nil) { (data, err) in
                if let e = err {
                    completion(e)
                    return
                }
            }
        }
        
        bindableIsRegistering.value = false
    }
        
    
}
