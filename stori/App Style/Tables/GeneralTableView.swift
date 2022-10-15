//
//  GeneralTableView.swift
//  stori
//
//  Created by Alex on 24.09.2022.
//

import UIKit
import SpreadsheetView

class GeneralTableView: UIView {

    var tableHeight: CGFloat = 0
    var didSelectItem: ((String) -> Void)?
    private var textAlignment: NSTextAlignment = .center
    
    private var data: [[TableCellObject]] = []
    private var mergedItems: [CellRange] = []
    
    private var topLeftIndex: IndexPath = IndexPath(row: 0, column: 0)
    private var topRightIndex: IndexPath = IndexPath(row: 0, column: 0)
    private var bottomLeftIndex: IndexPath = IndexPath(row: 0, column: 0)
    private var bottomRightIndex: IndexPath = IndexPath(row: 0, column: 0)
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var spreadsheetView: SpreadsheetView!

    init(width: CGFloat, data: TableData, textAlignment: NSTextAlignment = .center) {
        self.textAlignment = textAlignment
        if let rows = data.data {
            var numberOfLines = rows.count
            for row in rows where row.map({ $0.isLargeCell ?? false }).contains(true) {
                let texts = row.map({ $0.text })
                if let max = texts.max(by: {$1.count > $0.count}) {
                    let label = UILabel()
                    label.text = max
                    let lines = label.countLines(width: (width - 3) / 2)
                    numberOfLines += (lines - 1)
                }
            }
            let newHeight: CGFloat = CGFloat((37 * numberOfLines) + numberOfLines + 2)
            self.tableHeight = newHeight
        } else {
            self.tableHeight = 0
        }
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: tableHeight))
        self.customInit()
        mergedItems = (data.mergedItems ?? []).map({ $0.asCellRange })
        self.loadData(data: data.data ?? [])
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
        Bundle.main.loadNibNamed("GeneralTableView", owner: self, options: nil)

        addSubview(contentView)
        contentView.addSubview(spreadsheetView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        spreadsheetView.frame = bounds
        spreadsheetView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        spreadsheetView.showsVerticalScrollIndicator = false
        spreadsheetView.showsHorizontalScrollIndicator = false
    }

    private func loadData(data: [[TableCellObject]]) {
        self.data = data
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        spreadsheetView.backgroundColor = .clear
        spreadsheetView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.identifier)
        spreadsheetView.gridStyle = .solid(width: 1, color: .white)

        checkMinimalIndex(&topLeftIndex, defaultIndex: IndexPath(row: 0, column: 0))
        checkMinimalIndex(&topRightIndex, defaultIndex: IndexPath(row: 0, column: (data.first?.count ?? 1) - 1))
        checkMinimalIndex(&bottomLeftIndex, defaultIndex: IndexPath(row: data.count - 1, column: 0))
        checkMinimalIndex(&bottomRightIndex, defaultIndex: IndexPath(row: data.count - 1,
                                                                     column: (data.first?.count ?? 1) - 1))

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

extension GeneralTableView: SpreadsheetViewDataSource {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if data[row].map({ $0.isLargeCell ?? false }).contains(true) {
            let texts = data[row].map({ $0.text })
            if let max = texts.max(by: {$1.count > $0.count}) {
                let label = UILabel()
                label.text = max
                let lines = label.countLines(width: (contentView.frame.width - 3) / 2)
                return CGFloat(36 * lines)
            }
        }
        return 37
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if (data.first?.count ?? 0) == 1 {
            return contentView.frame.width - 2
        }
        return (contentView.frame.width - 3) / 2
    }

    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return data.first?.count ?? 0
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return data.count
    }
}

extension UILabel {
    func countLines(width: CGFloat) -> Int {
        guard let myText = self.text as NSString? else {
            return 0
        }
        // Call self.layoutIfNeeded() if your view uses auto layout
        let rect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: self.font as Any],
                                            context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}

extension GeneralTableView: SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let mainCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: TextCell.identifier,
                                                           for: indexPath)
        if let cell = mainCell as? TextCell {
            var roundedCorners: UIRectCorner = []
            if indexPath == topLeftIndex {
                roundedCorners.insert(.topLeft)
            }
            if indexPath == topRightIndex {
                roundedCorners.insert(.topRight)
            }
            if indexPath == bottomLeftIndex {
                roundedCorners.insert(.bottomLeft)
            }
            if indexPath == bottomRightIndex {
                roundedCorners.insert(.bottomRight)
            }
            cell.setUp(color: data[indexPath.row][optional: indexPath.column]?.backgroundColor ?? .speaklBlueSolid,
                       roundedCorners: roundedCorners,
                       radius: roundedCorners.isEmpty ? 0 : 10,
                       text: data[indexPath.row][optional: indexPath.column]?.text,
                       textAlignment: textAlignment)
            return cell
        }
        return mainCell
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        spreadsheetView.deselectItem(at: indexPath, animated: true)
        if let item = data[indexPath.row][optional: indexPath.column],
           item.isClickable {
            didSelectItem?(item.text)
        }
    }

    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        return mergedItems
    }
}
