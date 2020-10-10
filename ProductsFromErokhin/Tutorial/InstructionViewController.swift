//
//  InstructionViewController.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 09.10.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import UIKit
import RxSwift

class InstructionViewController: BindablePage<Instruction> {
    
    @IBOutlet weak var _title: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var ok: UIButton!
//    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
//    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UITableView().rx.dataSource
//        UITextView().rx.text

        // Do any additional setup after loading the view.
//        setupPageControl()
        bindInstruction()
    }
    
    private func bindInstruction() {
        _title.text = model?.title
        image.sd_setImage(with: storageReference(path: model?.img_path ?? ""))
        image.isHidden = (model?.img_path ?? "").isEmpty
        text.text = model?.text
    }
    
//    override func bind(data: Instruction) {
//        _title.text = data.title
//        image.sd_setImage(with: storageReference(path: data.img_path ?? ""))
//        text.text = data.text
//    }
    
//    private func setupPageControl() {
//        viewModel?.pageCount()
//            .bind(to: pageControl.rx.numberOfPages).disposed(by: disposeBag)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
