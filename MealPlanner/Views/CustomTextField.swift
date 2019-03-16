//
//  CustomTextField.swift
//  MealPlanner
//
//  Created by Zachery Miller on 3/15/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    var dxInset : CGFloat
    var dyInset : CGFloat
    var height : Int
    
    init(placeholderText : String, dxInset : CGFloat = 16,
         dyInset : CGFloat = 0, height : Int = 50, cornerRadius : CGFloat = 16) {
        self.dxInset = dxInset
        self.dyInset = dyInset
        self.height = height
        
        super.init(frame: .zero)
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        placeholder = placeholderText
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: dxInset, dy: dyInset)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: dxInset, dy: dyInset)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
