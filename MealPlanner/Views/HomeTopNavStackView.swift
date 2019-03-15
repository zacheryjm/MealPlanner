//
//  HomeTopNavStackView.swift
//  MealPlanner
//
//  Created by Zachery Miller on 3/14/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import UIKit

class HomeTopNavStackView: UIStackView {

    override init(frame: CGRect) {
        super .init(frame: frame)
        
        let buttons = [#imageLiteral(resourceName: "top_left_profile"),#imageLiteral(resourceName: "Food"),#imageLiteral(resourceName: "top_right_messages")].map { (image) -> UIView in
            
            let button = UIButton(type: .system)
            button.setImage(image.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: .normal)
            return button
        }
        
        buttons.forEach { (view) in
            addArrangedSubview(view)
        }
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
