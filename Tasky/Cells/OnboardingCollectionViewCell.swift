//
//  OnboardingCollectionViewCell.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import UIKit
import Lottie

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Properties
    var actionButtonDidTap: (() -> Void )?
    
    // MARK: - Configuration
    func configure(with slide: OnBoardingSlide, currentIndex: Int) {
        // Configure cell UI based on OnBoardingSlide data
        titleLabel.text = slide.title
        actionButton.backgroundColor = slide.buttonColor
        actionButton.setTitle(slide.buttonTitle, for: .normal)
        actionButton.applyCornerRadius(12) 
        pageControl.numberOfPages = 3
        pageControl.currentPage = currentIndex
        
        // Load Lottie animation
        guard let animation = LottieAnimation.named(slide.animationName) else {
            print("Failed to load animation: \(slide.animationName)")
            return
        }
        
        animationView.animation = animation
        animationView.loopMode = .loop // Loop the animation
        animationView.play()
    }
    
    // MARK: - Action Button Tap
    @IBAction func actionButtonTapped() {
        actionButtonDidTap?()
    }
}
