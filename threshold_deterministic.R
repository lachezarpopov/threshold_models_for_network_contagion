# Deterministic linear threshold model

# This threshold model is entirely deterministic. The contagion process is entirely dependent on the network structure.
# A node becomes activated when the proportion of activated neighbors reaches or exceeds the node's activation threshold. I.e. - activated_neighbors / total_neighbors >= threshold.

#  g: igraph object
#  thresholds: node-specific activation thresholds (must be same length as number of vertices of the igraph)
#  seed: list of initially activated nodes

library(igraph)
library(dplyr)
library(zoo)
library(tidyverse)

LT_model <- function (seed, g, thresholds) {
  
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
        
        # Calculating the fraction of activated neighbors
        
        if (total_neighbors > 0 &&
            activated_neighbors / total_neighbors >= threshold) {
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

# Adaptation of Dubov, Kolbey and Andrey's (2015) linear threshold model to include custom thresholds for different nodes and return the number of activated nodes at each step (timestamp) of the diffusion process.

# Sources:
# Dubov, M., Kolbey, E., & Andrey, S. (2015). Magolego SNA - Lab 8. Retrieved from https://rstudio-pubs-static.s3.amazonaws.com/84771_c930a586c8054000b28750ae7dda93c3.html