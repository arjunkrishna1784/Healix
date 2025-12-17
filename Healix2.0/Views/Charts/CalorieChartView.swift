//
//  CalorieChartView.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI
#if canImport(Charts)
import Charts
#endif

struct CalorieChartView: View {
    let data: [DailyMetric]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text("Weekly Calories")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            #if canImport(Charts)
            if #available(iOS 16.0, *) {
                Chart {
                    ForEach(data) { metric in
                        LineMark(
                            x: .value("Day", metric.dayName),
                            y: .value("Calories", metric.value)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .interpolationMethod(.catmullRom)
                        
                        AreaMark(
                            x: .value("Day", metric.dayName),
                            y: .value("Calories", metric.value)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange.opacity(0.3), .red.opacity(0.1)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)
                    }
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            } else {
                fallbackChart
            }
            #else
            fallbackChart
            #endif
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
    private var fallbackChart: some View {
        GeometryReader { geometry in
            Path { path in
                let maxValue = data.map { $0.value }.max() ?? 1
                let width = geometry.size.width / CGFloat(max(data.count - 1, 1))
                
                for (index, metric) in data.enumerated() {
                    let x = CGFloat(index) * width
                    let y = geometry.size.height - (geometry.size.height * CGFloat(metric.value) / CGFloat(maxValue))
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(
                LinearGradient(
                    colors: [.orange, .red],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
            )
        }
        .frame(height: 200)
    }
}

#Preview {
    CalorieChartView(data: [
        DailyMetric(date: Date(), value: 200),
        DailyMetric(date: Date().addingTimeInterval(86400), value: 350),
        DailyMetric(date: Date().addingTimeInterval(172800), value: 450),
        DailyMetric(date: Date().addingTimeInterval(259200), value: 300),
        DailyMetric(date: Date().addingTimeInterval(345600), value: 500),
        DailyMetric(date: Date().addingTimeInterval(432000), value: 400),
        DailyMetric(date: Date().addingTimeInterval(518400), value: 480)
    ])
    .padding()
}

