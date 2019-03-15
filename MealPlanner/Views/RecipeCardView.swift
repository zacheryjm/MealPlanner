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
            imageView.image = UIImage(named: recipeCardViewModel.imageNames[0])
            informationLabel.attributedText = recipeCardViewModel.attributedString
            informationLabel.textAlignment = recipeCardViewModel.textAlignment
            
            
            (0..<recipeCardViewModel.imageNames.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barView.layer.cornerRadius = 3
                barView.clipsToBounds = true
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageObserver()
        }
    }

    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "Carbonara"))
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let barsStackView = UIStackView()
    fileprivate let informationLabel = UILabel()

    
    //Configurations
    fileprivate let cardRemovalThreshold : CGFloat = 100;
    fileprivate let cardCornerRadius : CGFloat = 10
    fileprivate let informationLabelPadding = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    fileprivate let gradientLayerLocations : [NSNumber] = [0.7, 1.1]
    fileprivate let gradientLayerColors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    fileprivate let barsStackViewPadding = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    fileprivate let barsStackViewSize = CGSize(width: 0, height: 4)
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)

        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayers()
        setupBarsStackView()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    fileprivate func setupImageObserver() {
        recipeCardViewModel.imageIndexObserver = {[unowned self] (image) in
            self.imageView.image = image
        }
    }
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: barsStackViewPadding, size: barsStackViewSize)
        
        barsStackView.distribution = .fillEqually
        barsStackView.spacing = 4
        
    }
    
    fileprivate func setupLayers() {
        layer.cornerRadius = cardCornerRadius
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor,
                                trailing: trailingAnchor, padding: informationLabelPadding)
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        
    }
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = gradientLayerColors
        gradientLayer.locations = gradientLayerLocations
        layer.addSublayer(gradientLayer)
        
    }
    @objc fileprivate func handleTapGesture(gesture : UITapGestureRecognizer) {
        
        let tapLocation = gesture.location(in: nil)
        let shouldAdvancePhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if(shouldAdvancePhoto) {
            recipeCardViewModel.advanceToNextPhoto()
        }
        else {
            recipeCardViewModel.goToPreviousPhoto()
        }
        barsStackView.arrangedSubviews.forEach { (view) in
            view.backgroundColor = barDeselectedColor
        }
        barsStackView.arrangedSubviews[recipeCardViewModel.getImageIndex()].backgroundColor = .white
    }
    
    @objc fileprivate func handlePanGesture(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (view) in
                view.layer.removeAllAnimations()
            })
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
