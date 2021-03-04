import AWSLambdaRuntime


struct SquarestRequest: Codable {
	let number: Double
}


struct SquarestResponse: Codable {
	let result: Double?
	let errorMessage: String?
}

Lambda.run { (context, input: SquarestRequest, callback: @escaping (Result<SquarestResponse, Error>) -> Void) in
	callback(.success(SquarestResponse(result: input.number * input.number, errorMessage: nil)))
}
