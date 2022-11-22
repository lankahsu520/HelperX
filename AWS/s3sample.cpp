//https://github.com/aws/aws-sdk-cpp/wiki/Building-the-SDK-from-source-on-EC2

#include <aws/core/Aws.h>
#include <aws/core/client/ClientConfiguration.h>
#include <aws/core/auth/AWSCredentialsProviderChain.h>
#include <aws/core/utils/logging/LogLevel.h>
#include <aws/s3/S3Client.h>
#include <aws/s3/model/GetObjectRequest.h>
#include <iostream>
#include <fstream>
#include <memory>

using namespace Aws;

int main(int argc, char *argv[])
{
	if (argc < 5) {
		std::cout << " Usage: s3sample <region-endpoint> <bucket> <object> <local destination path>\n"
							<< "Example: s3sample us-west-1 utilx9 demo_000.c demo_000.c_local" << std::endl;
		return 0;
	}

	SDKOptions options;
	options.loggingOptions.logLevel = Utils::Logging::LogLevel::Error;
	InitAPI(options);
	{
		Client::ClientConfiguration config;
		//config.endpointOverride = argv[1];
		config.region = "eu-west-1";
		config.scheme = Http::Scheme::HTTPS;

		S3::S3Client client(config);

		S3::Model::GetObjectRequest request;
		request.WithBucket(argv[2]).WithKey(argv[3]);
		request.SetResponseStreamFactory([argv] { return new std::fstream(argv[4], std::ios_base::out); });

		auto outcome = client.GetObject(request);
		if (outcome.IsSuccess()) {
			std::cout << "Completed!" << std::endl;
		} else {
			std::cout << "Failed with error: " << outcome.GetError() << std::endl;
		}
	}

	ShutdownAPI(options);
	return 0;
}