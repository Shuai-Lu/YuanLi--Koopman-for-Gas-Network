Koopman-based Gas Network Model and Economic Dispatch
This repository contains MATLAB code for modeling gas networks using Koopman operators and performing economic dispatch based on the trained model.

1. Overview
The project is divided into two main components:

1.1 Gas Network Model:
- This module is designed to train the Koopman operator for a gas network.
- The main script to run is main.m.
- Running main.m will generate the Koopman_matrix, which contains the trained Koopman operator.

1.2 Economic Dispatch:
- This module utilizes the Koopman operator obtained from the Gas Network Model to perform economic dispatch.
- After obtaining the Koopman_matrix, place it in the Economic Dispatch directory.
- Run the main.m script in the Economic Dispatch folder to obtain the dispatch results.


2. Getting Started
2.1 Prerequisites
- MATLAB R2022b or later

2.2 Usage
（1） Training the Koopman Operator:
- Navigate to the Gas Network Model folder.
- Run the main.m script.
- The trained Koopman operator will be saved as Koopman_matrix.mat.

（2）Performing Economic Dispatch:
- Move the generated Koopman_matrix.mat to the Economic Dispatch folder.
- Run the main.m script in the Economic Dispatch folder to perform the economic dispatch.

2.3 Repository Structure
- Gas Network Model/ - Contains the scripts and functions for training the gas network Koopman operator.
- Economic Dispatch/ - Contains the scripts for performing economic dispatch using the trained Koopman operator.
