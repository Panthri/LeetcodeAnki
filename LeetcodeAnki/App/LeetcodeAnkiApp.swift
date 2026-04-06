import SwiftUI
import CoreData

// MARK: - Persistence Controller
class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "LeetcodeAnki")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                // In production, handle this error gracefully
                print("CoreData load error: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        return result
    }()
}

// MARK: - App Entry Point
@main
struct LeetcodeAnkiApp: SwiftUI.App {
    let persistenceController = PersistenceController.shared
    @StateObject private var cardStore = CardStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(cardStore)
        }
    }
}
