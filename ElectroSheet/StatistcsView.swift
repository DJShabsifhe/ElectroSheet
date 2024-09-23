import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var viewModel: PartViewModel

    var body: some View {
        VStack {
            Text("统计信息")
                .font(.largeTitle)
                .padding()

            HStack {
                VStack {
                    Text("总部件数")
                        .font(.headline)
                    Text("\(viewModel.parts.count)")
                        .font(.title)
                }
                Spacer()
                VStack {
                    Text("收藏数")
                        .font(.headline)
                    Text("\(viewModel.parts.filter { $0.isFavorite }.count)")
                        .font(.title)
                }
                Spacer()
                VStack {
                    Text("不同类型")
                        .font(.headline)
                    Text("\(Set(viewModel.parts.map { $0.type }).count)")
                        .font(.title)
                }
            }
            .padding(.horizontal)

            Divider()
                .padding()

            // 图表展示不同类型的分布
            Chart {
                ForEach(groupedParts, id: \.key) { key, value in
                    BarMark(
                        x: .value("类型", key),
                        y: .value("数量", value.count)
                    )
                    .foregroundStyle(by: .value("类型", key))
                }
            }
            .chartLegend(.visible)
            .padding()

            Spacer()
        }
    }

    // 分组部件按类型
    var groupedParts: [String: [PartItem]] {
        Dictionary(grouping: viewModel.parts, by: { $0.type })
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(viewModel: PartViewModel())
    }
}