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
import UBottomSheet

// Класс для определения нижней шторки.

class BottomSheetViewController: UIViewController, BottomSheetView {
    var presenter: BottomSheetPresenter!
    
    // Координатор, который у каждой созданной шторки свой, он позволяет выполнять различные действия с ней: тянуть, скрывать, добавлять, удалять и т.д. Подробнее смотри в под
    var sheetCoordinator: UBottomSheetCoordinator?

    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var pullUpControl: SOPullUpControl? {
        didSet {
            pullUpControl?.delegate = self
        }
    }
    
    // MARK: View lifecycle

    override func viewDidLoad() {
        presenter.setPlace()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sheetCoordinator?.startTracking(item: self)
    }
    
    func setupHandleAreaView() {
        handleArea.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
    
}

// Подписался на Draggable как в примере пода. Может понадобиться для добавления в шторку UITableView
extension BottomSheetViewController: Draggable {
    
}

