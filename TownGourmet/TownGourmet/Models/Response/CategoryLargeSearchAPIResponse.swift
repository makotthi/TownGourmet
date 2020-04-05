import Foundation

class RestaurantCategory {
    static var category: [String: String] = [:]

    static func setData(_ data: CategoryDataArray) {
        guard let receivedDatas = data.category_l else {
            return
        }
        for item in receivedDatas {
            if let code = item.category_l_code, let name = item.category_l_name {
                category[code] = name
            }
        }
    }
}

// レストランのカテゴリー
struct CategoryDataArray: Codable {
    let category_l: [CategoryData]?
}

struct CategoryData: Codable {
    let category_l_code: String?
    let category_l_name: String?
}
