//
//  BottomSheetViewController.swift
//  Movity
//
//  Created by Роман on 08.04.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import UIKit
import SOPullUpView

class BottomSheetViewController: UIViewController, BottomSheetView {
    var presenter: BottomSheetPresenter!
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var pullUpControl: SOPullUpControl? {
        didSet {
            pullUpControl?.delegate = self
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHandleAreaView()
    }
    
    func setupHandleAreaView() {
        handleArea.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
    
}

// MARK: - SOPullUpViewDelegate

extension BottomSheetViewController: SOPullUpViewDelegate {
    func pullUpViewStatus(_ sender: UIViewController, didChangeTo status: PullUpStatus) {
        print("SOPullUpView status is \(status)")
    }
    
    func pullUpHandleArea(_ sender: UIViewController) -> UIView {
        return handleArea
    }
}
