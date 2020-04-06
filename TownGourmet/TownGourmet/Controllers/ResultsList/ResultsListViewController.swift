import UIKit

class ResultsListViewController: UIViewController {

    @IBOutlet weak var resultsTableView: UITableView!

    // レストランのリストを格納する
    var restaurantList: [StoreData] = []

    // 詳細画面に送るレストランのデータを保持する
    private var restaurantData: StoreData?

    override func viewDidLoad() {
        super.viewDidLoad()

        // TableViewDataSourceを設定
        resultsTableView.dataSource = self

        // RestaurantTableViewCellの登録
        resultsTableView.register(UINib(nibName: "RestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "storeCell")

        // TableViewnDelegateを設定
        resultsTableView.delegate = self

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

// MARK: - UITableViewDelegate
extension ResultsListViewController: UITableViewDelegate {
    // Cellが選択された際に呼び出されるdelegateメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 初期化
        restaurantData = nil
        // ハイライト解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 選択された店のIDを設定
        restaurantData = restaurantList[indexPath.row]
        // 画面遷移
        performSegue(withIdentifier: "goNextView", sender: nil)
    }

    // 遷移先に値を渡す処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 次の画面のインスタンスを格納
        if let nextViewController = segue.destination as? DetailsViewContainer {
            nextViewController.restaurantData = self.restaurantData
        }
    }
}
