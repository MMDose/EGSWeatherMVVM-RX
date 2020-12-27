//
//  HomeViewController.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/25/20.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import Nuke

final class HomeViewController: UIViewController, StoryboardInitializable {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    
    private var disposeBag = DisposeBag()
    private var viewModel: HomeViewModelProtocol = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUIElements()
        self.contentVisibility(isHidden: true)
        bindAlertViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Starts fetch weather.
        viewModel.fetchWeather()
    }
    
    /// Bind UI elements to view model subjects.
    func bindUIElements() {
        viewModel.weatherRelay.observeOn(MainScheduler()).subscribe (onNext: {[weak self] (dataType) in
            guard let self = self else { return }
            // Updates UI.
            if case .some(let locality, let weather) = dataType {
                self.emptyDataViewVisibility(isHidden: false)
                self.locationTitleLabel.text = locality
                self.contentVisibility(isHidden: false)
                self.temperatureLabel.text = "\(Int(weather.current.temperature)) "
                self.weatherDescriptionLabel.text = weather.current.weatherDescription[0].localizedDescription
                self.sunsetLabel.text = "Sunset: \(weather.current.sunset.toHours())"
                self.sunriseLabel.text = "Sunrise: \(weather.current.sunrise.toHours())"
                self.cloudsLabel.text = "Clouds: \(weather.current.cloudsPercentage) %"
                self.windSpeedLabel.text = "Wind speed: \(weather.current.windSpeed)"
                self.humidityLabel.text = "Humidity: \(weather.current.humidity) %"
                self.pressureLabel.text = "Pressure: \(weather.current.pressure) hPa"
                Nuke.loadImage(with: weather.current.weatherDescription[0].iconURL, into: self.iconImageView)
                
                Observable.from(optional: weather.daily).bind(to: self.tableView.rx.items(cellIdentifier: WeatherCell.reuseIdentifier(), cellType: WeatherCell.self)) {row, item, cell in
                    cell.weekDayLabel.text = item.weekDay
                    cell.maxTemperatureLabel.text = "\(Int(item.temperatureMax))"
                    cell.minTemperatureLabel.text = "\(Int(item.temperatureMin))"
                    Nuke.loadImage(with: item.weatherDescription[0].iconURL, into: cell.weatherIconImageView)
                }.disposed(by: self.disposeBag)
            } else {
                self.emptyDataViewVisibility(isHidden: true)
            }
        }).disposed(by: disposeBag)
    }
    
    /// Bind controller to view models alert views.
    private func bindAlertViews() {
        viewModel.alertMessagesSubject.observeOn(MainScheduler()).bind(to: rx.alert).disposed(by: disposeBag)
    }
    
    func emptyDataViewVisibility(isHidden: Bool) {
        
    }
    
    /// Set content visibility.
    /// - Parameter isHidden: Is content hidden.
    private func contentVisibility(isHidden: Bool) {
            UIView.animate(withDuration: 0.3,animations: {
                self.contentView.alpha = isHidden ? 0 : 1
                self.emptyStateView.alpha = isHidden ? 1 : 0
            }) { (_) in
                self.contentView.isHidden = isHidden
                self.emptyStateView.isHidden = !isHidden
            }
        
    }

}
