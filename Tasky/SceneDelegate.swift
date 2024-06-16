//
//  SceneDelegate.swift
//  Tasky
//
//  Created by Tilak Shakya on 14/06/24.
//

import UIKit
import LocalAuthentication

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var hasAuthenticatedOnce = false // Track if authentication has been attempted

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if !UserDefaultsManager.shared.hasCompletedIntroduction() {
            // Show introduction screen
            let onboardingViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
            window.rootViewController = onboardingViewController
        } else {
            // Move directly to dashboard
            let taskViewController = storyboard.instantiateViewController(withIdentifier: "TaskViewController")
            window.rootViewController =  taskViewController
        }
        
        window.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Check if authentication has already been attempted
        if !hasAuthenticatedOnce {
            authenticateUser()
        }
    }

    private func authenticateUser() {
        let context = LAContext()
        var error: NSError?

        // Check if the device can perform Face ID authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Face ID to access the app."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    self.hasAuthenticatedOnce = true // Mark authentication as attempted

                    if success {
                        // Authentication was successful
                        if UserDefaultsManager.shared.hasCompletedIntroduction()  {
                            self.proceedToDashboard()
                        }
                    } else {
                        // Authentication failed
                        self.showAuthenticationFailedAlert()
                    }
                }
            }
        } else {
            // Face ID is not available
            showNoBiometricsAlert()
        }
    }
    
    private func proceedToDashboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let taskViewController = storyboard.instantiateViewController(withIdentifier: "TaskViewController")
        
        // Check if there is a presented view controller
        if let presentedViewController = window?.rootViewController?.presentedViewController {
            if presentedViewController is TaskViewController {
            } else {
                window?.rootViewController = taskViewController
                window?.makeKeyAndVisible()
            }
        }
    }


    private func showAuthenticationFailedAlert() {
        let alert = UIAlertController(title: "Authentication Failed", message: "Unable to authenticate using Face ID.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    private func showNoBiometricsAlert() {
        let alert = UIAlertController(title: "No Biometrics Available", message: "Your device does not support Face ID.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
