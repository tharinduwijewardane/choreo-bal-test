import ballerina/log;

int counter = 0;

public function main() {
    log:printInfo(string `hello world ${counter}`);
    counter = counter + 1;
}
