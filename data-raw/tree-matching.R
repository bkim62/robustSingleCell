# implement Jiang et al (1994) tree traversal
T_1 <- ReSET::binary_tree('a', 
                          left = ReSET::binary_tree('e',
                                                    left = ReSET::binary_tree('b'),
                                                    right = ReSET::binary_tree('c')),
                          right = ReSET::binary_tree('d'))

T_2 <- ReSET::binary_tree('a', 
                 left = ReSET::binary_tree('b'),
                 right = ReSET::binary_tree('f', 
                                            left = ReSET::binary_tree('c'),
                                            right = ReSET::binary_tree('d')))

# Create the cost matrix
ordered_T1 <- ReSET::postorder_labels(T_1)
ordered_T2 <- ReSET::postorder_labels(T_2)
cost_matrix <- matrix(
  apply(expand.grid(T1 = ordered_T1, T2 = ordered_T2), 1, 
        function(x) abs(as.numeric(charToRaw(x[1])) - as.numeric(charToRaw(x[2])))),
  nrow = length(ordered_T1), byrow = F)
rownames(cost_matrix) <- ordered_T1
colnames(cost_matrix) <- ordered_T2
cost_matrix <- rbind(lambda = rep(0.3, ncol(cost_matrix)), cost_matrix)
cost_matrix <- cbind(lambda = c(0, rep(0.3, nrow(cost_matrix)-1)), cost_matrix)
cost_matrix


