//
//  OnboardingCollectionViewCell.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import UIKit
import Lottie

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var actionButtonDidTap: (() -> Void )?
    
    func configure(with slide: OnBoardingSlide, currentIndex: Int) {
        titleLabel.text = slide.title
        actionButton.backgroundColor = slide.buttonColor
        actionButton.setTitle(slide.buttonTitle, for: .normal)
        actionButton.applyCornerRadius(12)
        pageControl.numberOfPages = 3
        pageControl.currentPage = currentIndex
        
        guard let animation = LottieAnimation.named(slide.animationName) else {
            print("\(AppErrorConstant.animationLoadingError) \(AppStringConstant.secondOnboardingAnimation)")
            return
        }
        
        animationView.animation = animation
        animationView.loopMode = .loop
        animationView.play()
    }
    
    @IBAction func actionButtonTapped() {
        actionButtonDidTap?()  
    }
}
