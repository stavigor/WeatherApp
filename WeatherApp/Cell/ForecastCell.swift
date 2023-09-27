//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Игорь Растегаев on 27.09.2023.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func buildCell(with weather: ForecastrModel){
        tempLabel.text = weather.tempString
        timeLabel.text = weather.timeString
        weatherIcon.image =  UIImage(systemName: weather.conditionName)
    }
    
}
