# Introduction 
Provides a Dockerfile that contains the minimal dependencies to execute unit tests of [Hyperledger Indy Node](https://github.com/hyperledger/indy-node).

## Benefits
- No need to bother about the Python version installed on local machine.
- No need to include additional package repositories required to retrieve required libraries.
- Executes arbitrary *pytest* unit tests on local code base.

# Getting Started
1.	Build Docker image
2.	Configuration setting
3.	Execute tests

## Build Docker image
1.  Install [Docker](https://www.docker.com/)
2.  Open a shell, change to the *build* folder and execute the following command: 
    > docker build . 
    
    This creates an unnamed image an returns the image ID. 
3. You can also name (and tag) the image, e.g.
    > docker build -t my-test-container:latest . 
    
## Configuration settings
Before you can execute test on the 'indy-node'code, you have at least to set the following environment variables:
> INDY_NODE_PATH - Path to the root of 'indy-node' folder (must resolve to an absolute path)
> 
> INDY_PLENUM_PATH - Path to the root of 'indy-plenum' folder (must resolve to an absolute path)
> 
> DOCKER_IMAGE Tag or ID of the Docker image you built in the first step

Optionally, you can also specify the TEST_PATH as an environment variable (useful if you want the execute the same tests over and over again).

> TEST PATH - Path to test folder, relative to INDY_NODE_PATH.

## Execute tests
1.  Execute the script *run_docker.sh* located in the *run* folder.
2. The script provides the following configuration options:
    > -h Prints usage information
    >
    > -v Activates verbose mode
    > 
    > TEST_PATH Path to test folder, takes precedence over the respective environment variable

# Release Notes

## 1.0
Initial version