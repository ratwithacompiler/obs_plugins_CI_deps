#include <stdio.h>

#include <grpcpp/grpcpp.h>

using grpc::SslCredentials;
using grpc::SslCredentialsOptions;

int main() {
    auto options = SslCredentialsOptions();
    auto creds = SslCredentials(options);
    auto channel = grpc::CreateChannel("127.0.0.1", creds);
    grpc::ClientContext context;

    printf("hello\n");
    return 1;
}
