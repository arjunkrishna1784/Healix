//
//  NewsService.swift
//  MedBot
//
//  Created by Arjun Krishnamurthy on 12/16/25.
//

import Foundation

struct HealthNewsArticle: Identifiable {
    let id: UUID
    let title: String
    let summary: String
    let source: String
    let date: Date
    let url: URL?
    let imageURL: String?
    
    init(title: String, summary: String, source: String, url: String? = nil, imageURL: String? = nil, daysAgo: Int = 0) {
        self.id = UUID()
        self.title = title
        self.summary = summary
        self.source = source
        self.date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
        self.url = url != nil ? URL(string: url!) : nil
        self.imageURL = imageURL
    }
}

class NewsService {
    static let shared = NewsService()
    
    private init() {}
    
    // Fetch real-time health news from NewsAPI
    // Note: In production, you'll need to add your NewsAPI key
    func fetchHealthNews() async -> [HealthNewsArticle] {
        // For now, using enhanced mock data with real URLs
        // In production, replace with actual NewsAPI call:
        // let apiKey = "YOUR_NEWS_API_KEY"
        // let url = URL(string: "https://newsapi.org/v2/everything?q=health&language=en&sortBy=publishedAt&apiKey=\(apiKey)")!
        
        try? await Task.sleep(nanoseconds: 500_000_000) // Simulate network delay
        
        // Enhanced mock data with real health news URLs
        return [
            HealthNewsArticle(
                title: "New Study Highlights Benefits of Regular Exercise",
                summary: "Recent research shows that 30 minutes of daily exercise can significantly improve cardiovascular health and mental well-being.",
                source: "Health Research Journal",
                url: "https://www.healthline.com/health/benefits-of-exercise",
                daysAgo: 1
            ),
            HealthNewsArticle(
                title: "Understanding Sleep Quality and Its Impact on Health",
                summary: "Experts emphasize the importance of 7-9 hours of quality sleep for optimal physical and mental health.",
                source: "Sleep Medicine Today",
                url: "https://www.sleepfoundation.org/how-sleep-works/why-do-we-need-sleep",
                daysAgo: 2
            ),
            HealthNewsArticle(
                title: "Nutrition Guidelines Updated for 2025",
                summary: "New dietary recommendations focus on whole foods, plant-based options, and balanced macronutrients.",
                source: "Nutrition Weekly",
                url: "https://www.hsph.harvard.edu/nutritionsource/healthy-eating-plate/",
                daysAgo: 3
            ),
            HealthNewsArticle(
                title: "Mental Health Awareness Month: Resources and Support",
                summary: "Organizations worldwide are promoting mental health awareness with new resources and support systems.",
                source: "Mental Health Foundation",
                url: "https://www.mentalhealth.gov/",
                daysAgo: 4
            ),
            HealthNewsArticle(
                title: "The Role of Hydration in Daily Wellness",
                summary: "Health experts discuss the critical importance of proper hydration for maintaining energy levels and cognitive function.",
                source: "Wellness Today",
                url: "https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/in-depth/water/art-20044256",
                daysAgo: 5
            ),
            HealthNewsArticle(
                title: "Breakthrough in Preventive Medicine Research",
                summary: "Scientists announce new findings in preventive healthcare that could revolutionize early disease detection.",
                source: "Medical News Today",
                url: "https://www.medicalnewstoday.com/",
                daysAgo: 0
            ),
            HealthNewsArticle(
                title: "Digital Health Tools Gain Traction in 2025",
                summary: "Healthcare apps and wearable devices are becoming increasingly integrated into patient care plans.",
                source: "HealthTech News",
                url: "https://www.healthtechzone.com/",
                daysAgo: 1
            )
        ]
    }
    
    // Real NewsAPI integration (uncomment and add API key for production)
    /*
    private func fetchFromNewsAPI() async throws -> [HealthNewsArticle] {
        let apiKey = "YOUR_NEWS_API_KEY"
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=health+medical&language=en&sortBy=publishedAt&pageSize=20&apiKey=\(apiKey)") else {
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(NewsAPIResponse.self, from: data)
        
        return response.articles.compactMap { article in
            HealthNewsArticle(
                title: article.title,
                summary: article.description ?? "",
                source: article.source.name,
                url: article.url,
                imageURL: article.urlToImage,
                daysAgo: 0
            )
        }
    }
    */
}

// MARK: - NewsAPI Response Models (for future integration)
/*
struct NewsAPIResponse: Codable {
    let articles: [NewsAPIArticle]
}

struct NewsAPIArticle: Codable {
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let source: NewsAPISource
    let publishedAt: String
}

struct NewsAPISource: Codable {
    let name: String
}
*/
