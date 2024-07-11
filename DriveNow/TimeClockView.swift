import SwiftUI

struct TimeClockView: View {
    @EnvironmentObject var sideMenuState: SideMenuState
    @State private var isSearching = false  // Not used, but necessary for binding
    @State private var searchText = ""
    
    @State private var timeEntries: [TimeEntry] = [
        TimeEntry(type: .clockIn, time: "0:00 pm"),
        TimeEntry(type: .mealStart, time: "0:00 pm"),
        TimeEntry(type: .mealEnd, time: "0:00 pm"),
        TimeEntry(type: .clockOut, time: "0:00 pm")
    ]
    @State private var currentPhase: TimeEntryType = .clockIn
    @State private var currentTime: String = Date().formattedTime
    
    var body: some View {
        VStack {
            TopBarView(
                title: "Drive Now",
                leftIconName: "arrow.backward",
                leftButtonAction: { /* Add navigation back action */ },
                rightIconName: nil,
                rightButtonAction: nil,
                showSearchBar: false,
                isSearching: $isSearching,
                searchText: $searchText
            )
            .background(Color.black)
            
            VStack {
                // Centered Drive Now Time and current time
                VStack {
                    Text("Drive Now Time")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(currentTime)
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                }
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)

                Divider()
                    .background(Color.white)

                // List of time entries with background and border
                VStack(spacing: 0) {
                    ForEach(timeEntries) { entry in
                        TimeEntryRow(entry: entry)
                            .background(Color.white)
                            .cornerRadius(8)
                            .padding([.leading, .trailing, .top, .bottom], 10)
                    }
                    .background(.gray)
                }
                //.background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()

                Spacer()

                // Dynamic button for clock in, meal start, meal end, and clock out
                Button(action: {
                    handleClockAction()
                }) {
                    Text(currentPhase.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.title2)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding([.leading, .trailing, .bottom], 10)
                }
            }
            .padding()
            .background(Color.black)
        }
        .background(Color.black)
        .environmentObject(sideMenuState)
    }
    
    private func handleClockAction() {
        let newTimeEntry = TimeEntry(type: currentPhase, time: Date().formattedTime)
        timeEntries.append(newTimeEntry)
        
        switch currentPhase {
        case .clockIn:
            currentPhase = .mealStart
        case .mealStart:
            currentPhase = .mealEnd
        case .mealEnd:
            currentPhase = .clockOut
        case .clockOut:
            currentPhase = .clockIn
        }
        
        currentTime = Date().formattedTime
    }
}

struct TimeEntryRow: View {
    let entry: TimeEntry

    var body: some View {
        HStack {
            Image(systemName: entry.iconName)
                .foregroundColor(.red)
            Text(entry.description)
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
            Text(entry.time)
                .foregroundColor(.black)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(.gray)
    }
}

struct TimeEntry: Identifiable {
    let id = UUID()
    let type: TimeEntryType
    let time: String

    var iconName: String {
        switch type {
        case .clockIn: return "checkmark.circle.fill"
        case .mealStart: return "fork.knife"
        case .mealEnd: return "fork.knife"
        case .clockOut: return "checkmark.circle.fill"
        }
    }

    var description: String {
        switch type {
        case .clockIn: return "Clock in"
        case .mealStart: return "Meal start"
        case .mealEnd: return "Meal end"
        case .clockOut: return "Clock out"
        }
    }
}

enum TimeEntryType {
    case clockIn, mealStart, mealEnd, clockOut
    
    var buttonText: String {
        switch self {
        case .clockIn:
            return "Clock in"
        case .mealStart:
            return "Meal start"
        case .mealEnd:
            return "Meal end"
        case .clockOut:
            return "Clock out"
        }
    }
}

extension Date {
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
}

#Preview {
    TimeClockView()
        .environmentObject(SideMenuState())
}
