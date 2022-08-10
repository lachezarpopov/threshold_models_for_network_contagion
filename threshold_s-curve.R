# Linear threshold model with an s-shape probability function

# In this algorithm the deterministic activation function is replaced with the probabilistic sigmoid function:
# 1 / (1 + exp(-1*((fraction_activated - threshold)/0.025)))

#  g: igraph object
#  thresholds: node-specific activation thresholds (must be same length as number of vertices of the igraph)
#  seed: list of initially activated nodes

library(igraph)
library(dplyr)
library(zoo)
library(tidyverse)

LT5_SCurve <- function (seed, g, thresholds) {
  
  # setting the number of activated nodes to 0 for day 0
  timestamps_activated = 0
  
  # Setting the seed nodes to activated
  V(g)$activated <- FALSE
  for (v in seed) {
    V(g)[v]$activated <- TRUE
  }
  
  # Indicator of whether simulation should stop
  any.changes <- TRUE
  
  # simulation
  while(any.changes) {
    
    any.changes <- FALSE
    
    # adding the number of infected for the given timestamp/day
    timestamps_activated = c(timestamps_activated, sum(V(g)$activated))
    
    # Iterating through non-activated nodes
    for(v in V(g)) {
      if(! V(g)[v]$activated) {
        
        node_neighborhood <- neighbors(g, V(g)[v])
        total_neighbors <- length(node_neighborhood)
        activated_neighbors <- sum(node_neighborhood$activated)
        threshold = thresholds[v]
        fraction_activated = activated_neighbors / total_neighbors
        #print(threshold)
        #print(fraction_activated)
        
        # Calculating the fraction of activated neighbors
        
        q = 1 / (1 + exp(-1*((fraction_activated - threshold)/0.025)))
        
        random_num = runif(1, 0, 1)
        
        if (random_num <= q) {
          V(g)[v]$activated <- TRUE
          any.changes <- TRUE
        }
      }
    }
  }
  return(timestamps_activated)
  
  ## Un-comment below code if you only need the total number of activated nodes (e.g., when used in greedy search) and comment out the above return statement
  
  # total_activated = timestamps_activated[length(timestamps_activated)]
  # return(total_activated)
}