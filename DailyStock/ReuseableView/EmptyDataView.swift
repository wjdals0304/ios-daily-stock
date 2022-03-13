//
//  EmptyDataView.swift
//  DailyStock
//
//  Created by 김정민 on 2022/03/11.
//

import UIKit

class EmptyDataView: UIView {

    @IBOutlet var descLabel: UILabel!
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var customView: UIView!
    
    
    init(frame: CGRect,descText: String, buttonText:String) {
        super.init(frame: frame)

        self.setup()
        
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        descLabel.text = descText
        descLabel.font = UIFont.getFont(.regular_18)
        
        let boldTextArray = ["매매일지","종목분석","포트폴리오"]
        
        _ = boldTextArray.map { str in
            if descText.contains(str) {
                descLabel.asFont(targetString: str)
            }
        }

        addButton.setTitle(buttonText, for: .normal)
        addButton.setTitleColor(UIColor.getColor(.whiteColor), for: .normal)
        
        self.clipsToBounds = true
        self.customView.layer.backgroundColor = UIColor.getColor(.reuseViewBackgroundColor).cgColor
        self.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(#function)
        self.setup()

    }
    
    
    private func setup() {
        
        
        let identifier = String(describing: EmptyDataView.self)
        
        
        if let view = UINib(nibName: identifier, bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = self.bounds
            addSubview(view)
        }
        
        [
            imageView1,imageView2,imageView3
        ].forEach {
            $0?.layer.backgroundColor = UIColor.getColor(.imageBarColor).cgColor
        }
        
        
        addButton.layer.backgroundColor = UIColor.getColor(.orangeColor).cgColor
        addButton.titleLabel?.textColor = UIColor.getColor(.whiteColor)
        addButton.layer.cornerRadius = 10
        

    }
    
    
    
    
    
}
