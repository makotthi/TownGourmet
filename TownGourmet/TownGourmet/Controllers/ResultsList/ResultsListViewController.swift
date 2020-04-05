import UIKit

class ResultsListViewController: UIViewController {

    @IBOutlet weak var resultsTableView: UITableView!

    // レストランのリストを格納する
    var restaurantList: [StoreData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // TableViewDataSourceを設定
        resultsTableView.dataSource = self

        // RestaurantTableViewCellの登録
        resultsTableView.register(UINib(nibName: "RestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "storeCell")

        // TableViewnDelegateを設定
        //resultsTableView.delegate = self

        // TableViewを更新
        resultsTableView.reloadData()
    }

}

// MARK: - UITableViewDataSource
extension ResultsListViewController: UITableViewDataSource {
    // tableViewCellの総数を返すdatasourceメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 店舗リストの総数
        return restaurantList.count
    }

    // tableViewCellに値をセットするdatasourceメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 表示するCellオブジェクトを取得
        // キャストする
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as! RestaurantTableViewCell

        // 店のデータ
        let storeData = restaurantList[indexPath.row]

        // tableViewCellに読み込んだ店のデータを表示させる
        cell.setData(storeData)

        // 設定したCellオブジェクトを画面に反映
        return cell
    }
}
