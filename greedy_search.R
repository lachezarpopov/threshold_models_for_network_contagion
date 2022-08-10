
# Greedy search algorithm for identifying the optimal set of seed node to maximize network activation. Adapted from https://github.com/JanAndrosiuk/disease-models-R/blob/main/greedy_search.R for compatibility with non-deterministic implementations of the threshold algorithm.

library(igraph)
library(dplyr)
library(tidyverse)
library(pbapply)

# n_best: size of seed set
# g: igraph object
# thresholds: node-specific activation thresholds (must be same length as number of vertices of the igraph)
# threshold_model: takes a function for the threshold model (e.g., deterministic, below-threshold adoption, s-shape adoption)
# model: either 'ic' or 'threshold'. Specifies whether the independent cascade or threshold model should be used for the greedy search algorithm.
# ic_iter: number of iterations to use in the independent cascade model.

accumulate_seeds = function(x, best.seeds) {
  return(c(x, best.seeds))
}

greedy_search <- function(n_best, g, thresholds, threshold_model, model="threshold", ic_iter=10, print_res=F) {
  # Store the best seeds in a vector
  best.seeds <- c()
  
  # Run each iteration on a set of potential seeds. We exclude the best seeds
  # from potential seeds list after each iteration.
  potential_seeds <- c(1:length(V(g)))
  
  test_seeds <- potential_seeds
  
  # Define the number of best seeds you would like to search for.
  if (model == "threshold") {
    
    for (n in 1:n_best) {
      
      # Store the best seed node for each iteration for the given model
      best.seeds[n] <- potential_seeds[which.max(sapply(
        test_seeds, threshold_model, g, thresholds
      ))]
      
      if (print_res){print(best.seeds[[n]])}
      
      # Subtract best seeds from potential seeds for the next iteration.
      potential_seeds <- potential_seeds[! potential_seeds %in% best.seeds[[n]]]
      test_seeds = lapply(potential_seeds, accumulate_seeds, best.seeds)
      
    }
  } else if (model == "ic") {
    
    for (n in 1:n_best) {
      
      # Store the best seed node for each iteration for the given model.
      best.seeds[n] <- potential_seeds[which.min(pbapply::pbsapply(
        test_seeds,
        function(node_seed, ic_iter, net.neighbors, net.size) {
          mean(replicate(ic_iter, IC_2(node_seed, net.neighbors, net.size)))
        },
        ic_iter, network.neighbors, network.size
      ))]
      
      if (print_res){print(best.seeds[[n]])}
      
      # Subtract best seeds from potential seeds for the next iteration.
      potential_seeds <- potential_seeds[! potential_seeds %in% best.seeds[[n]]]
      test_seeds = lapply(potential_seeds, accumulate_seeds, best.seeds)
    }
  }
  
  return(best.seeds)
}