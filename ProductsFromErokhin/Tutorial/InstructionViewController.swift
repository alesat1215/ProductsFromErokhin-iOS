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
    
//    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindInstruction()
    }
    
    private func bindInstruction() {
        _title.text = model?.title
        image.sd_setImage(with: storageReference(path: model?.img_path ?? ""))
        image.isHidden = (model?.img_path ?? "").isEmpty
        text.text = model?.text
        ok.isHidden = !isLastPage()
    }
    
    private func isLastPage() -> Bool {
        (parent as? TutorialViewController)?.isLastPage(self) ?? false
    }

}
