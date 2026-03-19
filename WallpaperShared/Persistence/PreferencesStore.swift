import Foundation
import SwiftData

enum PreferencesStore {
    @MainActor
    static func ensureDefault(in context: ModelContext) -> UserPreferences {
        let singletonKey = UserPreferences.singletonKey
        let descriptor = FetchDescriptor<UserPreferences>(
            predicate: #Predicate { $0.key == singletonKey }
        )

        if let existing = try? context.fetch(descriptor).first {
            return existing
        }

        let defaults = UserPreferences()
        context.insert(defaults)

        do {
            try context.save()
        } catch {
            context.rollback()
        }

        return defaults
    }
}
