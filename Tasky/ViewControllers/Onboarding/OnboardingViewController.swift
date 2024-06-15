//
//  OnboardingViewController.swift
//  Tasky
//
//  Created by Tilak Shakya on 14/06/24.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    
    private let slides: [OnBoardingSlide] = OnBoardingSlide.collection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        onboardingCollectionView.collectionViewLayout = layout
        onboardingCollectionView.contentInsetAdjustmentBehavior = .never
        onboardingCollectionView.isPagingEnabled = true
    }
    
    private func handleActionButtonTapped(at indexPath: IndexPath) {
        if indexPath.item == slides.count - 1 {
            moveToDashboard()
        } else {
            let nextItem = indexPath.item + 1
            let nextIndexPath = IndexPath(item: nextItem, section: 0)
            onboardingCollectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
        }
    }
    
    private func moveToDashboard() {
        let taskViewController = UIStoryboard(name: AppStringConstant.main, bundle: nil).instantiateViewController(identifier: AppStringConstant.taskViewController)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window {
            window.rootViewController = UINavigationController(rootViewController: taskViewController)
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}


extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = onboardingCollectionView.dequeueReusableCell(withReuseIdentifier: AppStringConstant.onboardingCellIdentifier, for: indexPath) as! OnboardingCollectionViewCell
        let slide = slides[indexPath.item]
        cell.configure(with: slide, currentIndex: indexPath.item)
        cell.actionButtonDidTap = { [weak self] in
            self?.handleActionButtonTapped(at: indexPath)
        }
        return cell
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
