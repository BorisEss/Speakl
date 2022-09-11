//
//  TwoColumnsWithTitleTableView.swift
//  stori
//
//  Created by Alex on 28.08.2022.
//

import UIKit
import SpreadsheetView

class TwoColumnsWithTitleTableView: UIView {

    var tableHeight: CGFloat = 0
    var didSelectItem: ((String) -> Void)?
    
    private var title: String = ""
    private var subtitleLeft: String = ""
    private var subtitleRight: String = ""
    private var data: [[String]] = []
    private var mergedItems: [CellRange] = []
    
    private var bottomLeftIndex: IndexPath = IndexPath(row: 0, column: 0)
    private var bottomRightIndex: IndexPath = IndexPath(row: 0, column: 0)
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
    init(width: CGFloat,
         data: TableData) {
        if let rows = data.data {
            let count = rows.count + 2
            let newHeight: CGFloat = CGFloat((37 * count) + count + 3)
            self.tableHeight = newHeight
        } else {
            self.tableHeight = 0
        }
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: tableHeight))
        self.customInit()
        mergedItems = (data.mergedItems ?? []).map({ $0.asCellRange })
        self.loadData(title: data.title ?? "",
                      subtitleLeft: data.subtitle1?[optional: 0] ?? "",
                      subtitleRight: data.subtitle1?[optional: 1] ?? "",
                      data: data.data ?? [])
    }

    //  init used if the view is created programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }

    //  init used if the view is created through IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customInit()
    }

    //  Do custom initialization here
    private func customInit() {
        Bundle.main.loadNibNamed("TwoColumnsWithTitleTableView", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.addSubview(spreadsheetView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        spreadsheetView.frame = bounds
        spreadsheetView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        spreadsheetView.showsVerticalScrollIndicator = false
        spreadsheetView.showsHorizontalScrollIndicator = false
    }
    
    private func loadData(title: String, subtitleLeft: String, subtitleRight: String, data: [[String]]) {
        self.data = data
        self.title = title
        self.subtitleLeft = subtitleLeft
        self.subtitleRight = subtitleRight
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        spreadsheetView.backgroundColor = .clear
        spreadsheetView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.identifier)
        spreadsheetView.gridStyle = .solid(width: 1, color: .white)
        
        checkMinimalIndex(&bottomLeftIndex, defaultIndex: IndexPath(row: data.count + 1, column: 0))
        checkMinimalIndex(&bottomRightIndex, defaultIndex: IndexPath(row: data.count + 1, column: 1))
        
        spreadsheetView.reloadData()
    }
    
    func checkMinimalIndex(_ index: inout IndexPath, defaultIndex: IndexPath) {
        index = defaultIndex
        if let items = mergedItems.filter({ $0.contains(index) }).first {
            index = min(IndexPath(row: items.from.row, column: items.from.column),
                        IndexPath(row: items.to.row, column: items.to.column))
        }
    }
}

extension TwoColumnsWithTitleTableView: SpreadsheetViewDataSource {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 37
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return (contentView.frame.width - 3) / 2
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 2
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return data.count + 2
    }
}

extension TwoColumnsWithTitleTableView: SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let mainCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: TextCell.identifier,
                                                           for: indexPath)
        if let cell = mainCell as? TextCell {
            switch indexPath {
            case IndexPath(row: 0, column: 0):
                cell.setUp(color: .speaklYellowLabel,
                           roundedCorners: [.topLeft, .topRight],
                           radius: 10,
                           text: title)
            case IndexPath(row: 1, column: 0):
                cell.setUp(color: .speaklGreen,
                           text: subtitleLeft)
            case IndexPath(row: 1, column: 1):
                cell.setUp(color: .speaklGreen,
                           text: subtitleRight)
            case bottomLeftIndex:
                cell.setUp(color: .speaklBlueSolid,
                           roundedCorners: [.bottomLeft],
                           radius: 10,
                           text: data[indexPath.row - 2][optional: 0])
            case bottomRightIndex:
                cell.setUp(color: .speaklBlueSolid,
                           roundedCorners: [.bottomRight],
                           radius: 10,
                           text: data[indexPath.row - 2][optional: 1])
            default:
                cell.setUp(color: .speaklBlueSolid, text: data[indexPath.row - 2][optional: indexPath.column])
            }
            return cell
        }
        return mainCell
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        spreadsheetView.deselectItem(at: indexPath, animated: true)
        if let item = data[indexPath.row - 2][optional: indexPath.column] {
            didSelectItem?(item)
        }
    }
    
    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        var range = [CellRange(from: (0, 0), to: (0, 1))]
        range += mergedItems
        return range
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch indexPath {
        case IndexPath(row: 0, column: 0): return false
        case IndexPath(row: 1, column: 0): return false
        case IndexPath(row: 1, column: 1): return false
        default: return true
        }
    }
}
