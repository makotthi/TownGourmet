import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet private weak var thmbnailImageView1: UIImageView!
    @IBOutlet private weak var thmbnailImageView2: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var routeLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(_ storeData: StoreData) {
        // 画像を設定
        thmbnailImageView1.loadImage(url: storeData.image_url?.shop_image1)
        thmbnailImageView2.loadImage(url: storeData.image_url?.shop_image2, noImage: .ver2)

        // 店名を設定
        nameLabel.text = storeData.name
        // アクセスを設定
        routeLabel.text = storeData.routeText()
        // カテゴリーを設定
        categoryLabel.text = storeData.code?.category_name_l?.first
    }

}
