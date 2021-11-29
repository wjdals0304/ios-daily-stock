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
                
                selectBarButton.title = "Select"
                navigationItem.leftBarButtonItem = nil
                collectionView.allowsMultipleSelection = false
                
            case .select:
                selectBarButton.title = "Cancel"
                navigationItem.leftBarButtonItem = deleteBarButton
                collectionView.allowsMultipleSelection = true
            }
        }
    }
    
    lazy var selectBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
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
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibName = UINib(nibName: StockStudyCollectionViewCell.identifier, bundle: nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: StockStudyCollectionViewCell.identifier)
        
        self.tasks = localRealm.objects(UserStockStudy.self)
        self.navigationItem.title = "종목분석"
        
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        
        setUpSearchController()
        setUpStyle()
        setUpBarButtonItems()
        
        addButton.setTitle("", for: .normal)
 

    }
    
    func setUpStyle() {
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1).cgColor
        collectionView.backgroundColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1)
        
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

        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
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
    
        cell.stockNameLabel.textColor = UIColor.black
        cell.stockNameLabel.font =  UIFont(name: "Roboto-Bold", size: 25)
        
        cell.updateDateLabel.textColor = UIColor(red: 0.561, green: 0.565, blue: 0.576, alpha: 1)
        cell.updateDateLabel.font = UIFont(name: "Roboto-Bold", size: 15)
        
        
        cell.layer.borderColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1)
            .cgColor
        cell.backgroundColor = .white
        cell.layer.borderWidth = 10
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
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
            
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            
            self.present(nav,animated: true, completion: nil)
            
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
