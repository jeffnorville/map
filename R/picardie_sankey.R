# interactive image
# sankey
library(networkD3)
nodes = data.frame("name" = 
                     c("Cropland", #node 0
                       "Forest",   #node 1
                       "Grassland",  #node 2
                       "Other",  #node 3
                       "Barley",
                       ))#node 4
links = as.data.frame(matrix(c(
  0, 1, 2, 1244020.59  ,
  0, 1, 2,  327068.643 ,
  0, 1, 2,  160049.9997 ,
  0, 1, 3,  219240.9032 ,
  1, 2, 4,  6.36  ,
  1, 3, 4,  5.62 ) ,
  # 0, 1,  8,  2.82  ,
  # 0, 1,  9,  2.27  ,
  # 0, 2, 10, 10.25  ,
  # 0, 2, 11,  5.78  ,
  # 0, 2, 12,  3.72  ,
  # 0, 2, 13,  2.48  ,
  # 0, 2, 14,  2.44  ,
  # 0, 2, 15,  2.14  ,
  # 0, 2, 16,  1.88  ,
  # 0, 2, 17,  1.51  ,
  # 0, 3, 18, 11.09  ,
  # 0, 3, 19,  8.74  ,
  # 0, 3, 20,  5.79  ,
  # 0, 3, 21,  4.92  ,
  # 0, 3, 22,  1.21 
  byrow = TRUE, ncol = 4))
names(links) = c("region", "dept", "sar", "value")
sankeyNetwork(Links = links, Nodes = nodes,
              Source = "region", Target = "dept",
              Value = "value", NodeID = "name",
              fontSize= 12, nodeWidth = 20)

