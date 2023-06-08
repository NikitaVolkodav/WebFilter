import Foundation

struct FilterCacheService {
    
    private let filterKey = "FilterKey"
    private let userDefault = UserDefaults.standard
    
    func getFilters() -> [String] {
        guard let data = userDefault.object(forKey: filterKey) as? [String] else { return [] }
        return data
    }
    
    func saveFilters(_ dataFilters: [String]) {
        userDefault.set(dataFilters, forKey: filterKey)
    }
}
