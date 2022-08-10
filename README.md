# Deterministic and probabilistic threshold models for network contagion, including a greedy search algorithm

This repository includes three implementations of the threshold model for information diffusion within a network and a greedy search algorithm for identifying the optimal set of seed nodes.

## [Deterministic threshold model](https://github.com/lachezarpopov/threshold_models_for_network_contagion/blob/main/threshold_deterministic.R)
The deterministic threshold model is loosely based off of Dubov, Kolbey and Andrey's (2015) linear threshold model adapted to include node-specific thresholds and return the number of activated nodes at each step of the diffusion process.

## [Threshold model with probability of below-threshold adoption](https://github.com/lachezarpopov/threshold_models_for_network_contagion/blob/main/threshold_belowAdoption.R)
Adaptation of the deterministic linear threshold model with an added probability of below-threshold activation.

## [Threshold model with probabilistc S-shape adoption](https://github.com/lachezarpopov/threshold_models_for_network_contagion/blob/main/threshold_s-curve.R) 
An implementation of the threshold model with the following sigmoid activation function:

![image](https://user-images.githubusercontent.com/78442887/183962060-81ff0521-2eee-4e64-ad81-1b1f471cd3bf.png)

, where 
- x<sub>i</sub> is the proportion of node i's neighbours that are activated 
- θ<sub>i</sub> is the activation threshold of node i

## [Greedy search algorithm](https://github.com/lachezarpopov/threshold_models_for_network_contagion/blob/main/greedy_search.R)
This repository also includes a greedy search algorithm for identifying the optimal set of seed nodes for maximizing network activation. The algorithm is an adaptation of Androsiuk, Baer, Popov & Lupulesco's (2021) greedy search algorithm for compatibility with non-deterministic implementations of the threshold algorithm.

## Acknowledgements:
- Androsiuk J., Baer G., Popov L., & Lupulescu M. (2021). disease-models-R. Retrieved from https://github.com/JanAndrosiuk/disease-models-R
- Dubov M., Kolbey E., & Andrey S. (2015) . Magolego SNA - Lab 8. Retrieved from https://rstudio-pubs-static.s3.amazonaws.com/84771_c930a586c8054000b28750ae7dda93c3.html
