parseGraph <- function(fname) {
  f <- file(fname, open="r")
  
  # use R "environments" as a workaround for R not having native hashmaps
  graph <- new.env(hash=TRUE)
  
  lines <-readLines(f)
  for (i in 1:length(lines)){
    parts <- unlist(strsplit(lines[i], ' <-> '))
    to <- unlist(strsplit(parts[2], ', '))
    assign(parts[1], to, envir=graph)
  }
  
  close(f)
  graph
}

setIndex <- function(sets, elem) {
  which(unlist(lapply(sets, function(s) elem %in% s)))
}

findDisjointSets <- function(graph) {
  # collect all nodes
  nodes <- c()
  for (node in ls(graph)) {
    nodes <- union(nodes, union(c(node), graph[[node]]))
  }
  
  # put every node in its own set initially
  sets <- lapply(nodes, function(n) c(n))
  
  # merge the sets according to edges
  for (node1 in ls(graph)) {
    for (node2 in graph[[node1]]) {
      set1 <- setIndex(sets, node1)
      set2 <- setIndex(sets, node2)
      
      if (set1 != set2) {
        sets[[set1]] <- union(sets[[set1]], sets[[set2]])
        sets[[set2]] <- NULL 
      }
    }
  }
  sets
}

graph <- parseGraph("input.txt")
sets <- findDisjointSets(graph)
set0 <- sets[[setIndex(sets, "0")]]

cat("Part 1: ", length(set0), "\n")
cat("Part 2: ", length(sets), "\n")
