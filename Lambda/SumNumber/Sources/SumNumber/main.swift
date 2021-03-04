import AWSLambdaRuntime


struct SumRequest: Codable {
	let number1: Double
	let number2: Double
}


struct SumResponse: Codable {
	let result: Double?
	let errorMessage: String?
}

Lambda.run { (context, input: SumRequest, callback: @escaping (Result<SumResponse, Error>) -> Void) in
	callback(.success(SumResponse(result: input.number1 + input.number2, errorMessage: nil)))
}
