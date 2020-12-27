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
    
    private var disposeBag = DisposeBag()
    private var viewModel: HomeViewModelProtocol = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUIElements()
        bindTableView()
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
        viewModel.currentCity.bind(to: locationTitleLabel.rx.text).disposed(by: disposeBag)
        viewModel.currentWeather.observeOn(MainScheduler()).subscribe (onNext: {[weak self] (weather) in
            guard let self = self else { return }
            // Updates UI.
            self.contentVisibility(isHidden: false)
            self.temperatureLabel.text = "\(Int(weather.temperature)) "
            self.weatherDescriptionLabel.text = weather.weatherDescription[0].localizedDescription
            self.sunsetLabel.text = "Sunset: \(weather.sunset.toHours())"
            self.sunriseLabel.text = "Sunrise: \(weather.sunrise.toHours())"
            self.cloudsLabel.text = "Clouds: \(weather.cloudsPercentage) %"
            self.windSpeedLabel.text = "Wind speed: \(weather.windSpeed)"
            self.humidityLabel.text = "Humidity: \(weather.humidity) %"
            self.pressureLabel.text = "Pressure: \(weather.pressure) hPa"
            Nuke.loadImage(with: weather.weatherDescription[0].iconURL, into: self.iconImageView)
        }).disposed(by: disposeBag)
    }
    
    /// Bind tableView to view model dailiy weather subject.
    func bindTableView() {
        viewModel.dailyWeather.bind(to: tableView.rx.items(cellIdentifier: WeatherCell.reuseIdentifier(), cellType: WeatherCell.self)) {row, item, cell in
            cell.weekDayLabel.text = item.weekDay
            cell.maxTemperatureLabel.text = "\(Int(item.temperatureMax))"
            cell.minTemperatureLabel.text = "\(Int(item.temperatureMin))"
            Nuke.loadImage(with: item.weatherDescription[0].iconURL, into: cell.weatherIconImageView)        
        }.disposed(by: disposeBag)
    }
    
    /// Bind controller to view models alert views.
    func bindAlertViews() {
        viewModel.alertMessagesSubject.observeOn(MainScheduler()).bind(to: rx.alert).disposed(by: disposeBag)
    }
    
    /// Set content visibility.
    /// - Parameter isHidden: Is content hidden.
    private func contentVisibility(isHidden: Bool) {
        self.tableView.isHidden = isHidden
        self.locationTitleLabel.isHidden = isHidden
        self.temperatureLabel.isHidden = isHidden
        self.weatherDescriptionLabel.isHidden = isHidden
        self.sunsetLabel.isHidden = isHidden
        self.sunriseLabel.isHidden = isHidden
        self.cloudsLabel.isHidden = isHidden
        self.windSpeedLabel.isHidden = isHidden
        self.humidityLabel.isHidden = isHidden
        self.pressureLabel.isHidden = isHidden
        self.iconImageView.isHidden = isHidden

    }

}
