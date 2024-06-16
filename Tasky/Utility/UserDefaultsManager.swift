//
//  UserDefaultsManager.swift
//  Tasky
//
//  Created by Tilak Shakya on 16/06/24.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {} // Prevents others from using the default '()' initializer
    
    // Keys for UserDefaults
    private enum Keys: String {
        case hasCompletedIntroduction
    }
    
    // MARK: - Setters
    
    func setHasCompletedIntroduction(_ completed: Bool) {
        UserDefaults.standard.set(completed, forKey: Keys.hasCompletedIntroduction.rawValue)
    }
    
    // MARK: - Getters
    
    func hasCompletedIntroduction() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.hasCompletedIntroduction.rawValue)
    }
    
    // MARK: - Helpers
    
    func clearUserData() {
        UserDefaults.standard.removeObject(forKey: Keys.hasCompletedIntroduction.rawValue)
    }
}
