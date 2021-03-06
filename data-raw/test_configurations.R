# Find the best configuration for hierarchy construction
data('T3K')
data('T4K')

configurations <- list(c('mean', 'euclidean', 'complete'), c('mean', 'spearman', 'complete'), c('mean', 'pearson', 'complete'),
                       c('mean', 'euclidean', 'average'), c('mean', 'spearman', 'average'), c('mean', 'pearson', 'average'),
                       c('median', 'euclidean', 'complete'), list('median', 'spearman', 'complete'), list('median', 'pearson', 'complete'),
                       c('median', 'euclidean', 'average'), list('median', 'spearman', 'average'), list('median', 'pearson', 'average'))


lapply(configurations[7:12], function(configuration) {
  png(file = paste0('~/Desktop/', paste0(configuration, collapse = '_'), '.png'))
  par(mfrow= c(1, 2)); ReSET::test_hierarchy_construction(configuration)
  dev.off()
})


# best is median, Euclidean, complete or average
method = 'median'
dist_method = 'euclidean'
hclust_method = 'complete'
T3K_tree <- ReSET::construct_hierarchy(t(T3K$normalized_data), T3K$membership, 
                                       method = method, dist_method = dist_method,
                                       hclust_method = hclust_method)
T4K_tree <- ReSET::construct_hierarchy(t(T4K$normalized_data), T4K$membership, 
                                       method = method, dist_method = dist_method,
                                       hclust_method = hclust_method)


# Let's test the alignment configuration
configurations <- list(c('mean', 'euclidean'), c('mean', 'pearson'), c('mean', 'spearman'),
                       c('median', 'euclidean'), c('median', 'pearson'), c('median', 'spearman'))

lapply(configurations, function(configuration) {
  png(file = paste0('~/Desktop/', paste0(configuration, collapse = '_'), '.png'))
  ReSET::test_alignment_configuration(configuration)
  dev.off()
})


summary_method = 'median'
T3K_binary_tree <- with(T3K_tree, ReSET::as_binary_tree(hclust, data, membership, summary_method))
T4K_binary_tree <- with(T4K_tree, ReSET::as_binary_tree(hclust, data, membership, summary_method))

cost_matrix1 <- ReSET::cor_cost_matrix(T3K_binary_tree$summary_stats, T4K_binary_tree$summary_stats, method = 'spearman')
cost_matrix2 <- ReSET::cor_cost_matrix(T3K_binary_tree$summary_stats, T4K_binary_tree$summary_stats, method = 'pearson')
cost_matrix3 <- ReSET::euc_cost_matrix(T3K_binary_tree$summary_stats, T4K_binary_tree$summary_stats)

library(iheatmapr)

plot_heatmap(1 - cost_matrix1, name = 'spearman')
plot_heatmap(1 - cost_matrix2, name = 'pearson')
plot_heatmap(-cost_matrix3, name = '-euclidean')
