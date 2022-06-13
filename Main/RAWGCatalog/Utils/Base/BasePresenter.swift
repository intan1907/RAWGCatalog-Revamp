//
//  BasePresenter.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 01/06/22.
//

import Combine

public class BasePresenter: ObservableObject {
    
    public var cancellables: Set<AnyCancellable> = []
    
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false
    
}
