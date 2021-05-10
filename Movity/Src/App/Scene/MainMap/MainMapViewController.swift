//
//  MainMapViewController.swift
//  Movity
//
//  Created by Роман on 08.04.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import UIKit
import SOPullUpView
import YandexMapsMobile

class MainMapViewController: UIViewController, MainMapView {
    var presenter: MainMapPresenter!
    @IBOutlet weak var mapView: YMKMapView!
    
    // MARK: - Properties
    
    private var map: YMKMap {
        return mapView.mapWindow.map
    }
    
    private let pullUpControl = SOPullUpControl()
    
    // used to return bottom Padding of safe area.
    var bottomPadding: CGFloat {
        let window = UIApplication.shared.keyWindow
        return window?.safeAreaInsets.top ?? 0.0
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pullUpControl.dataSource = self
        pullUpControl.setupCard(from: view)
        setupMapView()
        
        self.overrideUserInterfaceStyle = .dark
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // UI configuration
        self.overrideUserInterfaceStyle = .light
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
    }
    
    func setupMapView() {
        map.logo.setAlignmentWith(YMKLogoAlignment(horizontalAlignment: .right, verticalAlignment: .top))
    }
    
}

extension MainMapViewController: SOPullUpViewDataSource {
    
    func pullUpViewCollapsedViewHeight() -> CGFloat {
        return bottomPadding + 60
    }
    
    func pullUpViewController() -> UIViewController {
        guard let vc = R.storyboard.bottomSheetStoryboard.bottomSheetVC() else { return UIViewController() }
        vc.pullUpControl = self.pullUpControl
        return vc
    }
}
