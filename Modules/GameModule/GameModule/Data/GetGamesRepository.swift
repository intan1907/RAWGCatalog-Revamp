//
//  GetGamesRepository.swift
//  GameModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import CoreModule
import Combine

public struct GetGamesRepository<
    RemoteDataSource: DataSource,
    Transformer: ParamMapper & ResponseMapper
>: Repository
where
    RemoteDataSource.Request == [String: Any],
    RemoteDataSource.Response == DAOGamesBaseClass,
    Transformer.DomainParam == GameParamModel,
    Transformer.RequestParam == [String: Any],
    Transformer.Response == DAOGamesBaseClass,
    Transformer.Domain == GamesModel
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    public typealias Request = GameParamModel
    public typealias Response = GamesModel
    
    private var remoteDataSource: RemoteDataSource
    private var mapper: Transformer
    
    public init(remoteDataSource: RemoteDataSource, mapper: Transformer) {
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }
    
    public func execute(request: GameParamModel?) -> AnyPublisher<GamesModel, Error> {
        guard let nonNilRequest = request else {
            fatalError("Request could not be empty")
        }

        let param = self.mapper.transformDomainParamToRequest(param: nonNilRequest)
        return self.remoteDataSource.execute(request: param)
            .map { gamesResponse -> GamesModel in
                return self.mapper.transformResponseToDomain(response: gamesResponse)
            }
            .eraseToAnyPublisher()
    }
}
