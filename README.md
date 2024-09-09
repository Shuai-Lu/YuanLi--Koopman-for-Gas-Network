# Koopman Operator-based Gas Network Model for Optimal Dispatch

## Description
This repository contains MATLAB code for modeling gas networks using Koopman operators and performing economic dispatch based on the trained model.

## Authors
* Yuan Li, School of Electrical Engineering, Southeast University, Nanjing, China
* Shuai Lu, School of Electrical Engineering, Southeast University, Nanjing, China

## Repository Structure
- Gas Network Model/ - Contains the scripts and functions for training the gas network Koopman operator.
- Economic Dispatch/ - Contains the scripts for performing economic dispatch using the trained Koopman operator.

## Overview
The project is divided into two main components:
### Gas Network Model:
- This module is designed to get the Koopman operator for a gas network.
- The main script to run is main.m.
- Running main.m will generate the Koopman_matrix, which contains the trained Koopman operator.
### Economic Dispatch:
- This module utilizes the Koopman operator obtained from the Gas Network Model to perform economic dispatch.
- After obtaining the Koopman_matrix, place it in the Economic Dispatch directory.
- Run the main.m script in the Economic Dispatch folder to obtain the dispatch results.

## Getting Started
### Prerequisites
- MATLAB R2022b or later
### Usage
（1）Training the Koopman Operator:
- Navigate to the Gas Network Model folder.
- Run the main.m script.
- The trained Koopman operator will be saved as Koopman_matrix.mat.
  
（2）Performing Economic Dispatch:
- Move the generated Koopman_matrix.mat to the Economic Dispatch folder.
- Run the main.m script in the Economic Dispatch folder to perform the economic dispatch.


