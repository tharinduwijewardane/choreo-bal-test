import ballerina/log;
import ballerina/http;
// import ballerina/url;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get greeting(string name) returns string|error {
        // Send a response back to the caller.
        if name is "" {
            return error("name should not be empty!");
        }
        log:printInfo("received name: " + name);

        _ = check getOpenidConfigurations("");

        return "Hello, " + name;
    }
}

public isolated function getOpenidConfigurations(string discoveryEndpoint) returns OpenIDConfiguration|error {
    log:printInfo("Retrieving openid configuration started");
    string discoveryEndpointUrl = "https://api.asgardeo.io/t/bifrost/oauth2/token/.well-known/openid-configuration";
    log:printInfo("SMART EP: " + discoveryEndpointUrl);
    http:Client discoveryEpClient = check new (discoveryEndpointUrl.toString());
    OpenIDConfiguration openidConfiguration = {};
    do {
        openidConfiguration = check discoveryEpClient->/;
    } on fail error err {
        log:printInfo("Error while retrieving openid configuration: ", err);
    }
    log:printInfo("Retrieving openid configuration ended");
    return openidConfiguration;
}

public type OpenIDConfiguration record {
    string issuer?;
    string authorization_endpoint?;
    string device_authorization_endpoint?;
    string token_endpoint?;
    string userinfo_endpoint?;
    string revocation_endpoint?;
    string introspection_endpoint?;
    string registration_endpoint?;
    string management_endpoint?;
    string jwks_uri?;
    string[] grant_types_supported?;
    string[] response_types_supported?;
    string[] subject_types_supported?;
    string[] id_token_signing_alg_values_supported?;
    string[] scopes_supported?;
    string[] token_endpoint_auth_methods_supported?;
    string[] claims_supported?;
    string[] code_challenge_methods_supported?;
};
