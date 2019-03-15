//
//  Recipe.swift
//  MealPlanner
//
//  Created by Zachery Miller on 3/14/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import Foundation
import UIKit


struct Recipe : producesRecipeCardViewModel {
    
    let dish : String
    let rating : String
    let totalTime : String
    let imageName : String
    
    func toRecipeCardViewModel() -> RecipeCardViewModel {
        
        let attributedRecipeInfo = NSMutableAttributedString(string: dish, attributes: [.font:UIFont.systemFont(ofSize: 28, weight: .heavy)])
        
        attributedRecipeInfo.append(NSMutableAttributedString(string: " \(rating)", attributes: [.font:UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        attributedRecipeInfo.append(NSMutableAttributedString(string: "\nTotal time: \(totalTime)", attributes: [.font:UIFont.systemFont(ofSize: 16, weight: .regular)]))
        
        return RecipeCardViewModel(attributedString: attributedRecipeInfo, textAlignment: .left, imageName: imageName)

    }
    
}


