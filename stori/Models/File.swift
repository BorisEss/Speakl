//
//  File.swift
//  stori
//
//  Created by Alex on 06.01.2021.
//

import UIKit

// This specifies the chunk size for multiple chunks upload. Default size is `1MB`.
let chunkSize: Int = 1024 * 1000 // 1 MB chunk size

enum FileType {
    case image
    case video
    case audio
    case pdf
}

class File {
    var name: String
    var fileType: FileType
    init(name: String, fileType: FileType) {
        self.name = name
        self.fileType = fileType
    }
}

class LocalFile: File {
    
    var uploadHandler: ((Double?) -> Void)?
    
    var id: String?
    var image: UIImage?
    var url: String?
    var uploadProgress: Double? {
        didSet {
            uploadHandler?(uploadProgress)
        }
    }
    
    init(image: UIImage) {
        self.image = image
        super.init(name: String.uniqueName,
                   fileType: .image)
    }
    init(url: String, fileType: FileType) {
        self.url = url
        super.init(name: String.uniqueName,
                   fileType: fileType)
    }
    
    func upload() {
        if uploadProgress == nil, id == nil {
            switch fileType {
            case .image:
                guard let image = image else { return }
                Upload.image(image, name: name) { (progress) in
                    UIView.animate(withDuration: 0.1) {
                        self.uploadProgress = progress
                    }
                } completion: { id in
                    self.id = id
                }
            case .video, .audio, .pdf:
                // TODO: Upload other types of file
                break
            }
        } else if uploadProgress == nil, id != nil {
            self.uploadProgress = 1
        }
    }
}

class ChunkedFile: File {
    var id: String?
    
    var data: Data
    var chunks: [Chunk]
    
    var size: Int {
        return data.count
    }
    var md5: String {
        return Checksum.hash(data: data)
    }
    
    init(image: UIImage, name: String = String.uniqueName) {
        data = image.jpegData(compressionQuality: 1.0) ?? Data()
        
        let dataLen = data.count
        let fullChunks = Int(dataLen / chunkSize)
        let totalChunks = fullChunks + (dataLen % 1024 != 0 ? 1 : 0)

        self.chunks = []
        for chunkCounter in 0..<totalChunks {
            var chunk: Data
            let chunkBase = chunkCounter * chunkSize
            var diff = chunkSize
            if chunkCounter == (totalChunks - 1) {
                diff = dataLen - chunkBase
            }
            
            let range: Range<Data.Index> = (chunkBase..<(chunkBase + diff))
            let endBase = chunkBase + diff - 1
            chunk = data.subdata(in: range)
            chunks.append(Chunk(data: chunk, start: chunkBase, end: endBase))
        }
        
        super.init(name: name,
                   fileType: .image)
    }
}

struct Chunk {
    var data: Data
    var start: Int
    var end: Int
}
