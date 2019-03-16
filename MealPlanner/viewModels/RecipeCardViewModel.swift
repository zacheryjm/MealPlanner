//
//  RecipeCardViewModel.swift
//  MealPlanner
//
//  Created by Zachery Miller on 3/15/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import Foundation
import UIKit

protocol producesRecipeCardViewModel {
    func toRecipeCardViewModel() -> RecipeCardViewModel
}

class RecipeCardViewModel {
    let attributedString : NSAttributedString
    let textAlignment : NSTextAlignment
    let imageNames : [String]
    
    var bindableImageIndex = Bindable<Int>()
    
    init(attributedString : NSAttributedString, textAlignment : NSTextAlignment, imageNames : [String]) {
        self.attributedString = attributedString
        self.textAlignment = textAlignment
        self.imageNames = imageNames
        bindableImageIndex.value = 0
    }
    
    func advanceToNextPhoto() {
        guard let currentVal = bindableImageIndex.value else {return}
        bindableImageIndex.value = min(currentVal+1, imageNames.count-1)
    }
    
    func goToPreviousPhoto() {
        guard let currentVal = bindableImageIndex.value else {return}
        bindableImageIndex.value = max(currentVal - 1, 0)
    }
    
    func getImageIndex() -> Int {
        guard let currentVal = bindableImageIndex.value else {return 0}
        return currentVal
    }
}

