import SwiftUI

struct deleteSheet: View {
    @Binding var showSheet: Bool
    @ObservedObject var sheet: SeriesCollector
    @State private var isDeleting: Bool = false // State variable for loading
    
    var body: some View {
        VStack {
            if isDeleting {
                ProgressView()
                    .padding()
            } else {
                if sheet.arrayOfSeries.isEmpty {
                    Text("You Don't Have Any Series")
                } else {
                    Text("Swipe left to delete series")
                        .padding(.top, 35)
                    
                    List {
                        ForEach(sheet.arrayOfSeries.reversed()) { series in
                            Text(series.name)
                        }
                        .onDelete(perform: { indexSet in
                            isDeleting = true // Show ProgressView
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                // Reverse the index set before deleting since the array is reversed
                                let reversedIndexSet = IndexSet(indexSet.map { sheet.arrayOfSeries.count - 1 - $0 })
                                sheet.deleteSeries(at: reversedIndexSet)
                                isDeleting = false // Hide ProgressView after deletion
                            }
                        })
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    deleteSheet(showSheet: .constant(true), sheet: SeriesCollector())
}
