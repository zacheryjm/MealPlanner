//
//  HomeTopNavStackView.swift
//  MealPlanner
//
//  Created by Zachery Miller on 3/14/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import UIKit

class HomeTopNavStackView: UIStackView {
    
    let profileButton = UIButton(type: .system)
    let calendarButton = UIButton(type: .system)


    override init(frame: CGRect) {
        super .init(frame: frame)
        
        let profileImage = #imageLiteral(resourceName: "top_left_profile")
        profileButton.setImage(profileImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: .normal)
        addArrangedSubview(profileButton)
    
        let appImage = #imageLiteral(resourceName: "food")
        let appButton = UIButton(type: .system)
        appButton.setImage(appImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: .normal)
        appButton.isEnabled = false;
        addArrangedSubview(appButton)
        
        let calendarImage = #imageLiteral(resourceName: "calendar")
        calendarButton.setImage(calendarImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: .normal)
        addArrangedSubview(calendarButton)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
