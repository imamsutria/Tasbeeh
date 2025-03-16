//
//  PrayeerTimes.swift
//  Tasbeeh Watch App
//
//  Created by Imam Sutria on 15/03/25.
//

import SwiftUI

struct PrayeerTimes: View {
    
    @State private var prayerTimes: [String: String] = [:]
    @State private var isLoading = true
    @State private var upcomingPrayer: (name: String, time: String)? = nil
    
    // List of required prayers
    let requiredPrayers = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
    
    var body: some View {
        NavigationStack() {
            
            VStack(spacing: 10){
                
                if isLoading {
                    ProgressView("Fetching Prayer Times...")
                } else {
                    if let nextPrayer = upcomingPrayer {
                        prayerCard(nextPrayer: NextPrayer(name: nextPrayer.name, time: nextPrayer.time))
                    }
                    
//                    VStack(alignment: .leading, spacing: 10) {
//                        ForEach(requiredPrayers, id: \.self) { prayer in
//                            if let time = prayerTimes[prayer] {
//                                HStack {
//                                    Text(prayer)
//                                        .font(.headline)
//                                    Spacer()
//                                    Text(time)
//                                }
//                                .padding()
//                                .background(Color.gray.opacity(0.2))
//                                .cornerRadius(8)
//                            }
//                        }
//                    }.padding(.horizontal)
                    
                    List(requiredPrayers, id: \.self) { prayer in
                        if let time = prayerTimes[prayer] {
                            HStack {
                                Text(prayer)
                                    .font(.headline)
                                Spacer()
                                Text(time)
                                    .font(.body)
                            }
                        }
                    }.padding(.horizontal)
                }
            }
//            .navigationTitle("Prayëër")
            
            .onAppear {  // ✅ Attach .onAppear directly to VStack
                fetchPrayerTimes()
            }
        }
    }
  
    func fetchPrayerTimes() {
        let apiURL = "https://api.aladhan.com/v1/timingsByCity?city=Jakarta&country=Indonesia&method=2"

        guard let url = URL(string: apiURL) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let result = try JSONDecoder().decode(PrayerTimesResponse.self, from: data)
                DispatchQueue.main.async {
                    prayerTimes = result.data.timings.filter { requiredPrayers.contains($0.key) }
                    isLoading = false
                    findUpcomingPrayer()
                }
            } catch {
                print("Error decoding prayer times: \(error)")
            }
        }.resume()
    }

    func findUpcomingPrayer() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // Matches API format

        for prayer in requiredPrayers {
            if let timeString = prayerTimes[prayer] {
                let prayerTimeToday = Calendar.current.date(bySettingHour: Int(timeString.prefix(2)) ?? 0,
                                                            minute: Int(timeString.suffix(2)) ?? 0,
                                                            second: 0,
                                                            of: now)

                if let prayerTime = prayerTimeToday, prayerTime > now {
                    upcomingPrayer = (name: prayer, time: timeString)  // ✅ Set the upcoming prayer
                    break
                }
            }
        }
    }
}

// MARK: - Struct for Next Prayer
struct NextPrayer {
    let name: String
    let time: String
}

struct prayerCard: View {
    let nextPrayer: NextPrayer
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Image("cardImage")
                        .resizable()
                        .frame(width: 184, height: 90)
                        .cornerRadius(10)
                    
                    VStack(){
                        HStack(){
                            HStack(){
                                Text(Image(systemName: "location.fill"))
                                Text("BSD")
                            }
                            Spacer()
                        }
                        Spacer()
                        
                        VStack() {
                            HStack(){
                                Text(nextPrayer.name)
                                Spacer()
                            }
                            HStack(){
                                Text(nextPrayer.time)
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    .frame(width: 184, height: 90)
                }
            }
        }
    }
}


#Preview {
    PrayeerTimes()
        .background(Color(red: 0.012, green: 0.299, blue: 0.326))
}

// MARK: - API Response Model
struct PrayerTimesResponse: Codable {
    let data: PrayerData
}

struct PrayerData: Codable {
    let timings: [String: String]
}
