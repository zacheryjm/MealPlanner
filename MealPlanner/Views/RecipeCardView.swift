//
//  RecipeCardView.swift
//  MealPlanner
//
//  Created by Zachery Miller on 3/14/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import UIKit

class RecipeCardView: UIView {
    
    var recipeCardViewModel : RecipeCardViewModel! {
        didSet {
            imageView.image = UIImage(named: recipeCardViewModel.imageName)
            informationLabel.attributedText = recipeCardViewModel.attributedString
            informationLabel.textAlignment = recipeCardViewModel.textAlignment
        }
    }
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "Carbonara"))
    fileprivate let informationLabel = UILabel()
    
    //Configurations
    fileprivate let cardRemovalThreshold : CGFloat = 100;

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.text = "Recipe Info"
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGesture)
        
    }
    
    @objc fileprivate func handlePanGesture(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .changed:
            handlePanGestureChanged(gesture)
        case .ended:
            handlePanGestureEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handlePanGestureChanged(_ gesture: UIPanGestureRecognizer) {
        let gestureTranslation = gesture.translation(in: nil)

        let degreeToRotate : CGFloat = gestureTranslation.x / 20
        let angleToRotate = degreeToRotate * .pi / 180
        
        let rotationTransformation = CGAffineTransform(rotationAngle: angleToRotate)
        self.transform = rotationTransformation.translatedBy(x: gestureTranslation.x, y: gestureTranslation.y)
    }
    
    fileprivate func handlePanGestureEnded(_ gesture: UIPanGestureRecognizer) {
        let gestureTranslation = gesture.translation(in: nil)
        
        var shouldRemoveCard = false
        if(abs(gestureTranslation.x) > cardRemovalThreshold) {
            shouldRemoveCard = true
        }

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            
            //Push card off right side
            if(shouldRemoveCard), (gestureTranslation.x > 0) {
                self.frame = CGRect(x: 1000, y: 0, width: self.frame.width, height: self.frame.height)
            }
            //Push card off left side
            else if(shouldRemoveCard), (gestureTranslation.x < 0) {
                self.frame = CGRect(x: -1000, y: 0, width: self.frame.width, height: self.frame.height)
            }
            //Return card to initial position
            else {
                self.transform = .identity
            }
        }) { (_) in
            if(shouldRemoveCard) {
                self.removeFromSuperview()
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
