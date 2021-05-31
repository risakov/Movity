import UIKit
import UBottomSheet

protocol BottomSheetView: BaseView {
    func prepareBottomSheet(vehicle: VehicleEntity)
}

// Класс для определения нижней шторки. TODO: В будущем, когда откажутся от поддержки iOS 9 и 10. Перейти на другой под FloatingPanel с лучшей документацией, чем эта и более ЧЕЛОВЕЧЕСКИМ кодом

class BottomSheetViewController: UIViewController {
    var presenter: BottomSheetPresenter!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeToVehicleLabel: UILabel!
    @IBOutlet weak var timeToVehicleTitleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var costPerMinuteLabel: UILabel!
    @IBOutlet weak var freeWaitingTimeLabel: UILabel!
    @IBOutlet weak var costForWaitingTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var fuelTitleLabel: UILabel!
    @IBOutlet weak var percentFuelLabel: UILabel!
    
    @IBAction func onRentButtonTouched(_ sender: Any) {
        
    }
    
    // Координатор, который у каждой созданной шторки свой, он позволяет выполнять различные действия с ней: тянуть, скрывать, добавлять, удалять и т.д. Подробнее смотри в под
    var sheetCoordinator: UBottomSheetCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setCurrentVehicle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sheetCoordinator?.startTracking(item: self)
    }
    
}

// Подписался на Draggable как в примере пода. Может понадобиться для добавления в шторку UITableView
extension BottomSheetViewController: Draggable {
    
}

extension BottomSheetViewController: BottomSheetView {
    // Установка адреса в лейбл нижней шторки
    func prepareBottomSheet(vehicle: VehicleEntity) {
        guard modelLabel != nil else { return }

        switch vehicle.fuel {
        case 0...30:
            percentFuelLabel.textColor = .appRed
            
        case 31...65:
            percentFuelLabel.textColor = .appOrange
            
        case 66...100:
            percentFuelLabel.textColor = .appBlue
            
        default:
            break
        }
        
        switch vehicle.type {
        case .car:
            fuelTitleLabel.isHidden = false
            percentFuelLabel.isHidden = false
            timeToVehicleTitleLabel.text = "Вы доберетесь до машины за:"
            freeWaitingTimeLabel.text = "Бесплатное ожидание - 5 минут"
            fuelTitleLabel.text = "Топливо:"
            percentFuelLabel.text = "\(Int(vehicle.fuel))%"
        case .bicycle:
            fuelTitleLabel.isHidden = true
            percentFuelLabel.isHidden = true
            timeToVehicleTitleLabel.text = "Вы доберетесь до велосипеда за:"
        case .scooter:
            fuelTitleLabel.isHidden = false
            percentFuelLabel.isHidden = false
            timeToVehicleTitleLabel.text = "Вы доберетесь до самоката за:"
            fuelTitleLabel.text = "Заряд батареи:"
            percentFuelLabel.text = "\(Int(vehicle.fuel))%"
        }
        
        modelLabel.text = vehicle.model
        typeLabel.text = vehicle.type.rawValue
        timeToVehicleLabel.text = String(vehicle.timeToVehicle) + " минут"
        idLabel.text = vehicle.number
        vehicleImageView.image = UIImage(named: vehicle.vehicleImageName)
        costPerMinuteLabel.text = String(Int(vehicle.tariff.costPerMinute)) + " руб/мин"
        freeWaitingTimeLabel.text = "Время бесплатного ожидания - \(String(Int(vehicle.tariff.freeWaitingTime))) минут"
        costForWaitingTimeLabel.text = "Ожидание - \(String(Int(vehicle.tariff.costForWaiting))) руб/мин"
        addressLabel.text = vehicle.address
    }
}

