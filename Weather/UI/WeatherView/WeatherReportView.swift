//
//  WeatherView.swift
//  Weather
//
//  Created by Sharath on 11/10/24.
//

import SwiftUI

struct WeatherReportView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @ObservedObject private var viewModel = WeatherReportViewModel()
    
    let weatherReport: WeatherResponse
    var body: some View {
        DynamicStack(spacing: 0.0) {
            VStack(alignment: .center, spacing: 0.0) {
                //City
                Text(weatherReport.name ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                if let weather = weatherReport.weather?.first {
                    weatherInfo(weather: weather)
                }
                //Temperature
                HStack {
                    Text(viewModel.temperature(value: weatherReport.main?.temp))
                        .font(.system(size: 70, weight: .bold))
                }
                Text(NSLocalizedString("feels_like", comment: "")).font(.caption) + Text(" \(viewModel.temperature(value: weatherReport.main?.feels_like))").font(.caption).fontWeight(.bold)
            }
            Spacer()
            //Sun rise and set
            if let sunDetail = weatherReport.sys {
                sunRaiseSetView(sys: sunDetail)
                Spacer()
            }
            
            //General weather info
            VStack(alignment: .center, spacing: 0.0) {
                if let main = weatherReport.main {
                    weatherDetail(main: main)
                }
                
            }
        }
    }
    
    
    
    func weatherInfo(weather: WeatherResponse.Weather) -> some View {
        HStack {
            //Weather icon
            if let url = URL(string: "https://openweathermap.org/img/wn/\(weather.icon ?? "")@2x.png") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                } placeholder: {
                    ProgressView()
                }
            }
            VStack {
                Text(weather.desc ?? "")
                    .font(.caption)
                Text(weather.main ?? "")
                    .font(.caption)
            }
        }
    }
    
    func sunRaiseSetView(sys: WeatherResponse.Sys) -> some View{
        VStack {
            HStack() {
                Spacer()
                //Sun Rise
                VStack {
                    Image(.sunraise)
                    Text(viewModel.timestampToDate(timestamp: Double(sys.sunrise ?? 0)))
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                
                //Sun set
                VStack {
                    Image(.sunset)
                    Text(viewModel.timestampToDate(timestamp: Double(sys.sunset ?? 0)))
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            Text(NSLocalizedString("sun_raise_set", comment: ""))
                .font(.caption)
        }
        .padding()
    }
    
    func weatherDetail(main: WeatherResponse.Main) -> some View {
        VStack(alignment: .center, spacing: 10) {
            
            //Min Temperature
            item(
                img: "thermometer.low",
                title: "temp_max",
                value: "\(viewModel.temperature(value: main.temp_min))"
            )

            //Max Temperature
            item(
                img: "thermometer.high",
                title: "temp_min",
                value: "\(viewModel.temperature(value: main.temp_max))"
            )

            //Pressuce
            item(
                img: "gauge",
                title: "pressure",
                value: "\(main.pressure ?? 0) hPa"
            )
            //Humidity
            item(
                img: "humidity",
                title: "humidity",
                value: "\(main.humidity ?? 0)%"
            )

            //Sea level
            item(
                img: "waveform.path.ecg",
                title: "sea_level",
                value: "\(main.sea_level ?? 0) hPa"
            )
        }
        .padding()
        .font(.system(.subheadline, weight: .regular))
    }
    
    func item(img: String, title: String, value: String) -> some View {
        let strTitle = NSLocalizedString(title, comment: "")
        return HStack {
            Image(systemName: img)
                .foregroundColor(.blue)
            Text(strTitle).accessibilityLabel(strTitle) + Text(value).fontWeight(.bold).accessibilityLabel(value)
        }
    }
}

