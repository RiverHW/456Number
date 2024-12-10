import UIKit
import StoreKit

private let reuseIdentifier = "Cell"

let space = 20.0
var lineItem = 2
var itemW = 0.0
var isfinish = true


class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mainCollectionView)

        self.loadData()

        self.title = "请找出下列最大的数字"
        
    }
    
    var countdownProgressView = CountdownProgressView()
    var dataArray = [1]
    
    // MARK: - Netdata
    
    func loadData() {
        isfinish = false
        itemW = (view.bounds.size.width - space * Double(lineItem + 1)) / Double(lineItem) - 0.01

        let range = 0...99
        dataArray = (0..<lineItem*lineItem).map { _ in
            range.randomElement()!
        }
        
        self.mainCollectionView.reloadData()
        print(dataArray.max())
        
    }
    
    
    // MARK: - collectionview
    
    lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collview = UICollectionView.init(frame: view.bounds, collectionViewLayout: layout)
        collview.delegate = self
        collview.dataSource = self
        collview.backgroundColor = UIColor.white
        collview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collview.register(UINib.init(nibName: "LCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "LCollectionViewCell")

        return collview
        
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return lineItem * lineItem
        }else if section == 1{
            return 1
        }
        
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "LCollectionViewCell", for: indexPath) as! LCollectionViewCell
        cell.L.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        cell.L.text = String.init(format: "%ld", dataArray[indexPath.row] as! Int)
        cell.layer.cornerRadius = 10
        cell.L.textColor = .black
        if isfinish {
            if dataArray[indexPath.row] == dataArray.max() {
                cell.L.textColor = .red
            }
        }
        
        
        cell.L.adjustsFontSizeToFitWidth = true
        if indexPath.section == 1 && isfinish == false{
            let cell = collectionView .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            cell.backgroundColor = .white
            countdownProgressView = CountdownProgressView(frame: cell.bounds)
            countdownProgressView.totalTime = 10 // 设置总倒计时时长为30秒，可按需修改
            cell.addSubview(countdownProgressView)

            countdownProgressView.completionBlock = {
                print("倒计时结束啦，在这里可以执行更多自定义操作")
                // 可以在这里添加更多比如弹出提示框、执行动画等逻辑
                self.finishGame()
                
            }

            countdownProgressView.startCountdown()
            
            return cell
        }else if indexPath.section == 2{
            
            if indexPath.row == 0 {
                cell.L.text = "重新开始"
            }else{
                cell.L.text = "很赞"
            }
            cell.L.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
            cell.L.textColor = .black
        }

        
        cell.backgroundColor = .systemGray4
        return cell
    }
    
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSizeMake(itemW, itemW)
        }else if indexPath.section == 1{
            return CGSizeMake(view.bounds.size.width - space*2, 5)
        }
        return CGSizeMake((view.bounds.size.width - 3*space)/2, 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: space*3, left: space, bottom: space, right: space)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        countdownProgressView.timer?.invalidate()
        countdownProgressView.removeFromSuperview()

        if indexPath.section == 0 {
            
            if isfinish{
                return
            }
            
            if dataArray[indexPath.row] == dataArray.max() {
                lineItem = lineItem + 1
                dataArray .removeAll()
                self.loadData()
                self.mainCollectionView.reloadData()
            }else{
                self.finishGame()
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0 {
                self.restart()
            }else{
                SKStoreReviewController .requestReview()

            }
        }
        
    }
    
    func finishGame() {
        isfinish = true
        self.mainCollectionView.reloadData()
        
        // 显示提示信息
        let alert = UIAlertController(title: "挑战失败", message: "点击重新开始", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好的", style: .default, handler: {_ in
            self.restart()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: {_ in
//                  self.restart()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func restart() {
        lineItem = 2
        self.loadData()
        self.mainCollectionView.reloadData()
    }
    
}

