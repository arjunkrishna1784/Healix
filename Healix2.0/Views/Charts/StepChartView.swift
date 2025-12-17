//
//  StepChartView.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import SwiftUI
#if canImport(Charts)
import Charts
#endif

struct StepChartView: View {
    let data: [DailyMetric]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "figure.walk")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text("Weekly Steps")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            #if canImport(Charts)
            if #available(iOS 16.0, *) {
                Chart {
                    ForEach(data) { metric in
                        BarMark(
                            x: .value("Day", metric.dayName),
                            y: .value("Steps", metric.value)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .cornerRadius(8)
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
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(data) { metric in
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(width: (geometry.size.width - 80) / CGFloat(max(data.count, 1)), height: max(10, geometry.size.height * CGFloat(metric.value) / CGFloat(max(data.map { $0.value }.max() ?? 1, 1))))
                        
                        Text(metric.dayName)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 200)
    }
}

#Preview {
    StepChartView(data: [
        DailyMetric(date: Date(), value: 5000),
        DailyMetric(date: Date().addingTimeInterval(86400), value: 7500),
        DailyMetric(date: Date().addingTimeInterval(172800), value: 10000),
        DailyMetric(date: Date().addingTimeInterval(259200), value: 8500),
        DailyMetric(date: Date().addingTimeInterval(345600), value: 12000),
        DailyMetric(date: Date().addingTimeInterval(432000), value: 9000),
        DailyMetric(date: Date().addingTimeInterval(518400), value: 11000)
    ])
    .padding()
}

