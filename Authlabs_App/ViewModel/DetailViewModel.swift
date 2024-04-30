//
//  SearchViewModel.swift
//  Authlabs_App
//
//  Created by Matthew on 4/25/24.
//

import Foundation
import SwiftSoup

final class DetailViewModel {
    var images: [UIImage] = []
    var resultData: ChatResultData
    var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, UIImage>!
    
    init(resultData: ChatResultData) {
        self.resultData = resultData
        Task {
            do {
                let result = try await kakaoImageSearch(keyword: resultData.keywords)
                switch result {
                case .success(let data):
                    await downloadImages(from: data.documents.map{ $0.imageURL })
                    applyInitialSnapshot(data: self.images)
                case .failure(let failure):
                    print("Kakao image search error: \(failure)")
                }

            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func applyInitialSnapshot(data: [UIImage]) {
        snapshot = .init()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureDataSource(imageList: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(
            collectionView: imageList,
            cellProvider: { collectionView,indexPath,itemIdentifier in
                guard
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchImageCell.identifier, for: indexPath)
                        as? SearchImageCell
                else {
                    return UICollectionViewCell()
                }
                cell.configure(image: self.images[indexPath.row])
                return cell
            })
        imageList.allowsSelection = false
        applyInitialSnapshot(data: self.images)
    }
}

extension DetailViewModel {
    func downloadImages(from urls: [String]) async {
        for urlString in urls.prefix(6) {
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                do {
                    let (data, _) = try await URLSession.shared.data(for: request)
                    if let image = UIImage(data: data) {
                        images.append(image)
                    }
                } catch {
                    print("Error downloading image from URL: \(urlString), \(error.localizedDescription)")
                }
            } else {
                print("Invalid URL: \(urlString)")
            }
        }
    }
    
    func kakaoImageSearch(keyword: [String]) async throws -> (Result<RequestImageSearch, NetworkError>){
        guard
            let urlReqest = NetworkURL.makeURLRequest(type: .kakao(keyword: keyword))
        else {
            return .failure(.invalidURLRequestError)
        }
        
        let result = try await Network<RequestImageSearch>().fetchSearchImageData(with: urlReqest)
        switch result {
        case .success(let success):
            return handleDecodedData(data: success)
        case .failure(let failure):
            return .failure(failure)
        }
    }
    
    func handleDecodedData<T: Decodable>(data: Data?) -> (Result<T, NetworkError>) {
        guard
            let data = data
        else {
            return .failure(.noDataError)
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(.decodingError)
        }
    }
    
    func fetchMovieImage(urlString: String) async throws -> (Result<Data, NetworkError>) {
        guard
            let url = URL(string: urlString)
        else {
            return .failure(.invalidURLError)
        }
        
        guard
            let urlRequest = NetworkURL.makeURLRequest(type: .image(url: url))
        else {
            return .failure(.invalidURLRequestError)
        }
        
        let result = try await Network<RequestImageSearch>().fetchSearchImageData(with: urlRequest)
        return result
    }
}
