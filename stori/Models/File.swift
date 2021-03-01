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
    case audioMp3
    case audioM4a
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
    var finishedUpload: ((String) -> Void)?
    
    var id: String? {
        didSet {
            guard let id = id else { return }
            finishedUpload?(id)
        }
    }
    var image: UIImage?
    var url: String?
    var uploadProgress: Double? {
        didSet {
            uploadHandler?(uploadProgress)
        }
    }
    
    init(image: UIImage,
         name: String = String.uniqueName) {
        self.image = image
        super.init(name: name,
                   fileType: .image)
    }
    init(videoUrl: String,
         thumbnail: UIImage,
         name: String = String.uniqueName) {
        self.url = videoUrl
        self.image = thumbnail
        super.init(name: name,
                   fileType: .video)
    }
    
    init(url: String,
         fileType: FileType,
         name: String = String.uniqueName) {
        self.url = url
        if fileType == .audioMp3 || fileType == .audioM4a {
            self.image = UIImage(named: "file")
        }
        super.init(name: name,
                   fileType: fileType)
    }
    
    init(voiceOverUrl: String) {
        id = voiceOverUrl
        url = voiceOverUrl
        image = UIImage(named: "file")
        uploadProgress = 1
        super.init(name: "cs_recording_voice_over".localized,
                   fileType: .audioMp3)
    }
    
    func upload() {
        if uploadProgress == nil, id == nil {
            switch fileType {
            case .image:
                guard let image = image else { return }
                Upload.image(image, name: name) { (progress) in
                    self.uploadProgress = progress
                } completion: { id in
                    self.id = id
                }
            case .video, .audioMp3, .audioM4a, .pdf:
                guard let url = URL(string: url ?? "") else { return }
                Upload.media(url: url, name: name, fileType: fileType) { (progress) in
                    self.uploadProgress = progress
                } completion: { (id) in
                    self.id = id
                }
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
    
    init(url: URL, name: String = String.uniqueName, type: FileType) {
        data = Data()
        chunks = []
        do {
            data = try Data(contentsOf: url)
            let dataLen = data.count
            let fullChunks = Int(dataLen / chunkSize)
            let totalChunks = fullChunks + (dataLen % 1024 != 0 ? 1 : 0)
            
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
        } catch {
            print("Unable to load data: \(error)")
        }
        super.init(name: name, fileType: type)
    }
}

struct Chunk {
    var data: Data
    var start: Int
    var end: Int
}
