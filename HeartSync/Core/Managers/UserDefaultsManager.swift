//
//  UserDefaultsManager.swift
//  HeartSync
//
//  Created by Yavuz Selim Güner on 5.10.2025.
//

import Foundation

final class UserDefaultsManager {

    // MARK: - Singleton
    static let shared = UserDefaultsManager()
    private init() {}

    private let defaults = UserDefaults.standard

    // MARK: - Keys
    //  → private kaldırıldı, böylece clearAll(except:) parametresinde kullanılabilir
    enum Keys: String, CaseIterable {
        case hasSeenOnboarding
        case relationshipStartDate
        case partnerOneName
        case partnerTwoName
        case partnerOneImageURL
        case partnerTwoImageURL
    }

    // MARK: - Onboarding
    var hasSeenOnboarding: Bool {
        get { defaults.bool(forKey: Keys.hasSeenOnboarding.rawValue) }
        set { defaults.set(newValue, forKey: Keys.hasSeenOnboarding.rawValue) }
    }

    // MARK: - Relationship Info
    var relationshipStartDate: Date? {
        get { defaults.object(forKey: Keys.relationshipStartDate.rawValue) as? Date }
        set { defaults.set(newValue, forKey: Keys.relationshipStartDate.rawValue) }
    }

    var partnerOneName: String? {
        get { defaults.string(forKey: Keys.partnerOneName.rawValue) }
        set { defaults.set(newValue, forKey: Keys.partnerOneName.rawValue) }
    }

    var partnerTwoName: String? {
        get { defaults.string(forKey: Keys.partnerTwoName.rawValue) }
        set { defaults.set(newValue, forKey: Keys.partnerTwoName.rawValue) }
    }

    var partnerOneImageURL: String? {
        get { defaults.string(forKey: Keys.partnerOneImageURL.rawValue) }
        set { defaults.set(newValue, forKey: Keys.partnerOneImageURL.rawValue) }
    }

    var partnerTwoImageURL: String? {
        get { defaults.string(forKey: Keys.partnerTwoImageURL.rawValue) }
        set { defaults.set(newValue, forKey: Keys.partnerTwoImageURL.rawValue) }
    }

    // MARK: - Utilities
    /// Tüm kayıtlı UserDefaults verilerini temizler.
    /// - Parameter except: Silinmemesi istenen anahtarlar (isteğe bağlı)
    func clearAll(except keysToKeep: [Keys] = []) {
        for key in Keys.allCases where !keysToKeep.contains(key) {
            defaults.removeObject(forKey: key.rawValue)
        }
    }
}
