//
//  ViewController.swift
//  MealPlanner
//
//  Created by Zachery Miller on 3/14/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let homeBottomControl = HomeBottomControlsStackView()
    let topNav = HomeTopNavStackView()
    let recipeDeckView = UIView()
    
    let recipeCardViewModels : [RecipeCardViewModel] = {
        let recipes = [
            Recipe(dish: "Spaghetti Carbonara", rating: "4.7", totalTime: "30 Min", imageName: "Carbonara"),
            Recipe(dish: "Sheet Pan Bruschetta", rating: "4.65", totalTime: "60 Min", imageName: "Bruschetta")
        ] as [producesRecipeCardViewModel]
        
        let recipeViewModels = recipes.map({return $0.toRecipeCardViewModel()})
        return recipeViewModels
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupRecipeDeck()
    }
    
    fileprivate func setupRecipeDeck() {
        
        recipeCardViewModels.forEach { (recipeVM) in
            let cardView = RecipeCardView()
            cardView.recipeCardViewModel = recipeVM
            
            recipeDeckView.addSubview(cardView)
            cardView.fillSuperview()

        }
    }
    
    fileprivate func setupLayout() {
        let mainStackView = UIStackView(arrangedSubviews: [topNav, recipeDeckView, homeBottomControl])
        mainStackView.axis = .vertical
        
        view.addSubview(mainStackView)
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        mainStackView.bringSubviewToFront(recipeDeckView)
    }
}

