//
//  HomeBottomControlsStackView.swift
//  MealPlanner
//
//  Created by Zachery Miller on 3/14/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let buttons = [#imageLiteral(resourceName: "refresh_circle"), #imageLiteral(resourceName: "dismiss_circle"), #imageLiteral(resourceName: "super_like_circle"), #imageLiteral(resourceName: "like_circle"), #imageLiteral(resourceName: "boost_circle")].map { (image) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(image.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: .normal)
            return button
        }
        
        buttons.forEach { (view) in
            addArrangedSubview(view)
        }
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
