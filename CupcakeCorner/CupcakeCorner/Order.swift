import Foundation

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3

    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        let allNonEmpty = !name.isEmpty && !streetAddress.isEmpty && !city.isEmpty && !zip.isEmpty
        let oneAllWhiteSpace = name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        return allNonEmpty && !oneAllWhiteSpace
    }
    
    var cost: Decimal {
        var cost = Decimal(quantity) * 2
        cost += Decimal(type) / 2
        
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        if addSprinkles {
            cost += Decimal(quantity)
        }
        
        return cost
    }
    
    // MARK: - UserDefaults persistence
    
    private static let saveKey = "SavedOrder"
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: Order.saveKey)
        }
    }
    
    static func load() -> Order {
        if let savedData = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode(Order.self, from: savedData) {
            return decoded
        }
        return Order()
    }
}
