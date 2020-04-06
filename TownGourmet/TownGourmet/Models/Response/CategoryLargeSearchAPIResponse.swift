import Foundation

// レストランのカテゴリー
struct CategoryDataArray: Codable {
    let category_l: [CategoryData]?
}

struct CategoryData: Codable {
    let category_l_code: String?
    let category_l_name: String?
}
