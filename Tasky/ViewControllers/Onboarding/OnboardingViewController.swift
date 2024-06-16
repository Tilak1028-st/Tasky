//
//  OnboardingViewController.swift
//  Tasky
//
//  Created by Tilak Shakya on 14/06/24.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    
    // MARK: - Properties
    private let slides: [OnBoardingSlide] = OnBoardingSlide.collection
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    // MARK: - Setup Methods
    private func setUpCollectionView() {
        // Configure collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        onboardingCollectionView.collectionViewLayout = layout
        onboardingCollectionView.contentInsetAdjustmentBehavior = .never // Ensure no content inset adjustment
        onboardingCollectionView.isPagingEnabled = true // Enable paging behavior
    }
    
    // MARK: - Helper Methods
    private func handleActionButtonTapped(at indexPath: IndexPath) {
        // Handle action button tap based on current slide
        if indexPath.item == slides.count - 1 {
            moveToTabBar()
        } else {
            // Scroll to next slide
            let nextItem = indexPath.item + 1
            let nextIndexPath = IndexPath(item: nextItem, section: 0)
            onboardingCollectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
        }
    }
    
    private func moveToTabBar() {
        // Move to main tab bar view after onboarding completion
        UserDefaultsManager.shared.setHasCompletedIntroduction(true)
        let taskViewController = UIStoryboard(name: AppStringConstant.main, bundle: nil).instantiateViewController(identifier: AppStringConstant.taskViewController)
        
        // Transition to main tab bar view
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = taskViewController
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure onboarding collection view cell
        let cell = onboardingCollectionView.dequeueReusableCell(withReuseIdentifier: AppStringConstant.onboardingCellIdentifier, for: indexPath) as! OnboardingCollectionViewCell
        let slide = slides[indexPath.item]
        cell.configure(with: slide, currentIndex: indexPath.item)
        
        // Handle action button tap in cell
        cell.actionButtonDidTap = { [weak self] in
            self?.handleActionButtonTapped(at: indexPath)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set item size for collection view cells
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Set minimum line spacing between sections
        return 0
    }
}
