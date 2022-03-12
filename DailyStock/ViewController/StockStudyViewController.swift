//
//  StockStudyViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/19.
//

import UIKit
import RealmSwift

enum Mode {
    case view
    case select
}

class StockStudyViewController: UIViewController {

    @IBOutlet var addButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    let localRealm = try! Realm()
    var tasks : Results<UserStockStudy>!
    var filteredStock : Results<UserStockStudy>!
    var searchWord : String?
    
    var dictionarySelectedIndexPath: [IndexPath : Bool] = [:]

    var eMode: Mode = .view {
        didSet {
            switch eMode {
            case .view:
                for (key, value) in dictionarySelectedIndexPath {
                    if value {
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
                dictionarySelectedIndexPath.removeAll()
                
                selectBarButton.title = "선택"
                navigationItem.leftBarButtonItem = nil
                collectionView.allowsMultipleSelection = false
                
            case .select:
                selectBarButton.title = "취소"
                navigationItem.leftBarButtonItem = deleteBarButton
                collectionView.allowsMultipleSelection = true
            }
        }
    }
    
    lazy var selectBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
        return  barButtonItem
    }()
    
    lazy var deleteBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didDeleteButtonClicked(_:)))
        return barButtonItem
    }()
    
    
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem) {
        eMode = eMode == .view ? .select : .view
        
    }
    
    @objc func didDeleteButtonClicked(_ sender: UIBarButtonItem) {
        
        var deleteNeededIndexPaths: [IndexPath] = []
        
        for (key,value) in dictionarySelectedIndexPath {
            if value {
                deleteNeededIndexPaths.append(key)
            }
        }
        
        for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }){
            
            let row = self.isFiltering ? filteredStock[i.row] : tasks[i.row]
            
            try! localRealm.write {
                localRealm.delete(row)
            }
            
        }
        collectionView.deleteItems(at: deleteNeededIndexPaths)
        dictionarySelectedIndexPath.removeAll()
        collectionView.reloadData()

    }
    
    func setUpBarButtonItems() {
        navigationItem.rightBarButtonItem = selectBarButton
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchController()
        setup()
        
        setUpBarButtonItems()
    }
    
    func setup() {
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor.getColor(.mainColor).cgColor
        
        self.tasks = localRealm.objects(UserStockStudy.self)
        self.navigationItem.title = "종목분석"
        
        
        // collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.getColor(.mainColor)

        let nibName = UINib(nibName: StockStudyCollectionViewCell.identifier, bundle: nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: StockStudyCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        
        //addButton
        addButton.setTitle("", for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    var isFiltering : Bool {
    
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        
        return isActive && isSearchBarHasText
    }
    
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StockStudyDetailViewController") as! StockStudyDetailViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: true, completion: nil)
        
    }
    
    
    func setUpSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "종목 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")

        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    func checkEmptyDataView() {
        
        let taskCount = localRealm.objects(UserStockStudy.self).count

        if taskCount == 0 {
            self.collectionView.isHidden = true
            self.addButton.isHidden = true
            self.navigationItem.searchController?.searchBar.isHidden = true
            self.navigationItem.setRightBarButton(nil, animated: true)
            self.navigationItem.setLeftBarButton(nil, animated: true)
            self.view.addSubview(self.emptyView)
            
            self.emptyView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(150)
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(82)
                make.leading.equalToSuperview().offset(26)
                make.width.equalTo(UIScreen.main.bounds.width - 52)
            }
            
            self.emptyView.addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
            
        } else {
            self.collectionView.isHidden = false
            self.addButton.isHidden = false
            self.navigationItem.searchController?.searchBar.isHidden = false
            self.navigationItem.rightBarButtonItem = selectBarButton
            self.eMode = .view
            self.emptyView.removeFromSuperview()
            
        }
        
    }
    
}


extension StockStudyViewController : UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isFiltering ? filteredStock.count : tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:StockStudyCollectionViewCell.identifier , for: indexPath )  as? StockStudyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
    
        if self.isFiltering {
            
            let filterRow = filteredStock[indexPath.row]
            
            cell.stockNameLabel.text = filterRow.stockName
            cell.stockNameLabel.KeywordBlue(searchWord ?? "" )
            cell.updateDateLabel.text = formatter.string(from: filterRow.updateDate)
            
        } else {
            
            let row = tasks[indexPath.row]
            
            cell.stockNameLabel.text = row.stockName
            cell.updateDateLabel.text =  formatter.string(from: row.updateDate)
            
        }
                
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch eMode {
        case .view :
            collectionView.deselectItem(at: indexPath, animated: true)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StockStudyDetailViewController") as! StockStudyDetailViewController
            
            vc.studyData = self.isFiltering ? filteredStock[indexPath.row] : tasks[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)

        case .select :
            dictionarySelectedIndexPath[indexPath] = true
            
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if eMode == .select {
            dictionarySelectedIndexPath[indexPath] = false
        }
        
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
        let numberOfCells: CGFloat = 2
        let width = collectionView.frame.size.width - (flowLayout.minimumInteritemSpacing * (numberOfCells-1))
        
        return CGSize(width: width/(numberOfCells), height: width/(numberOfCells))
        
    }
    
}




extension StockStudyViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        //대소문자
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        self.searchWord = text
        
        self.filteredStock = self.localRealm.objects(UserStockStudy.self).filter("stockName CONTAINS %@" ,text)
        
        self.collectionView.reloadData()
    }
    
}
