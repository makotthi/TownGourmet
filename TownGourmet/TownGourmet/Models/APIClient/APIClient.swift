import UIKit

class APIClient {
    // レストランのデータをぐるなびAPIから受け取る
    private func receiveRestaurants(_ url: URL, _ handler: @escaping (Result<StoreDataArray, Error>) -> Void) {
        // リクエストに必要な情報を生成
        let req = URLRequest(url: url)
        // データ転送を管理するためのセッションを生成
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        // リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: {
            (data, _, error) in
            // セッションを終了
            session.finishTasksAndInvalidate()

            // API通信に失敗した時のエラーハンドリング
            if let error = error {
                handler(.failure(error))
                return
            }
            guard let data = data else {
                return
            }

            // do try catch エラーハンドリング
            do {
                // JSONDecoderのインスタンスを生成
                let decoder = JSONDecoder()
                // 受け取ったjsonデータをパースして格納
                let json = try decoder.decode(StoreDataArray.self, from: data)
                print("ヒット件数:\(String(describing: json.total_hit_count))")

                // クロージャを実行
                handler(.success(json))

            } catch {
                print("エラーが出ました")
                handler(.failure(error))
            }
        })
        // ダウンロード開始
        task.resume()
    }
}

// MARK: - CreateRequestURL
extension APIClient {
    func searchRestaurants(latitude: Double, longitude: Double, _ handler: @escaping (Result<StoreDataArray, Error>) -> Void) {
        // リクエストURLを作成
        guard let requestURL = URL(string: "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=6cf2ac2af697b3358620582d34884f09&latitude=\(latitude)&longitude=\(longitude)&range=5&hit_per_page=100") else {
            return
        }
        print(requestURL)

        receiveRestaurants(requestURL, handler)
    }
}

// MARK: - Receive Restaurant Category
extension APIClient {
    func receiveCategorys(_ handler: @escaping (Result<CategoryDataArray, Error>) -> Void) {
        // リクエストURLを作成
        guard let requestURL = URL(string: "https://api.gnavi.co.jp/master/CategoryLargeSearchAPI/v3/?keyid=6cf2ac2af697b3358620582d34884f09") else {
            return
        }

        // リクエストに必要な情報を生成
        let req = URLRequest(url: requestURL)
        // データ転送を管理するためのセッションを生成
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        // リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: {
            (data, _, error) in
            // セッションを終了
            session.finishTasksAndInvalidate()

            // API通信に失敗した時のエラーハンドリング
            if let error = error {
                print("カテゴリー受信に失敗")
                return
            }
            guard let data = data else {
                return
            }

            // do try catch エラーハンドリング
            do {
                // JSONDecoderのインスタンスを生成
                let decoder = JSONDecoder()
                // 受け取ったjsonデータをパースして格納
                let json = try decoder.decode(CategoryDataArray.self, from: data)

                // クロージャを実行
                handler(.success(json))

            } catch {
                print("カテゴリーデータの解析に失敗")
            }
        })
        // ダウンロード開始
        task.resume()
    }
}
