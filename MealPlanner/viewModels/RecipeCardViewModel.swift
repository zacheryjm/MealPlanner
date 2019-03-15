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
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageName = imageNames[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(image)
        }
    }
    
    
    init(attributedString : NSAttributedString, textAlignment : NSTextAlignment, imageNames : [String]) {
        self.attributedString = attributedString
        self.textAlignment = textAlignment
        self.imageNames = imageNames
    }
    
    var imageIndexObserver : ((UIImage?) -> ())?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex+1, imageNames.count-1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(imageIndex - 1, 0)
    }
    
    func getImageIndex() -> Int {
        return imageIndex
    }
}

