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


struct RecipeCardViewModel {
    let attributedString : NSAttributedString
    let textAlignment : NSTextAlignment
    let imageName : String
}

