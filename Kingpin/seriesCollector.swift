import SwiftUI

class SeriesCollector: ObservableObject {
    @Published var arrayOfSeries: [Series] = []
    
    private let fileName = "series_data.json"
    
    func addSeries(game: Series) {
        arrayOfSeries.append(game)
        saveSeries()
    }

    func deleteSeries(at index: IndexSet) {
        guard let indexToDelete = index.first else { return }
        
        // Get the series to remove
        let seriesToRemove = arrayOfSeries[indexToDelete]
        
        // Remove associated files
        removeSeriesFiles(series: seriesToRemove)
        
        // Remove the series from memory and save the updated array
        arrayOfSeries.remove(atOffsets: index)
        saveSeries()
    }
    
    private func removeSeriesFiles(series: Series) {
        series.deleteData()
    }

    private func getFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveSeries() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(arrayOfSeries)
            let fileURL = getFileURL()
            try data.write(to: fileURL)
        } catch {
            print("Error saving series data: \(error)")
        }
    }
    
    func loadSeries() {
        let decoder = JSONDecoder()
        let fileURL = getFileURL()
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                arrayOfSeries = try decoder.decode([Series].self, from: data)
            } catch {
                print("Error loading series data: \(error)")
            }
        } else {
            print("File does not exist, creating new file")
            saveSeries()
        }
    }
}
