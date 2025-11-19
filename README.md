# NeuralHiddenMarkovModel-OneEmissionVariable

## Overview
This repository contains a MATLAB implementation of the Hidden Markov Model (HMM) used in Diomedi et al. (2021), Diomedi et al. (2022) and Vaccari et al. (2024) for analyzing spiking neural data.

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
- [Repository Structure](#repository-structure)
- [Contributing](#contributing)
- [License](#license)

## CITATION

If you use this repo, please cite the following works:

Vaccari, F. E., Diomedi, S., De Vitis, M., Filippini, M., & Fattori, P. (2024). Similar neural states, but dissimilar decoding patterns for motor control in parietal cortex. Network Neuroscience, 8(2), 486–516.

Diomedi, S., Vaccari, F. E., Hadjidimitrakis, K., & Fattori, P. (2022). Using HMM to Model Neural Dynamics and Decode Useful Signals for Neuroprosthetic Control. In N. Bouguila, W. Fan, & M. Amayri (A c. Di), Hidden Markov Models and Applications (pp. 59–79). Springer International Publishing.

Diomedi, S., Vaccari, F. E., Galletti, C., Hadjidimitrakis, K., & Fattori, P. (2021). Motor-like neural dynamics in two parietal areas during arm reaching. Progress in Neurobiology, 205, 102116.

## Introduction
This project implements an HMM to model and analyze spiking neural data, focusing on a single emission variable. The approach is based on the methods detailed in Diomedi et al. (2021).

## Installation
To install and use the code in this repository, follow these steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/sdiomedi/NeuralHiddenMarkovModel-OneEmissionVariable.git
    ```
2. Ensure MATLAB is installed on your machine.

## Usage
1. Navigate to the directory where you cloned the repository.
2. Open MATLAB and add the repository to your MATLAB path:
    ```matlab
    addpath(genpath('path_to_repository'));
    ```
3. Use the provided scripts and functions to run HMM analysis on your neural data.

## Repository Structure
- `Data`: Sample data for testing the HMM implementation.
- `Functions`: MATLAB functions necessary for the HMM.
- `Script`: Main script to execute the HMM analysis.

## Contributing
We welcome contributions! Please fork this repository, make your changes, and submit a pull request. For major changes, please open an issue first to discuss what you would like to change.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

