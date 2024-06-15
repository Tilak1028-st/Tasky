//
//  OnBoardingSlide.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import Foundation

import UIKit

struct OnBoardingSlide {
    let title: String
    let animationName: String
    let buttonColor: UIColor
    let buttonTitle: String
    
    static let collection: [OnBoardingSlide] = [
        .init(title: AppStringConstant.firstOnBoardingTitle, animationName: AppStringConstant.firstOnboardingAnimation, buttonColor: .appGreen, buttonTitle: AppStringConstant.next),
        .init(title: AppStringConstant.secondOnBoardingTitle, animationName: AppStringConstant.secondOnboardingAnimation, buttonColor: .appGreen, buttonTitle: AppStringConstant.next),
        .init(title: AppStringConstant.thirdOnBoardingTitle, animationName: AppStringConstant.thirdOnboardingAnimation, buttonColor: .appGreen, buttonTitle: AppStringConstant.getStarted)
    ]
}
