# Linear threshold model with below-threshold adoption

# Works similarly to the deterministic threshold model with an added probability of below-threshold activation.

# For a given node i, the following conditions hold true:
##  The node is activated if the proportion of activated neighbors is above Q1.
##  The node has a probability of being activated (q) if the proportion of activated neighbours is between Q2 and Q1.
##  The node remains inactive if the proportion of activated neighbours is below Q2.

# Q1, Q2 and q can be adjusted accordingly. The default values produce the same expected activation as the deterministic threshold model for the same threshold values

#  g: igraph object
#  thresholds: node-specific activation thresholds (must be same length as number of vertices of the igraph)
#  seed: list of initially activated nodes
#  q: probability of below-threshold adoption

library(igraph)
library(dplyr)
library(zoo)
library(tidyverse)

LT_belowAdoption <- function (seed, g, thresholds, q=0.1794872) {
  
  Q1s = thresholds * 1.1
  Q2s = thresholds * 0.2
  
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
        Q1 = Q1s[v]
        Q2 = Q2s[v]
        
        # Calculating the fraction of activated neighbors
        
        if (total_neighbors > 0 &&
            activated_neighbors / total_neighbors >= Q1) {
          V(g)[v]$activated <- TRUE
          any.changes <- TRUE
        }
        
        else if (total_neighbors > 0 &&
                 activated_neighbors / total_neighbors >= Q2) {
          
          random_num = runif(1, 0, 1)
          
          if (random_num <= q) {
            V(g)[v]$activated <- TRUE
            any.changes <- TRUE  
          }
        }
      }
    }
  }
  return(timestamps_activated)
  
  ## Un-comment below code if you only need the total number of activated nodes (e.g., when used in greedy search) and comment out the above return statement
  
  # total_activated = timestamps_activated[length(timestamps_activated)]
  # return(total_activated)
}