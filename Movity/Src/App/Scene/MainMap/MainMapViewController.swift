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
import UBottomSheet
import YandexMapsMobile

// Делегат для возвращение из экрана списка по кнопке "Показать на карте" на эту карту с перемещением к выбранному месту
protocol MainMapDelegate: class {
    // Функция для перемещения к выбранному месту после нажатия "Показать на карте"
    func moveToVehicle(vehicle: VehicleEntity)
}

class MainMapViewController: UIViewController {
    @IBOutlet weak var mapView: YMKMapView!
    
    var presenter: MainMapPresenter!
    var sheetCoordinator: UBottomSheetCoordinator!
    var delegate: MainMapDelegate!
    var backView: PassThroughView?
    var currentVehicle: VehicleEntity!
    var vehicles: [VehicleEntity]!
    var dataSource: UBottomSheetCoordinatorDataSource?
    var bottomSheetViewController = BottomSheetConfiguratorImp.getVC()
    var isFirstTap = true
    var isFirstReturnToThisScreen = true
    
    // MARK: - Properties
    
    private var map: YMKMap {
        return mapView.mapWindow.map
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainMapConfigurator().configure(view: self)
        
        // Этот координатор задается, чтобы обездвижить шторку следующим заданным. P.S. Удалить, если потребуется добавить управление движением шторки
        sheetCoordinator = UBottomSheetCoordinator(parent: self,
                                                   delegate: self)
        bottomSheetViewController.sheetCoordinator = sheetCoordinator
        
    }
    
    // Здесь контроллируется отображение шторки в портретной и альбомной ориентации.
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutBottomSheet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareViews()
        prepareNavigationBar()
        prepareMapView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func prepareNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    func prepareMapView() {
        map.logo.setAlignmentWith(YMKLogoAlignment(horizontalAlignment: .right, verticalAlignment: .bottom))
    }
    
    func layoutBottomSheet() {
        guard !vehicles.isEmpty, let currentVehicle = currentVehicle else { return }
        
        sheetCoordinator = UBottomSheetCoordinator(parent: self,
                                                   delegate: self)
        if dataSource != nil {
            sheetCoordinator.dataSource = dataSource!
        }
        
        presenter.showBottomSheet(view: bottomSheetViewController,
                                  currentVehicle: currentVehicle,
                                  delegate: self)
        
        bottomSheetViewController.view.frame = view.frame
        bottomSheetViewController.sheetCoordinator = sheetCoordinator
        
        sheetCoordinator.addSheet(
            bottomSheetViewController,
            to: self,
            didContainerCreate: { [weak self] container in
                guard let self = self else { return }
                let bounds = self.view.bounds
                let rect = CGRect(
                    x: bounds.minX,
                    y: bounds.minY,
                    width: bounds.width,
                    height: bounds.height
                )
                container.roundCorners(corners: [.topLeft, .topRight], radius: 20, rect: rect)
            }
        )
    }
    
    func moveToPointOnMap(vehicle: VehicleEntity? = nil, zoom: Float, animationDuration: Float) {
        guard let vehicle = vehicle, !vehicles.isEmpty else {
            var sumOfX: Double = 0.0
            var sumOfY: Double = 0.0
            
            for vehicle in vehicles {
                sumOfX += vehicle.coordinate.latitude
                sumOfY += vehicle.coordinate.longitude
            }
            
            // Ставим на карту точку со координатами, равными
            // среднему арифметическому координат всех мест для отцентровки карты
            let x = sumOfX / Double(vehicles.count)
            let y = sumOfY / Double(vehicles.count)
            
            // Ставим на карту точку
            let placemarkCoords = YMKPoint(latitude: x, longitude: y)
            mapView.mapWindow.map.move(
                with: YMKCameraPosition(target: placemarkCoords, zoom: zoom, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: animationDuration),
                cameraCallback: nil)
            return
        }
        
        let latitude = vehicle.coordinate.latitude
        let longitude = vehicle.coordinate.longitude
        
        // Ставим на карту точку
        let placemarkCoords = YMKPoint(latitude: latitude, longitude: longitude)
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: placemarkCoords, zoom: zoom, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: animationDuration),
            cameraCallback: nil)
    }
    
    // Взято из примера пода
    private func addBackDimmingBackView(below container: UIView) {
        backView = PassThroughView()
        view.insertSubview(backView!, belowSubview: container)
        backView!.translatesAutoresizingMaskIntoConstraints = false
        backView!.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backView!.bottomAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
        backView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
}

// Экстеншн из примера пода
extension MainMapViewController: UBottomSheetCoordinatorDelegate {
    
    func bottomSheet(_ container: UIView?, didPresent state: SheetTranslationState) {
        handleState(state)
    }
    
    func bottomSheet(_ container: UIView?, didChange state: SheetTranslationState) {
        handleState(state)
    }
    
    func bottomSheet(_ container: UIView?,
                     finishTranslateWith extraAnimation: @escaping ((CGFloat) -> Void) -> Void) {
        extraAnimation({ percent in
            backView?.backgroundColor = UIColor.black.withAlphaComponent(percent / 100 * 0.8)
        })
    }
    
    func handleState(_ state: SheetTranslationState) {
        switch state {
        case .progressing(_, let percent):
            backView?.backgroundColor = UIColor.black.withAlphaComponent(percent / 100 * 0.8)
            
        case .finished(_, let percent):
            backView?.backgroundColor = UIColor.black.withAlphaComponent(percent / 100 * 0.8)
            
        default:
            break
        }
    }
}

// Для детальной информации о том, как работать с Яндекс.Картами в iOS необходимо обратиться к их примеру использований. Большому проекту со всеми возможностями их YMKMapKit.
extension MainMapViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        currentVehicle = mapObject.userData as? VehicleEntity
//        moveToPointOnMap(vehicle: currentVehicle, zoom: 15, animationDuration: 0.5)
        // Если это первый тап
        if isFirstTap {
            isFirstTap = false
            // Инициализируем шторку
            layoutBottomSheet()
        } else {
            // Просто изменяем ее данные
            presenter.showBottomSheet(view: bottomSheetViewController,
                                      currentVehicle: currentVehicle,
                                      delegate: self)
        }
        return true
    }
}

extension MainMapViewController: MainMapDelegate {
    func moveToVehicle(vehicle: VehicleEntity) {
        moveToPointOnMap(vehicle: vehicle, zoom: 15, animationDuration: 0.5)
        currentVehicle = vehicle
        // Если это первый возврат на экран
        if isFirstReturnToThisScreen {
            isFirstReturnToThisScreen = false
            // Инициализируем шторку
            layoutBottomSheet()
        } else {
            // Просто изменяем ее данные
            presenter.showBottomSheet(view: bottomSheetViewController,
                                      currentVehicle: currentVehicle,
                                      delegate: self)
        }
    }
}

extension MainMapViewController: MainMapView {
    func prepareViews() {
        vehicles = presenter.getVehicles()
        
        guard !vehicles.isEmpty else { return }
        
        map.logo.setAlignmentWith(YMKLogoAlignment(horizontalAlignment: .right, verticalAlignment: .top))
        
        // Ставим на карту первую точку из наших точек
        moveToPointOnMap(vehicle: nil, zoom: 15, animationDuration: 0)
        
        // Добавляем обработчик касаний
        let mapObjects = map.mapObjects
        mapObjects.addTapListener(with: self)
        
        // Создаем и заполняем массив точек карт Яндекса
        var mapPoints = [YMKPoint]()
        for vehicle in vehicles {
            mapPoints.append(
                YMKPoint(
                    latitude: vehicle.coordinate.latitude,
                    longitude: vehicle.coordinate.longitude
                )
            )
        }
        
        // Добавляем метки
        let placemarks = mapObjects.addPlacemarks(with: mapPoints,
                                                  image: UIImage(),
                                                  style: YMKIconStyle(anchor: CGPoint(x: 0, y: 0) as NSValue,
                                                                      rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                                                                      zIndex: 0,
                                                                      flat: true,
                                                                      visible: true,
                                                                      scale: 1.5,
                                                                      tappableArea: nil))
        
        // Устанавливаем свою иконку на метки
        for index in 0..<placemarks.count {
            switch vehicles[index].type {
            case .bicycle:
                placemarks[index].setIconWith(R.image.bicyclePlacemark()!)
                
            case .car:
                placemarks[index].setIconWith(R.image.carPlacemark()!)
                
            case .scooter:
                placemarks[index].setIconWith(R.image.kickScooterPlacemark()!)
            }
        }
        
        for index in 0..<placemarks.count {
            placemarks[index].userData = vehicles[index]
        }
    }
}
